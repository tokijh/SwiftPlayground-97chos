//
//  UpAndDownGameViewController.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/22.
//

import UIKit

final class UpAndDownGameViewController: UIViewController {

  // MARK: Module

  private enum GameState {
    case playing
    case end
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


  // MARK: Configuring

  private func configure() {
    self.title = "Up & Down"
    self.configureButton()
  }

  private func configureButton() {
    self.button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
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
      } else {
        self.resetGame()
      }
    }
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
  }

  private func confirmAnswer(number: Int) {
    self.lastInputNumber = number
    self.inputCount += 1

    if self.answer == number {
      self.setEndGame()
    } else if number < self.answer {
      self.inputNumberStateLabel.text = "Up 👍"
    } else if number > self.answer {
      self.inputNumberStateLabel.text = "Down 👎"
    }
  }

  private func setEndGame() {
    self.gameState = .end
    if self.inputCount < 4 {
      self.earlySuccessViewShow(view: earlySuccessView)
    }

    self.inputNumberLabel.text = "정답입니다."
    self.inputNumberStateLabel.text = "💯"
    self.inputCountLabel.text = "\(self.inputCount)번 만에 성공!"

    self.button.setTitle("다시 시작", for: .normal)
  }

  private func earlySuccessViewShow(view: UIView) {
    self.isEarlySucceeded = true

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
    self.isEarlySucceeded = false

    UIView.animate(withDuration: 0.7,
                   delay: delay,
                   options: .curveEaseIn,
                   animations: {
                    view.transform = CGAffineTransform.init(translationX: 0, y: self.view.bounds.height)
                    view.alpha = 0
                   })
  }


  // MARK: Layout

  private func layout() {
    let windowSafeAreaInsets = UIApplication.shared.windows.first(where: \.isKeyWindow)?.safeAreaInsets ?? .zero

    self.view.addSubview(self.descriptionLabel)
    self.view.addSubview(self.inputNumberLabel)
    self.view.addSubview(self.inputNumberStateLabel)
    self.view.addSubview(self.inputCountLabel)
    self.view.addSubview(self.button)
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
    self.button.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(56 + windowSafeAreaInsets.bottom)
      $0.bottom.equalToSuperview()
    }
    self.button.contentEdgeInsets.bottom = windowSafeAreaInsets.bottom
  }

}

extension UpAndDownGameViewController: InputNumberViewControllerDelegate {
  func didInputNumber(_ number: Int) {
    self.confirmAnswer(number: number)
  }
}
