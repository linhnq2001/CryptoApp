//
//  AddTransactionVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 15/11/2023.
//

import UIKit
import XLPagerTabStrip
import RxSwift

class AddTransactionVC: SegmentedPagerTabStripViewController {
    private(set) var id: String = ""
    private(set) var data: CoinInMarketResponse?
    private(set) var portfolio: Portfolio?
    private(set) var didEditPortfolio: PublishSubject<Void>
    
    @IBOutlet weak var tokenImage: UIImageView!{
        didSet {
            tokenImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var tokenNameLb: UILabel!
    @IBOutlet weak var tokenSymbolLb: UILabel!
    
    init(id: String,
         data: CoinInMarketResponse? = nil,
         portfolio: Portfolio?,
         didEditPortfolio: PublishSubject<Void>) {
        self.id = id
        self.data = data
        self.portfolio = portfolio
        self.didEditPortfolio = didEditPortfolio
        super.init(nibName: String(describing: AddTransactionVC.self), bundle: Bundle(for: AddTransactionVC.self))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        settings.style.segmentedControlColor = .blue
        if let data = data {
            self.tokenImage.kf.setImage(with: URL(string: data.image ?? ""))
            self.tokenNameLb.text = data.name
            self.tokenSymbolLb.text = data.symbol?.uppercased()
        }

        // Do any additional setup after loading the view.
    }
    
    override func viewControllers(for pagerTabStripController: PagerTabStripViewController) -> [UIViewController] {
        let buyVC = BuyTransactionVC(tokenId: id,
                                     data: data,
                                     portfolio: portfolio,
                                     didEditPortfolio: didEditPortfolio)
        let sellVC = SellTransactionVC(tokenId: id,
                                       data: data,
                                       portfolio: portfolio,
                                       didEditPortfolio: didEditPortfolio)
        return [buyVC,sellVC]
    }

    @IBAction func didTapBack(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
}
