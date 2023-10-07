//
//  RegisterViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import UIKit
import RxSwift
import RxCocoa

class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var usernameInputTF: InputTextField!
    @IBOutlet weak var emailInputTF: InputTextField!
    @IBOutlet weak var passwordInputTF: InputTextField!
    @IBOutlet weak var registerBtn: UIButton!
    
    private var disposeBag = DisposeBag()
    private(set) var viewModel: RegisterViewModel!
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: RegisterViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: RegisterViewController.self), bundle: Bundle(for: RegisterViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.bindingData()
        // Do any additional setup after loading the view.
    }
    
    private func bindingData(){
        let input = RegisterViewModel.Input(username: self.usernameInputTF.inputTextField.rx.text.orEmpty.asDriver(), email: self.emailInputTF.inputTextField.rx.text.orEmpty.asDriver(), password: self.passwordInputTF.inputTextField.rx.text.orEmpty.asDriver(), registerAction: self.registerBtn.rx.tap.asDriver())
        
        let output = viewModel.tranform(input)
        
        
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    

}
