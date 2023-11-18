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

extension UIView {
    func addShadow(){
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOpacity = 1
        self.layer.shadowOffset = CGSize.zero
        self.layer.shadowRadius = 5
    }
}
