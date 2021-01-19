//
//  String+Chunked.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/01/19.
//

extension String {
  func dateTransformToTitle() -> String {
    let idx: String.Index = self.index(self.startIndex, offsetBy: 5)
    return String(self[idx...])
  }
}
