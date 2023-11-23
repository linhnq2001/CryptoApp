//
//  MarketStatisticsCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit

class MarketStatisticsCell: UITableViewCell {
    
    @IBOutlet weak var marketCapLb: UILabel!
    @IBOutlet weak var fullMarketCapLb: UILabel!
    @IBOutlet weak var totalSupplyLb: UILabel!
    @IBOutlet weak var circSupplyLb: UILabel!
    @IBOutlet weak var percentCircSupplyLb: UILabel!
    @IBOutlet weak var volLb: UILabel!
    @IBOutlet weak var contextView: UIView!
    var didTapSeeAll: (() -> Void)?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        contextView.backgroundColor = UIColor.white
        contextView.addShadow()
        selectionStyle = .none

        // Configure the view for the selected state
    }
    
    func configData(data: CoinInfoResponse) {
        self.marketCapLb.text = "$ \(formatNumber(number: data.marketData?.marketCap?["usd"] ?? 0.0))"
        self.fullMarketCapLb.text = "$ \(formatNumber(number: data.marketData?.fullyDilutedValuation?["usd"] ?? 0.0))"
        self.circSupplyLb.text = "\(formatNumber(number: data.marketData?.circulatingSupply ?? 0)) \(data.symbol?.uppercased() ?? "")"
        
        self.volLb.text = "$ \(formatNumber(number: ((data.marketData?.totalVolume?["usd"]) ?? 0) ?? 0))"
        if let maxSupply = data.marketData?.totalSupply {
            self.totalSupplyLb.text = "\(formatNumber(number: maxSupply)) \(data.symbol?.uppercased() ?? "")"
            let percent = round((data.marketData?.circulatingSupply ?? 0) * 100 / maxSupply * 1000) / 1000
            self.percentCircSupplyLb.text = "\(percent) %"
        }
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
    
    @IBAction func didTapSeeAll(_ sender: Any) {
        didTapSeeAll?()
    }
}
