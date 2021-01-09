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
  private lazy var congratulationView: UIView = {
    let view = UIView()
    view.backgroundColor = .white
    view.layer.cornerRadius = 5
    view.layer.borderWidth = 1
    view.layer.borderColor = UIColor.black.cgColor
    view.clipsToBounds = true
    view.isHidden = true
    return view
  }()
  private lazy var congratulationTitleLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.preferredFont(forTextStyle: .title1)
    return label
  }()
  private lazy var congratulationDescriptionLabel: UILabel = {
    let label = UILabel()
    label.numberOfLines = 0
    return label
  }()
  private lazy var congratulationDismissButton: UIButton = {
    let button = UIButton()
    button.setTitle("닫기", for: .normal)
    button.backgroundColor = .systemBlue
    return button
  }()


  // MARK: Configuring

  private func configure() {
    self.title = "Up & Down"
    self.configureButton()
    self.configureCongratulationDismissButton()
  }

  private func configureButton() {
    self.button.addTarget(self, action: #selector(self.didTapButton), for: .touchUpInside)
  }

  private func configureCongratulationDismissButton() {
    self.congratulationDismissButton.addTarget(self, action: #selector(self.didTapCongratulationDismissButton), for: .touchUpInside)
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

    case .end:
      self.resetGame()
    }
  }

  @objc private func didTapCongratulationDismissButton() {
    self.dismissCongratulationView()
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

    self.inputNumberLabel.text = "정답입니다."
    self.inputNumberStateLabel.text = "💯"
    self.inputCountLabel.text = "\(self.inputCount)번 만에 성공!"
    self.button.setTitle("다시 시작", for: .normal)

    if self.inputCount <= 3 {
      self.showCongratulationView()
    }
  }

  private func showCongratulationView() {
    self.congratulationTitleLabel.text = "\(self.inputCount)번 만에 성공!"
    self.congratulationDescriptionLabel.text = [
      "운도 실력입니다.\n당신의 운에 Cheers 🍻",
      "당신은 최고입니다❤️",
      "세상에나 이걸 해내네요 ┏(ºдº)┛",
    ].randomElement()

    self.congratulationView.isHidden = false
    self.congratulationView.alpha = 0

    // 화면 하단에서 화면 중앙으로 올라오는 애니메이션을 구현하기 위해 먼저 화면 하단으로 이동함.
    self.congratulationView.center = {
      var center = self.view.center
      center.y = self.view.frame.height
      return center
    }()
    UIView.animate(withDuration: 0.5) {
      self.congratulationView.alpha = 1
      self.congratulationView.center = self.view.center // 화면 중앙으로 이동
    }
  }

  private func dismissCongratulationView() {
    UIView.animate(
      withDuration: 0.5,
      animations: {
        self.congratulationView.alpha = 0
      },
      completion: { _ in
        self.congratulationView.isHidden = true
      }
    )
  }


  // MARK: Layout

  private func layout() {
    let windowSafeAreaInsets = UIApplication.shared.windows.first(where: \.isKeyWindow)?.safeAreaInsets ?? .zero

    self.view.addSubview(self.descriptionLabel)
    self.view.addSubview(self.inputNumberLabel)
    self.view.addSubview(self.inputNumberStateLabel)
    self.view.addSubview(self.inputCountLabel)
    self.view.addSubview(self.button)

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
    self.button.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(56 + windowSafeAreaInsets.bottom)
      $0.bottom.equalToSuperview()
    }
    self.button.contentEdgeInsets.bottom = windowSafeAreaInsets.bottom

    self.layoutCongratulationView()
  }

  private func layoutCongratulationView() {
    let emojiLabel = UILabel()
    emojiLabel.font = UIFont.systemFont(ofSize: 70, weight: .heavy)
    emojiLabel.text = "🎉"
    emojiLabel.textAlignment = .center

    self.congratulationView.addSubview(emojiLabel)
    self.congratulationView.addSubview(self.congratulationTitleLabel)
    self.congratulationView.addSubview(self.congratulationDescriptionLabel)
    self.congratulationView.addSubview(self.congratulationDismissButton)

    emojiLabel.snp.makeConstraints {
      $0.top.equalToSuperview()
      $0.width.equalToSuperview()
      $0.width.equalTo(200)
      $0.height.equalTo(100)
    }
    self.congratulationTitleLabel.snp.makeConstraints {
      $0.top.equalTo(emojiLabel.snp.bottom).offset(8)
      $0.leading.trailing.equalToSuperview().inset(2)
    }
    self.congratulationDescriptionLabel.snp.makeConstraints {
      $0.top.equalTo(self.congratulationTitleLabel.snp.bottom).offset(4)
      $0.leading.trailing.equalToSuperview().inset(2)
    }
    self.congratulationDismissButton.snp.makeConstraints {
      $0.top.equalTo(self.congratulationDescriptionLabel.snp.bottom).offset(16)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
      $0.height.equalTo(48)
    }

    self.view.addSubview(self.congratulationView)
    self.congratulationView.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }
}

extension UpAndDownGameViewController: InputNumberViewControllerDelegate {
  func didInputNumber(_ number: Int) {
    self.confirmAnswer(number: number)
  }
}
