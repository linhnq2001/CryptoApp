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
        self.ordinalLb.text = "\(data.marketCapRank!)"
        self.symbolLb.text = data.symbol!
        self.nameLb.text = data.name!
        if let url = data.image {
            self.coinImage.kf.setImage(with: URL(string: url))
        }
        self.priceLb.text = "$ \(data.currentPrice!)"
        self.priceChangeLb.text = "\(data.priceChange24H! / 100) %"
        self.marketCapLb.text = "\(data.marketCap!)"
        self.volLb.text = "\(data.totalVolume!)"
    }

}
