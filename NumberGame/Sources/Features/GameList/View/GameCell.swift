//
//  GameCell.swift
//  NumberGame
//
//  Created by 윤중현 on 2020/12/22.
//

import UIKit

final class GameCell: UITableViewCell {

  // MARK: Configuring

  func set(title: String) {
    self.textLabel?.text = title
  }
}
