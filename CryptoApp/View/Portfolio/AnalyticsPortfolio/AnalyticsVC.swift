//
//  AnalyticsVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 20/11/2023.
//

import UIKit

class AnalyticsVC: UIViewController {

    @IBOutlet weak var portfolioView: UIView! {
        didSet {
            portfolioView.addShadow()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
