//
//  AddTransactionVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 15/11/2023.
//

import UIKit
import XLPagerTabStrip

class AddTransactionVC: SegmentedPagerTabStripViewController {
    private(set) var id: String = ""
    
    init(id: String) {
        self.id = id
        super.init(nibName: String(describing: AddTransactionVC.self), bundle: Bundle(for: AddTransactionVC.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.segmentedControlColor = .blue

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let buyVC = BuyTransactionVC()
        let sellVC = SellTransactionVC()
        return [buyVC,sellVC]
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
