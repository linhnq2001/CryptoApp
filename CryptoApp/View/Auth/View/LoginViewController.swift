//
//  LoginViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import UIKit
import RxSwift

class LoginViewController: UIViewController {
    
    
    @IBOutlet weak var signinGGBtn: UIButton!{
        didSet{
//            let image = UIImage(named: "ic_google")
//            signinGGBtn.setImage(image, for: .normal)
//
//            // Set the desired image size
//            let imageSize = CGSize(width: 24, height: 24)
//
//            // Adjust the imageEdgeInsets to center the image within the button
//            let horizontalPadding = (signinGGBtn.frame.size.width - imageSize.width) / 2
//            let verticalPadding = (signinGGBtn.frame.size.height - imageSize.height) / 2
//            signinGGBtn.imageEdgeInsets = UIEdgeInsets(top: verticalPadding, left: horizontalPadding, bottom: verticalPadding, right: horizontalPadding)
//            signinGGBtn.imageView?.contentMode = .scaleAspectFit
//            var filled = UIButton.Configuration.gray()
//            filled.title = "Sign In with Google"
//            filled.buttonSize = .medium
//            filled.image = UIImage(named: "ic_google")?
//            filled.imagePlacement = .leading
//            filled.imagePadding = 5

//            signinGGBtn.configuration = filled
        }
    }
    @IBOutlet weak var emailInputTF: InputTextField!{
        didSet {
            emailInputTF.contentType = .emailAddress
        }
    }
    
    @IBOutlet weak var passwordInputTF: InputTextField!{
        didSet {
            passwordInputTF.contentType = .password
        }
    }
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var resetPassBtn: UIButton!
    
    private(set) var viewModel: LoginViewModel!
    private var disposeBag = DisposeBag()
    init(viewModel: LoginViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        // Do any additional setup after loading the view.
    }
    
    private func bindingData(){
        let input = LoginViewModel.Input(loginAction: loginBtn.rx.tap.asDriver(), resetPasswordAction: resetPassBtn.rx.tap.asDriver(), loginWithGoogleAction: signinGGBtn.rx.tap.asDriver(), email: emailInputTF.inputTextField.rx.text.orEmpty.asDriver(), password: passwordInputTF.inputTextField.rx.text.orEmpty.asDriver())
        
        
        let output = viewModel.tranform(input)
        handleLoginResult(input,output)
        handleLoading(input,output)
    }
    
    private func handleLoginResult(_ input: LoginViewModel.Input, _ output: LoginViewModel.Output){
        output.loginResult.subscribe(onNext: { [weak self] (result,error) in
            guard let self = self else { return }
            if !result {
                self.showToast(message: error, font: UIFont.systemFont(ofSize: 12), completion: {_ in })
            } else {
                self.navigationController?.popViewController(animated: true)
            }
        }).disposed(by: disposeBag)
    }
    
    private func handleLoading(_ input: LoginViewModel.Input, _ output: LoginViewModel.Output){
        output.showLoading.subscribe(onNext: {[weak self] isLoading in
            guard let self = self else {return}
            self.loginBtn.loadingIndicator(isLoading)
        }).disposed(by: disposeBag)
    }
    
    @IBAction func didTapCreateAccount(_ sender: Any) {
        let viewModel = RegisterViewModel()
        let vc = RegisterViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
