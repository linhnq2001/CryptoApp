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
    @IBOutlet weak var emailInputTF: InputTextField! {
        didSet {
            emailInputTF.contentType = .emailAddress
        }
    }
    @IBOutlet weak var passwordInputTF: InputTextField! {
        didSet {
            passwordInputTF.contentType = .password
        }
    }
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

    private func bindingData() {
        let input = RegisterViewModel.Input(username: self.usernameInputTF.inputTextField.rx.text.orEmpty.asDriver(), email: self.emailInputTF.inputTextField.rx.text.orEmpty.asDriver(), password: self.passwordInputTF.inputTextField.rx.text.orEmpty.asDriver(), registerAction: self.registerBtn.rx.tap.asDriver())
        
        let output = viewModel.tranform(input)
        handleShowLoading(input, output)
        handleShowResultRegister(input, output)
    }

    private func handleShowLoading(_ input: RegisterViewModel.Input,_ output: RegisterViewModel.Output) {
        output.showLoading.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else { return }
            self.registerBtn.loadingIndicator(isLoading)
        }).disposed(by: disposeBag)
    }
    
    private func handleShowResultRegister(_ input: RegisterViewModel.Input,_ output: RegisterViewModel.Output) {
        output.registerResult.subscribe(onNext: { [weak self] (result,error) in
            guard let self = self else { return }
            if result {
                self.showToast(message: "Register successful", font: UIFont.systemFont(ofSize: 14)) { _ in
                    self.navigationController?.popViewController(animated: true)
                }
            } else {
                self.showToast(message: error, font: UIFont.systemFont(ofSize: 14)) { _ in }
            }
        }).disposed(by: disposeBag)
    }

    @IBAction func didTapLogin(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
