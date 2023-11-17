//
//  TransactionDetailVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit

class TransactionDetailVC: UIViewController {
    private(set) var data: TradeDetailHistory!
    
    @IBOutlet weak var imageToken: UIImageView!
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var totalLb: UILabel!
    @IBOutlet weak var dateLb: UILabel!
    
    init(data: TradeDetailHistory!) {
        self.data = data
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
        
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    @IBAction func didTapDelete(_ sender: Any) {
        let alertController = UIAlertController(title: "Delete Transaction", message: "Are you sure you want to delete this conversation ?", preferredStyle: .alert)
        
        // Create an action
        let yesAction = UIAlertAction(title: "Yes", style: .cancel) { (_) in

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
