//
//  InputTextField.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import UIKit

@IBDesignable
final class InputTextField: UIView {
    @IBOutlet weak var contextView: UIView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var cleanTextBtn: UIButton!
    
    var text: String? {
        set {
            inputTextField.text = newValue
        }
        get {
            return inputTextField.text
        }
    }
    
    var contentType: UITextContentType? {
        set {
            self.inputTextField.textContentType = newValue ?? .none
            self.inputTextField.isSecureTextEntry = contentType == .password
        }
        get {
            return self.inputTextField.textContentType
        }
    }
    
    var didCleanText: (()->Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI(){
        guard let view = self.loadViewFromNib(nibName: "InputTextField") else {return}
        view.frame = self.bounds
        addSubview(view)
        self.inputTextField.delegate = self
        self.contextView.borderColor = UIColor.lightGray
        self.contextView.borderWidth = 1
        self.contextView.layer.cornerRadius = 5
        inputTextField.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        guard let text = textField.text else {
            self.cleanTextBtn.isHidden = true
            return
        }
        self.cleanTextBtn.isHidden = text.isEmpty
    }
    
    @IBAction func didtapCleanText(_ sender: Any) {
        self.text = ""
        self.cleanTextBtn.isHidden = true
        self.didCleanText?()
    }
}

extension InputTextField: UITextFieldDelegate {
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.contextView.borderColor = UIColor.systemBlue
        self.contextView.borderWidth = 1.5
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.contextView.borderColor = UIColor.lightGray
        self.contextView.borderWidth = 1
    }
}
