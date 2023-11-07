//
//  OverviewViewController.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/11/2023.
//

import UIKit
import XLPagerTabStrip

class OverviewViewController: UIViewController, IndicatorInfoProvider {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    func indicatorInfo(for pagerTabStripController: XLPagerTabStrip.PagerTabStripViewController) -> XLPagerTabStrip.IndicatorInfo {
        IndicatorInfo(title: "Overview")
    }

}
