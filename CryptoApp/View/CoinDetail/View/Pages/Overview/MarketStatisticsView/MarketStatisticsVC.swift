//
//  MarketStatisticsVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 18/11/2023.
//

import UIKit

class MarketStatisticsVC: UIViewController {
    
    private(set) var data: CoinInfoResponse!
    
    init(data: CoinInfoResponse!) {
        self.data = data
        super.init(nibName: String(describing: MarketStatisticsVC.self), bundle: Bundle(for: MarketStatisticsVC.self))
    }

    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
