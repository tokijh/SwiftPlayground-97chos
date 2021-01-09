//
//  UIImageFromUIColor.swift
//  NumberGame
//
//  Created by 윤중현 on 2021/01/09.
//

import UIKit

extension UIImage {
  convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    let rect = CGRect(origin: .zero, size: size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
    color.setFill()
    UIRectFill(rect)
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let cgImage = image?.cgImage else { return nil }
    self.init(cgImage: cgImage)
  }
}

extension UIColor {
  // RGB 코드 변환
  convenience init(red: UInt8, green: UInt8, blue: UInt8, alpha: CGFloat = 1) {
    self.init(red: CGFloat(red) / 255, green: CGFloat(green) / 255, blue: CGFloat(blue) / 255, alpha: alpha)
  }

  // Hex 코드 변환
  convenience init?(hex hexString: String) {
    guard hexString.hasPrefix("#") else { return nil }
    let hexString = String(hexString.dropFirst())
    let scanner = Scanner(string: hexString)
    var hexNumber: UInt64 = 0
    guard scanner.scanHexInt64(&hexNumber) else { return nil }
    let red, green, blue, alpha: CGFloat
    if hexString.count == 8 { // RGBA
      red = CGFloat((hexNumber & 0xff000000) >> 24) / 255
      green = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
      blue = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
      alpha = CGFloat(hexNumber & 0x000000ff) / 255
      self.init(red: red, green: green, blue: blue, alpha: alpha)
    } else if hexString.count == 6 { // RGB
      red = CGFloat((hexNumber & 0xff0000) >> 24) / 255
      green = CGFloat((hexNumber & 0x00ff00) >> 16) / 255
      blue = CGFloat((hexNumber & 0x00ff) >> 8) / 255
      self.init(red: red, green: green, blue: blue, alpha: 1.0)
    } else {
      return nil
    }
  }
}


