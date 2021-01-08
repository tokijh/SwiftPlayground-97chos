//
//  InputNumberViewController.swift
//  NumberGame
//
//  Created by 윤중현 on 2021/01/07.
//

import UIKit

protocol InputNumberViewControllerDelegate: class {
  func didInputNumber(_ number: Int)
}

final class InputNumberViewController: UIViewController {

  // MARK: Properties

  weak var delegate: InputNumberViewControllerDelegate?
  private var inputText: String = "" {
    didSet {
      self.inputNumberLabel.text = inputText
    }
  }


  // MARK: UI

  private lazy var inputNumberLabel: UILabel = {
    let label = UILabel()
    label.font = UIFont.systemFont(ofSize: 50, weight: .heavy)
    label.textAlignment = .center
    label.numberOfLines = 0
    return label
  }()
  private lazy var numberButtons: [UIButton] = (0...9).map { number -> UIButton in
    let button = UIButton()
    button.setTitle("\(number)", for: .normal)
    button.setTitleColor(.label, for: .normal)
    button.tag = number
    return button
  }
  private lazy var deleteButton: UIButton = {
    let button = UIButton()
    button.setTitle("X", for: .normal)
    button.setTitleColor(.label, for: .normal)
    return button
  }()
  private lazy var confirmButton: UIButton = {
    let button = UIButton()
    button.setTitle("확인", for: .normal)
    button.backgroundColor = .systemBlue
    return button
  }()


  // MARK: Configuring

  private func configure() {
    self.configureNumberButtons()
    self.configureDeleteButton()
    self.configureConfirmButton()
  }

  private func configureNumberButtons() {
    self.numberButtons.forEach { button in
      button.addTarget(self, action: #selector(self.didTapNumberButton(_:)), for: .touchUpInside)
    }
  }

  private func configureDeleteButton() {
    self.deleteButton.addTarget(self, action: #selector(self.didTapDeleteButton), for: .touchUpInside)
  }

  private func configureConfirmButton() {
    self.confirmButton.addTarget(self, action: #selector(self.didTapConfirmButton), for: .touchUpInside)
  }


  // MARK: View Lifecycle

  override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = .systemBackground
    self.configure()
    self.layout()
  }


  // MARK: Action

  @objc private func didTapNumberButton(_ button: UIButton) {
    self.inputText += "\(button.tag)"
  }

  @objc private func didTapDeleteButton() {
    self.inputText = String(self.inputText.dropLast())
  }

  @objc private func didTapConfirmButton() {
    guard let number = Int(self.inputText) else { return }
    self.delegate?.didInputNumber(number)
    self.dismiss(animated: true)
  }


  // MARK: Layout

  private func layout() {
    let contentView = self.layoutContentView()
    let keypadView = self.layoutKeypadView()

    self.view.addSubview(contentView)
    self.view.addSubview(self.confirmButton)
    self.view.addSubview(keypadView)

    contentView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.confirmButton.snp.top)
    }
    self.confirmButton.snp.makeConstraints {
      $0.width.equalToSuperview()
      $0.height.equalTo(56)
      $0.bottom.equalTo(keypadView.snp.top)
    }
    keypadView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalTo(self.view.safeAreaLayoutGuide)
    }
  }

  private func layoutContentView() -> UIView {
    let contentView = UIView()
    contentView.addSubview(self.inputNumberLabel)
    self.inputNumberLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.trailing.equalToSuperview().inset(24)
    }
    return contentView
  }

  private func layoutKeypadView() -> UIView {
    let horizontalStackViews = self.numberButtons
      .reversed() // 0~9 를 9~0 으로 변경
      .chunked(into: 3) // [9,8,7,6...3,2,1,0] 을 [[9,8,7],[6,5,4],[3,2,1],[0]] 으로 변경
      .map { coulums -> UIStackView in
        let coulums: [UIButton] = coulums.reversed() // [9,8,7] 을 [7,8,9] 로 변경
        let horizontalStackView = UIStackView(arrangedSubviews: coulums)
        horizontalStackView.alignment = .fill
        horizontalStackView.distribution = .fillEqually
        horizontalStackView.axis = .horizontal
        return horizontalStackView
      }
    horizontalStackViews.last?.insertArrangedSubview(UIView(), at: 0) // [0] 앞에 빈 칸 추가
    horizontalStackViews.last?.addArrangedSubview(self.deleteButton) // [, 0] 에 del 버튼 추가

    (self.numberButtons + [self.deleteButton]).forEach { button in
      button.snp.makeConstraints {
        $0.height.equalTo(button.snp.width).multipliedBy(0.5) // 버튼 높이를 가로의 1/2 으로 변경
      }
    }

    let keypadStackView = UIStackView(arrangedSubviews: horizontalStackViews)
    keypadStackView.alignment = .fill
    keypadStackView.distribution = .fillEqually
    keypadStackView.axis = .vertical
    return keypadStackView
  }
}
