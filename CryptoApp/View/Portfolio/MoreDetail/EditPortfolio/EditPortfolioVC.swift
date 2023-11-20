//
//  EditPortfolioVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 20/11/2023.
//

import UIKit
import RxSwift

enum EditPortfolioType {
    case editName
    case duplicate
}

class EditPortfolioVC: UIViewController {
    
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var nameInputTF: InputTextField!
    var type: EditPortfolioType {
        didSet {
            switch type {
            case .editName:
                titleLb.text = "Edit portfolio"
            case .duplicate:
                titleLb.text = "Duplicate portfolio"
            }
        }
    }
    private(set) var didEditPortfolio: PublishSubject<Void>
    var portfolio: Portfolio
    private let disposeBag = DisposeBag()
    
    init(type: EditPortfolioType, portfolio: Portfolio,didEditPortfolio: PublishSubject<Void>) {
        self.type = type
        self.portfolio = portfolio
        self.didEditPortfolio = didEditPortfolio
        super.init(nibName: String(describing: EditPortfolioVC.self), bundle: Bundle(for: EditPortfolioVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapSave(_ sender: Any) {
        switch type {
        case .editName:
            if let text = nameInputTF.text , !text.isEmpty{
                FirestoreHelper.shared.renamePortfolio(portfolio: self.portfolio, newName: text).subscribe(onNext: { [weak self] (result, error) in
                    guard let self = self else { return }
                    if result {
                        self.didEditPortfolio.onNext(())
                        self.showToast(message: "Rename Success", font: UIFont.systemFont(ofSize: 12)) { [weak self] _ in
                            guard let self = self else { return }
                            self.dismiss(animated: true)
                        }
                    } else {
                        self.showToast(message: error, font: UIFont.systemFont(ofSize: 12)) { _ in
                            
                        }
                    }
                }).disposed(by: disposeBag)
            } else {
                self.showToast(message: "Enter Portfolio Name", font: UIFont.systemFont(ofSize: 12)) { _ in
                }
            }
        case .duplicate:
            if let text = nameInputTF.text , !text.isEmpty{
                FirestoreHelper.shared.duplicatePortfolio(portfolio: self.portfolio, newName: text).subscribe(onNext: { [weak self] (result, error) in
                    guard let self = self else { return }
                    if result {
                        self.didEditPortfolio.onNext(())
                        self.showToast(message: "Duplicate Success", font: UIFont.systemFont(ofSize: 12)) { [weak self] _ in
                            guard let self = self else { return }
                            self.dismiss(animated: true)
                        }
                    } else {
                        self.showToast(message: error, font: UIFont.systemFont(ofSize: 12)) { _ in
                            
                        }
                    }
                }).disposed(by: disposeBag)
            } else {
                self.showToast(message: "Enter Portfolio Name", font: UIFont.systemFont(ofSize: 12)) { _ in
                }
            }
        }
    }
    
    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
