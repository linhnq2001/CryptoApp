//
//  MoreDetailsVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 20/11/2023.
//

import UIKit
import RxSwift

class MoreDetailsVC: UIViewController {
    
    private(set) var portfolio: Portfolio!
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var editView: UIView!
    @IBOutlet weak var duplicateView: UIView!
    @IBOutlet weak var deleteView: UIView!
    
    init(portfolio: Portfolio!) {
        self.portfolio = portfolio
        super.init(nibName: String(describing: MoreDetailsVC.self), bundle: Bundle(for: MoreDetailsVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapEdit = UITapGestureRecognizer(target: self, action: #selector(didTapEdit))
        let tapDuplicate = UITapGestureRecognizer(target: self, action: #selector(didTapDuplicate))
        let tapDelete = UITapGestureRecognizer(target: self, action: #selector(didTapDelete))
        editView.addGestureRecognizer(tapEdit)
        duplicateView.addGestureRecognizer(tapDuplicate)
        deleteView.addGestureRecognizer(tapDelete)
        // Do any additional setup after loading the view.
    }
    
    @objc func didTapEdit() {
        let vc = EditPortfolioVC(type: .editName, portfolio: portfolio)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(nav, animated: true)
    }
    
    @objc func didTapDuplicate() {
        let vc = EditPortfolioVC(type: .duplicate, portfolio: portfolio)
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .pageSheet
        if let sheet = nav.sheetPresentationController {
            sheet.detents = [.medium(), .large()]
        }
        self.present(nav, animated: true)
    }
    
    @objc func didTapDelete() {
        let alertController = UIAlertController(title: "Delete Portfolio", message: "Are you sure you want to delete this Portfolio ?", preferredStyle: .alert)
        
        // Create an action
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { [weak self] (_) in
            guard let self = self else { return }
            FirestoreHelper.shared.removePortfolio(self.portfolio).subscribe(onNext: { [weak self] result, error in
                guard let self = self else { return }
                if result {
                    self.dismiss(animated: true)
                } else {
                    self.showToast(message: error, font: UIFont.systemFont(ofSize: 12)) { _ in
                        
                    }
                }
            }).disposed(by: disposeBag)
        }
        
        let noAction = UIAlertAction(title: "No", style: .default) { (_) in

        }
        // Add the action to the alert controller
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }

    @IBAction func didTapDismiss(_ sender: Any) {
        dismiss(animated: true)
    }
    
}
