//
//  UIView+Extension.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import Foundation
import UIKit

extension UIView {
    
    @IBInspectable var borderColor: UIColor? {
        set {
            layer.borderColor = newValue?.cgColor
        }
        get {
            guard let color = layer.borderColor else {
                return nil
            }
            return UIColor(cgColor: color)
        }
    }
    @IBInspectable var borderWidth: CGFloat {
        set {
            layer.borderWidth = newValue
        }
        get {
            return layer.borderWidth
        }
    }
    
    @IBInspectable
    var cornerRadius: CGFloat {
        set { layer.cornerRadius = newValue }
        get { return layer.cornerRadius     }
    }
    
    func loadViewFromNib(nibName: String) -> UIView? {
        let bundle = Bundle( for: type(of: self))
        let nib = UINib (nibName: nibName, bundle: bundle)
        return nib.instantiate (withOwner: self, options: nil).first as? UIView
    }
}
