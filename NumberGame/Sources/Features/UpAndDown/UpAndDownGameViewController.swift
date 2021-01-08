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

    case .end:
      self.resetGame()
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
  }
}

extension UpAndDownGameViewController: InputNumberViewControllerDelegate {
  func didInputNumber(_ number: Int) {
    self.confirmAnswer(number: number)
  }
}
