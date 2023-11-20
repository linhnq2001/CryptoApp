//
//  SettingViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxSwift
import Kingfisher

class SettingViewController: UIViewController {
    
    @IBOutlet weak var signInView: UIView!
    @IBOutlet weak var userView: UIView!
    @IBOutlet weak var userAvt: UIImageView!
    @IBOutlet weak var usernameLb: UILabel!
    @IBOutlet weak var emailLb: UILabel!
    
    @IBOutlet weak var startScreenView: UIView!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var signOutView: UIView!
    
    private let trigger = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private(set) var viewModel: SettingViewModel!
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(viewModel: SettingViewModel){
        self.viewModel = viewModel
        super.init(nibName: String(describing: SettingViewController.self), bundle: Bundle(for: SettingViewController.self))
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        bindingData()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapLogOut))
        signOutView.addGestureRecognizer(tapGesture)
    }
    
    @objc func didTapLogOut() {
        FirebaseAuthHelper.shared.logout().subscribe(onNext: { [weak self] result, _  in
            guard let self = self else { return }
            if result {
                self.trigger.onNext(())
            }
        }).disposed(by: disposeBag)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        trigger.onNext(())
    }
    
    private func bindingData() {
        let input = SettingViewModel.Input(trigger: trigger)
        
        let output = viewModel.transform(input)
        handleShowLoading(output)
        handleUserData(output)
        trigger.onNext(())
    }
    
    private func handleShowLoading(_ output: SettingViewModel.Output){
        output.showLoading.subscribe(onNext: {isLoading in
            
        }).disposed(by: disposeBag)
    }
    
    private func handleUserData(_ output: SettingViewModel.Output){
        output.isLogin.subscribe(onNext: {[weak self] (isLogin, user) in
            guard let self = self else { return }
            self.signInView.isHidden = isLogin
            self.userView.isHidden = !isLogin
            self.usernameLb.text = user?.username
            self.emailLb.text = user?.email
            self.userAvt.image = UIImage(named: "ic_user")
            self.signOutView.isHidden = !isLogin
        }).disposed(by: disposeBag)
    }

    @IBAction func didtapLoginWithEmail(_ sender: Any) {
        let vc = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }

}
