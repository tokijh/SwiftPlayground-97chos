//
//  UpAndDownGameViewController.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/22.
//

import UIKit
import CoreData

final class UpAndDownGameViewController: UIViewController {

  // MARK: Module

  private enum Entity {
    static let score = "Score"
    static let log = "Log"
  }

  private enum GameState {
    case playing
    case end
  }

  private enum UserDefaultsKey {
    static let resultLogs = "resultLogs"
  }

  // MARK: Properties

  private var gameState: GameState = .playing
  private var answer: Int = 0
  private var lastInputNumber: Int? {
    didSet {
      if let lastInputNumber = self.lastInputNumber {
        self.inputNumberLabel.text = "\(lastInputNumber) 보다"
      } else {
        self.inputNumberLabel.text = nil
      }
    }
  }
  private var inputCount: Int = 0 {
    didSet {
      self.inputCountLabel.text = "\(self.inputCount)번 입력했습니다."
    }
  }
  private var isEarlySucceeded: Bool!
  private lazy var latelyResultLogsList: [NumberGameInputLog] = [] {
    didSet {
      self.saveToUserDefaults(self.latelyResultLogsList)
      if !(self.latelyResultLogsList.isEmpty) {
        self.latelyResultLogsTableView.isHidden = false
        self.tableViewTitle.isHidden = false
      }
    }
  }
  private let coreDataService: CoreDataServiceProtocol
  private var context: NSManagedObjectContext {
    let context = self.coreDataService.context
    return context ?? NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
  }


  // MARK: UI

  private lazy var descriptionLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    label.text = "1~100까지 중에서 숨겨진 하나의 숫자를 찾는 게임입니다."
    return label
  }()
  private lazy var inputNumberLabel: UILabel = { // 입력한 숫자
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textAlignment = .center
    return label
  }()
  private lazy var inputNumberStateLabel: UILabel = { // Up, Down 상태
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
    label.textAlignment = .center
    return label
  }()
  private lazy var inputCountLabel: UILabel = { // N 번 입력
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .body)
    label.textColor = .systemGray
    label.textAlignment = .center
    return label
  }()
  private lazy var button: UIButton = { // 입력하기, 다시 시작을 할 수 있는 버튼
    let button = UIButton()
    button.backgroundColor = .systemBlue
    return button
  }()
  private lazy var earlySuccessView: UIView = { // 3회 이하로 성공 시 노출될 축하 화면
    let view = UIView()
    view.backgroundColor = UIColor(red: 137, green: 196, blue: 244)
    view.alpha = 0
    view.transform = CGAffineTransform(translationX: 0, y: self.view.bounds.height)
    return view
  }()
  private lazy var earlySuccessCountLabel: UILabel = {  // 축하 화면 내 횟수 노출 텍스트 라벨
    let label = UILabel()
    label.font = UIFont.boldSystemFont(ofSize: 80)
    label.textAlignment = .center
    return label
  }()
  private lazy var earlySuccessIcon: UILabel = {  // 축하 화면 내 아이콘 라벨
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 50)
    label.textAlignment = .center
    label.text = "🎉"
    return label
  }()
  private lazy var earlySuccessTextLabel: UILabel = { // 축하 화면 내 메세지 라벨
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 30)
    label.textAlignment = .center
    return label
  }()
  private lazy var tableViewTitle: UILabel = {  // 테이블 뷰 상단에 노출될 타이틀 라벨
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .subheadline)
    label.text = "최근 입력한 숫자"
    return label
  }()
  private lazy var latelyResultLogsTableView: UITableView = {  // 하단에 표시될 최근 숫자 입력 테이블 뷰
    let tableView = UITableView()
    tableView.dataSource = self
    tableView.allowsSelection = false
    return tableView
  }()
  private lazy var scoreButton: UIBarButtonItem = {
    let barButton = UIBarButtonItem(title: "Score", style: .plain, target: self, action: #selector(self.didTapScoreButton))
    return barButton
  }()


  // MARK: Configuring

  private func configure() {
    self.title = "Up & Down"
    self.configureButton()
    self.configureTableViewCell()
    self.configureNavigationButton()
  }

  private func configureButton() {
    self.button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
  }

  private func configureTableViewCell() {
    self.latelyResultLogsTableView.register(LatelyResultCell.self, forCellReuseIdentifier: "latelyNumberCell")
  }

  private func configureNavigationButton() {
    self.navigationItem.rightBarButtonItem = self.scoreButton
  }


  // MARK: Initialize

  init(coreDataService: CoreDataServiceProtocol) {
    self.coreDataService = coreDataService
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.configure()
    self.layout()

    self.resetGame()
  }


  // MARK: Action

  @objc private func didTapButton() {
    switch self.gameState {
    case .playing:
      let viewController = InputNumberViewController()
      viewController.delegate = self
      self.present(viewController, animated: true)
      self.earlySuccessView.alpha = 0

    case .end:
      if self.isEarlySucceeded {
        self.earlySuccessViewHide(view: earlySuccessView)
        self.isEarlySucceeded = false
      } else {
        self.resetGame()
        self.clearData()
      }
    }
  }

  @objc private func didTapScoreButton() {
    let scoreViewController = ScoreViewController(coreDataService: self.coreDataService)
    self.navigationController?.pushViewController(scoreViewController, animated: true)
  }


  // MARK: Game

  private func resetGame() {
    self.gameState = .playing
    self.answer = Int.random(in: 0...100)
    self.lastInputNumber = nil
    self.inputCount = 0

    self.inputNumberLabel.text = nil
    self.inputNumberStateLabel.text = "❓"
    self.inputCountLabel.text = nil
    self.button.setTitle("입력하기", for: .normal)

    self.earlySuccessViewHide(view: self.earlySuccessView)
    self.isEarlySucceeded = false

    self.latelyResultLogsTableView.isHidden = true
    self.tableViewTitle.isHidden = true
  }

  private func confirmAnswer(number: Int) {
    self.lastInputNumber = number
    self.inputCount += 1

    var resultText: String!

    if self.answer == number {
      resultText = "🙆‍♀️🙆‍♂️"
      self.makeResultData(number: lastInputNumber ?? 0, result: resultText)
      self.setEndGame()
    } else if number < self.answer {
      resultText = "Up 👍"
      self.inputNumberStateLabel.text = resultText
      self.makeResultData(number: lastInputNumber ?? 0, result: resultText)
    } else if number > self.answer {
      resultText = "Down 👎"
      self.inputNumberStateLabel.text = resultText
      self.makeResultData(number: lastInputNumber ?? 0, result: resultText)
    }
  }

  private func setEndGame() {
    self.gameState = .end
    if self.inputCount < 4 {
      self.earlySuccessViewShow(view: earlySuccessView)
      self.isEarlySucceeded = true
    }

    self.inputNumberLabel.text = "정답입니다."
    self.inputNumberStateLabel.text = "💯"
    self.inputCountLabel.text = "\(self.inputCount)번 만에 성공!"

    self.saveScoreToCoreData(inputCount: self.inputCount)

    self.button.setTitle("다시 시작", for: .normal)
  }

  private func earlySuccessViewShow(view: UIView) {
    self.earlySuccessCountLabel.text = "\(self.inputCount)회"
    self.earlySuccessTextLabel.text = "만에 성공!"

    UIView.animate(withDuration: 0.7,
                   delay: 0,
                   options: .curveEaseOut,
                   animations: {
                    view.transform = CGAffineTransform.identity
                    view.alpha = 1
                   })
  }

  private func earlySuccessViewHide(view: UIView, delay: TimeInterval = 0) {
    UIView.animate(withDuration: 0.7,
                   delay: delay,
                   options: .curveEaseIn,
                   animations: {
                    view.transform = CGAffineTransform.init(translationX: 0, y: self.view.bounds.height)
                    view.alpha = 0
                   })
  }

  private func makeResultData(number: Int, result: String) {
    let resultData: NumberGameInputLog = NumberGameInputLog(inputNumber: number, result: result)
    appendLatelyInputNumberList(resultData)
  }

  private func appendLatelyInputNumberList(_ resultData: NumberGameInputLog) {
    self.latelyResultLogsList.append(resultData)
    self.latelyResultLogsTableView.reloadData()
  }

  private func saveToUserDefaults(_ list: [NumberGameInputLog]) {
    let encodedList = list.map { self.encodeToJson(rawData: $0) }
    let compactedList = encodedList.compactMap{ $0 }
    UserDefaults.standard.setValue(compactedList, forKey: UserDefaultsKey.resultLogs)
  }

  private func encodeToJson(rawData: NumberGameInputLog) -> String? {
    let encoder = JSONEncoder()
    let encodedData = try? encoder.encode(rawData)
    guard let JSONData = encodedData, let JSONString = String(data: JSONData, encoding: .utf8) else {
      return nil
    }
    return JSONString
  }

  private func clearData() {
    self.latelyResultLogsList = []
  }

  private func changeDateToString() -> String {
    let dateFormatter = DateFormatter()
    dateFormatter.dateFormat = "yyyy년 MM월 dd일 HH:mm"

    return dateFormatter.string(from: Date())
  }

  private func saveScoreToCoreData(inputCount: Int) {
    let context = self.context
    guard let scoreObject = NSEntityDescription.insertNewObject(forEntityName: Entity.score, into: context) as? ScoreMO else { return }
    scoreObject.date = self.changeDateToString()
    scoreObject.inputCount = Int64(inputCount)
    self.saveLogsToCoreData(ScoreObject: scoreObject)

    do {
      try context.save()
    } catch {
      context.rollback()
    }
  }

  private func addLogToScoreObject(result: NumberGameInputLog, context: NSManagedObjectContext, ScoreObject: ScoreMO) {

    guard let logObject = NSEntityDescription.insertNewObject(forEntityName: Entity.log, into: context) as? LogMO else { return }
    logObject.result = result.result
    logObject.inputtedNumber = Int64(result.inputNumber)
    ScoreObject.addToLogs(logObject)
  }

  private func saveLogsToCoreData(ScoreObject: ScoreMO) {
    let context = self.context
    for row in self.latelyResultLogsList {
      self.addLogToScoreObject(result: row, context: context ,ScoreObject: ScoreObject)
    }
  }


  // MARK: Layout

  private func layout() {
    let windowSafeAreaInsets = UIApplication.shared.windows.first(where: \.isKeyWindow)?.safeAreaInsets ?? .zero

    self.view.addSubview(self.descriptionLabel)
    self.view.addSubview(self.inputNumberLabel)
    self.view.addSubview(self.inputNumberStateLabel)
    self.view.addSubview(self.inputCountLabel)
    self.view.addSubview(self.button)
    self.view.addSubview(self.latelyResultLogsTableView)
    self.view.addSubview(self.tableViewTitle)
    self.view.addSubview(self.earlySuccessView)

    self.earlySuccessView.addSubview(self.earlySuccessIcon)
    self.earlySuccessView.addSubview(self.earlySuccessTextLabel)
    self.earlySuccessView.addSubview(self.earlySuccessCountLabel)

    self.descriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.view.safeAreaLayoutGuide).offset(16)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    self.inputNumberLabel.snp.makeConstraints {
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(56)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    self.inputNumberStateLabel.snp.makeConstraints {
      $0.top.equalTo(self.inputNumberLabel.snp.bottom).offset(32)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    self.inputCountLabel.snp.makeConstraints {
      $0.top.equalTo(self.inputNumberStateLabel.snp.bottom).offset(40)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    self.earlySuccessView.snp.makeConstraints {
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(20)
      $0.bottom.equalTo(self.button.snp.top).offset(-20)
      $0.leading.trailing.equalToSuperview().inset(16)
    }
    self.earlySuccessIcon.snp.makeConstraints {
      $0.top.equalToSuperview().inset(10)
      $0.centerX.equalToSuperview()
    }
    self.earlySuccessCountLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
    self.earlySuccessTextLabel.snp.makeConstraints {
      $0.bottom.equalToSuperview().inset(10)
      $0.centerX.equalToSuperview()
    }
    self.tableViewTitle.snp.makeConstraints {
      $0.top.equalTo(self.descriptionLabel.snp.bottom).offset(240)
      $0.leading.equalTo(self.descriptionLabel)
    }
    self.latelyResultLogsTableView.snp.makeConstraints {
      $0.top.equalTo(self.tableViewTitle.snp.bottom)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(self.button.snp.top).offset(-20)
    }
    self.button.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(56 + windowSafeAreaInsets.bottom)
      $0.bottom.equalToSuperview()
    }
    self.button.contentEdgeInsets.bottom = windowSafeAreaInsets.bottom
  }

}

extension UpAndDownGameViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.latelyResultLogsList.count
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

    let row = self.latelyResultLogsList[indexPath.row]

    let cell = tableView.dequeueReusableCell(withIdentifier: "latelyNumberCell") ?? UITableViewCell()

    cell.textLabel?.text = "\(row.inputNumber)"
    cell.detailTextLabel?.text = "\(row.result)"

    return cell
  }
}

extension UpAndDownGameViewController: InputNumberViewControllerDelegate {
  func didInputNumber(_ number: Int) {
    self.confirmAnswer(number: number)
  }
}
