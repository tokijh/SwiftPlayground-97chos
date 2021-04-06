//
//  UIViewController+Alert.swift
//  NumberGame
//
//  Created by sangho Cho on 2021/04/07.
//

import Foundation
import UIKit

extension UIViewController {
  func inputTextAlert(title: String, message: String? = nil, isCancel: Bool = false, completion: @escaping (UIAlertController) -> Void) {
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)

    alert.addTextField(configurationHandler: nil)

    alert.addAction(UIAlertAction(title: "확인", style: .default) { _ in
      if let inputtedText = alert.textFields?[0].text, inputtedText.isEmpty {
        self.dismiss(animated: true) {
          let caution = UIAlertController(title: "이름을 입력해주세요.", message: nil, preferredStyle: .alert)
          caution.addAction(UIAlertAction(title: "확인", style: .default) { _ in
            self.dismiss(animated: true) {
              self.present(alert, animated: true)
            }
          })

          self.present(caution, animated: true)
        }
      } else {
        completion(alert)
      }
    })

    if isCancel {
      alert.addAction(UIAlertAction(title: "취소", style: .cancel))
    }

    self.present(alert, animated: true)
  }
}
