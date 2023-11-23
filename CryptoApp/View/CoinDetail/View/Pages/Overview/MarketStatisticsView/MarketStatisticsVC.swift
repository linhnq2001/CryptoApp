//
//  MarketStatisticsVC.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 18/11/2023.
//

import UIKit

class MarketStatisticsVC: UIViewController {
    
    private(set) var data: CoinInfoResponse!
    
    @IBOutlet weak var marketPriceLb: UILabel!
    @IBOutlet weak var marketCapLb: UILabel!
    @IBOutlet weak var fullMarketCapLb: UILabel!
    @IBOutlet weak var volLb: UILabel!
    @IBOutlet weak var currentSupplyLb: UILabel!
    @IBOutlet weak var percentSupplyLb: UILabel!
    @IBOutlet weak var totalSupplyLb: UILabel!
    @IBOutlet weak var athPriceLb: UILabel!
    @IBOutlet weak var atlPriceLb: UILabel!
    
    init(data: CoinInfoResponse!) {
        self.data = data
        super.init(nibName: String(describing: MarketStatisticsVC.self), bundle: Bundle(for: MarketStatisticsVC.self))
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
        self.marketPriceLb.text = "$ \(formatNumber(number: data.marketData?.currentPrice?["usd"] ?? 0.0))"
        self.marketCapLb.text = "$ \(formatNumber(number: data.marketData?.marketCap?["usd"] ?? 0.0))"
        self.fullMarketCapLb.text = "$ \(formatNumber(number: data.marketData?.fullyDilutedValuation?["usd"] ?? 0.0))"
        self.currentSupplyLb.text = "\(formatNumber(number: data.marketData?.circulatingSupply ?? 0)) \(data.symbol?.uppercased() ?? "")"
        self.volLb.text = "$ \(formatNumber(number: ((data.marketData?.totalVolume?["usd"]) ?? 0) ?? 0))"
        if let maxSupply = data.marketData?.totalSupply {
            self.totalSupplyLb.text = "\(formatNumber(number: maxSupply)) \(data.symbol?.uppercased() ?? "")"
            let percent = round((data.marketData?.circulatingSupply ?? 0) * 100 / maxSupply * 1000) / 1000
            self.percentSupplyLb.text = "\(percent) %"
        }
        self.athPriceLb.text = "$ \(formatNumber(number: data.marketData?.ath?["usd"] ?? 0.0))"
        self.atlPriceLb.text = "$ \(formatNumber(number: data.marketData?.atl?["usd"] ?? 0.0))"
    }

    @IBAction func didTapDismiss(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    private func formatNumber(number: Double) -> String{
        let knumber = round(number/1000.0 * 100) / 100.0
        let mnumber = round(number/1000000.0 * 100) / 100.0
        let bnumber = round(number/1000000000.0 * 100) / 100.0
        if bnumber >= 1{
            return "\(bnumber) B"
        } else if mnumber >= 1 {
            return "\(mnumber) M"
        } else if knumber >= 1{
            return "\(knumber) K"
        } else {
            return "\(number)"
        }
    }
}
