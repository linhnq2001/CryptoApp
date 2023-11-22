//
//  TransactionDetailVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit
import RxSwift

class TransactionDetailVC: UIViewController {
    private(set) var data: TradeDetailHistory!
    private(set) var name: String!
    private(set) var didEditPortfolio: PublishSubject<Void>
    private let disposeBag = DisposeBag()
    
    @IBOutlet weak var imageToken: UIImageView! {
        didSet {
            imageToken.layer.cornerRadius = 40
        }
    }
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    init(data: TradeDetailHistory!, name: String, didEditPortfolio: PublishSubject<Void>) {
        self.name = name
        self.data = data
        self.didEditPortfolio = didEditPortfolio
        super.init(nibName: String(describing: TransactionDetailVC.self), bundle: Bundle(for: TransactionDetailVC.self))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        // Do any additional setup after loading the view.
    }
    
    private func setupUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .short

        let formattedDate = dateFormatter.string(from: Date(timeIntervalSince1970: Double(data.createAt)))

        imageToken.kf.setImage(with: URL(string: data.urlImage))
        titleLb.text = "\(data.type.rawValue.uppercased()) \(data.symbol.uppercased())"
        priceLb.text = "$ \(data.price)"
        totalLb.text = "$ \(data.amount * data.price)"
        dateLb.text = formattedDate
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapDelete(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Transaction", message: "Are you sure you want to delete this conversation ?", preferredStyle: .alert)
        
        // Create an action
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { [weak self] (_) in
            guard let self = self else { return }
            FirestoreHelper.shared.deleteTransaction(self.data, namePortfolio: self.name).subscribe(onNext: { [weak self] (result, error) in
                guard let self = self else { return }
                if result {
                    self.didEditPortfolio.onNext(())
                }
                self.showToast(message: result ? "success" : error, font: UIFont.systemFont(ofSize: 12)) { _ in
                    if result {
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }).disposed(by: self.disposeBag)
        }
        let noAction = UIAlertAction(title: "No", style: .default) { (_) in

        }
        // Add the action to the alert controller
        alertController.addAction(yesAction)
        alertController.addAction(noAction)
        // Present the alert controller
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func didTapEdit(_ sender: Any) {
        
    }

}
