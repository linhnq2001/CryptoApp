//
//  MarketPriceCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit

class MarketPriceCell: UITableViewCell {
    
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var viewPercentChange: UIView!
    @IBOutlet weak var percentChangeLb: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var priceLowLb: UILabel!
    @IBOutlet weak var priceHighLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func configData(data: CoinInfoResponse) {
        self.priceLb.text = "$ \(data.getCurrentPrice())"
        let percent = round((data.marketData?.priceChangePercentage24H ?? 0) * 100) / 100
        self.percentChangeLb.text = "\(percent) %"
        if percent >= 0 {
            viewPercentChange.backgroundColor = UIColor.green.withAlphaComponent(0.2)
            percentChangeLb.textColor = UIColor.green.withAlphaComponent(0.8)
        } else {
            viewPercentChange.backgroundColor = UIColor.red.withAlphaComponent(0.2)
            percentChangeLb.textColor = UIColor.red.withAlphaComponent(0.8)
        }
        let currentPrice = data.marketData?.currentPrice?["usd"] ?? 0.0
        let priceLow = (data.marketData?.low24H?["usd"] ?? 0.0) ?? 0.0
        let priceHigh = (data.marketData?.high24H?["usd"] ?? 0.0) ?? 0.0
        priceLowLb.text = "$ \(String(describing: priceLow))"
        priceLowLb.text = "$ \(String(describing: priceLow))"
        priceHighLb.text = "$ \(String(describing: priceHigh))"
        progressView.progress = Float( (currentPrice - priceLow) / (priceHigh - priceLow) )
    }
}
