//
//  CoinInfoTableViewCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/10/2023.
//

import UIKit
import Kingfisher

class CoinInfoTableViewCell: UITableViewCell {
    
    @IBOutlet weak var ordinalLb: UILabel!
    @IBOutlet weak var coinImage: UIImageView!
    @IBOutlet weak var symbolLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var priceChangeLb: UILabel!
    @IBOutlet weak var marketCapLb: UILabel!
    @IBOutlet weak var volLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func configData(data: CoinInMarketResponse){	
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        self.ordinalLb.text = "\(data.marketCapRank!)"
        self.symbolLb.text = data.symbol!.uppercased()
        self.nameLb.text = data.name!
        if let url = data.image {
            self.coinImage.kf.setImage(with: URL(string: url))
        }
        self.priceLb.text = "$ \(data.currentPrice!)"
        self.priceChangeLb.text = numberFormatter.string(for: data.priceChangePercentage24H)! + " %"
        self.priceChangeLb.textColor = data.priceChangePercentage24H! >= 0 ? UIColor.systemGreen : UIColor.red
        self.marketCapLb.text = "$ \(formatNumber(number: Double(data.marketCap!)))"
        self.volLb.text = "$ \(formatNumber(number: data.totalVolume!))"
    }
    
    public func configData(data: CoinInfoResponse) {
        let numberFormatter = NumberFormatter()
        numberFormatter.maximumFractionDigits = 2
        numberFormatter.minimumFractionDigits = 2
        self.ordinalLb.text = "\(data.marketCapRank!)"
        self.symbolLb.text = data.symbol!.uppercased()
        self.nameLb.text = data.name!
        if let url = data.image?.thumb {
            self.coinImage.kf.setImage(with: URL(string: url))
        }
        self.priceLb.text = "$ \(data.getCurrentPrice())"
        self.priceChangeLb.text = numberFormatter.string(for: data.marketData?.priceChange24H)! + " %"
        self.priceChangeLb.textColor = data.marketData?.priceChange24H ?? 0 >= 0 ? UIColor.systemGreen : UIColor.red
        self.marketCapLb.text = "$ \(formatNumber(number: Double(data.marketData?.marketCap?["usd"] ?? 0)))"
        self.volLb.text = "$ \(formatNumber(number: data.marketData?.totalVolume?["usd"] ?? 0))"
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
