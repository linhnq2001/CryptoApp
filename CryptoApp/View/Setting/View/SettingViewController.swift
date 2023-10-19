//
//  SettingViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 11/10/2023.
//

import UIKit
import RxSwift

class SettingViewController: UIViewController {
    
    @IBOutlet weak var startScreenView: UIView!
    @IBOutlet weak var themeView: UIView!
    @IBOutlet weak var languageView: UIView!
    @IBOutlet weak var policyView: UIView!
    @IBOutlet weak var signOutView: UIView!
    
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
        
    }

    @IBAction func didtapLoginWithEmail(_ sender: Any) {
        let vc = LoginViewController(viewModel: LoginViewModel())
        self.navigationController?.pushViewController(vc, animated: true)
    }
    

}
