//
//  LatelyInputtedNumberTableViewCellModel.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/11.
//

import Foundation

struct LatelyInputtedNumberTableViewCellModel: Codable  {

  var number: Int
  var result: String

  init(number: Int, result: String) {
    self.number = number
    self.result = result
  }

}
