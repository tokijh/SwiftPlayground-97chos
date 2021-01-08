//
//  Array+Chunked.swift
//  NumberGame
//
//  Created by 윤중현 on 2021/01/07.
//

extension Array {
  func chunked(into size: Int) -> [[Element]] {
    return stride(from: 0, to: count, by: size).map {
      Array(self[$0 ..< Swift.min($0 + size, count)])
    }
  }
}
