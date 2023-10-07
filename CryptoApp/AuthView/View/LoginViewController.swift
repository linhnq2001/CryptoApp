//
//  LoginViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import UIKit

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
    
    private(set) var viewModel: LoginViewModel!
    
    init(viewModel: LoginViewModel!) {
        self.viewModel = viewModel
        super.init(nibName: String(describing: LoginViewController.self), bundle: Bundle(for: LoginViewController.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    private func bindingData(){
        
    }
    
    
    @IBAction func didTapCreateAccount(_ sender: Any) {
        let viewModel = RegisterViewModel()
        let vc = RegisterViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}
