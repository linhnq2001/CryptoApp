//
//  SellTransactionVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 15/11/2023.
//

import UIKit
import XLPagerTabStrip

class SellTransactionVC: UIViewController, IndicatorInfoProvider {
    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        IndicatorInfo(title: "Sell")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


}
