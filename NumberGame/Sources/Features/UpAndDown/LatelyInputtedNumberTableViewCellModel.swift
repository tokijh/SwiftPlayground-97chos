//
//  LatelyInputtedNumberTableViewCellModel.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/11.
//

import Foundation

class LatelyInputtedNumberTableViewCellModel: NSObject, NSCoding {

  var number: Int
  var result: String

  init(number: Int, result: String) {
    self.number = number
    self.result = result
  }

  required init?(coder: NSCoder) {
    self.number = coder.decodeInteger(forKey: "number")
    self.result = coder.decodeObject(forKey: "result") as? String ?? ""
  }

  func encode(with coder: NSCoder) {
    coder.encode(self.number, forKey: "number")
    coder.encode(self.result, forKey: "result")
  }
}
