//
//  ScoreCell.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/18.
//

import UIKit
import SnapKit

class ScoreCell: UITableViewCell {

  // MARK: UI

  private let playDate: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 13)
    return label
  }()
  private let playCount: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 15)
    label.textColor = .systemGray2
    return label
  }()
  private let playerName: UILabel = {
    let label = UILabel()
    label.font = .systemFont(ofSize: 17, weight: .bold)
    return label
  }()


  // MARK: Initializing

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    self.layout()
    self.configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configure() {
    self.selectionStyle = .none
    self.accessoryType = .disclosureIndicator
  }

  func set(date: String, count: String, name: String) {
    self.playDate.text = date
    self.playCount.text = count
    self.playerName.text = name
  }

  // MARK: Layout

  private func layout() {
    self.contentView.addSubview(self.playCount)
    self.contentView.addSubview(self.playDate)
    self.contentView.addSubview(self.playerName)

    self.playerName.snp.makeConstraints {
      $0.bottom.equalTo(self.contentView.snp.centerY).offset(-5)
      $0.leading.equalToSuperview().inset(20)
    }
    self.playDate.snp.makeConstraints {
      $0.top.equalTo(self.contentView.snp.centerY).offset(5)
      $0.leading.equalToSuperview().inset(20)
    }
    self.playCount.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(10)
    }
  }
}

