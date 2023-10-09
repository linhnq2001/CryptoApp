//
//  UIViewController+Extension.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 08/10/2023.
//

import Foundation
import UIKit

extension UIViewController {
    func showToast(message: String, font: UIFont,completion: @escaping (Bool)->Void) {
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height - 100, width: 150, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0,delay: 0.1,options: .curveEaseIn, animations: {
            toastLabel.alpha = 0.0
        }) { isCompleted in
            toastLabel.removeFromSuperview()
            completion(isCompleted)
        }
    }
}
