//
//  LogCell.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/19.
//

import UIKit

class LogCell: UITableViewCell {

  //MARK: initializing

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: .value1, reuseIdentifier: reuseIdentifier)
    self.configure()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }


  // MARK: Configuring

  private func configure() {
    self.selectionStyle = .none
  }

  func set(inputNumber: Int, result: String) {
    self.textLabel?.text = "\(inputNumber)"
    self.detailTextLabel?.text = result
  }
}
