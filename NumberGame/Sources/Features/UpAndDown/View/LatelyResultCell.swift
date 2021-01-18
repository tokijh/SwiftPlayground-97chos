//
//  LatelyResultCell.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/16.
//

import Foundation
import UIKit

class LatelyResultCell: UITableViewCell {

  
  // MARK: Initializing

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
}
