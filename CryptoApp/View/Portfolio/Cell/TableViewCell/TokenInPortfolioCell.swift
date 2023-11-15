//
//  TokenInPortfolioCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/11/2023.
//

import UIKit
import RealmSwift

class TokenInPortfolioCell: UITableViewCell {

    @IBOutlet weak var profitLb: UILabel!
    @IBOutlet weak var holdingValueLb: UILabel!
    @IBOutlet weak var percentChangeLb: UILabel!
    @IBOutlet weak var currentPriceLb: UILabel!
    @IBOutlet weak var amountToken: UILabel!
    @IBOutlet weak var symbolToken: UILabel!
    @IBOutlet weak var imageToken: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configData(data: TokenInPortfolio) {
        let realm = try! Realm()
        let currentPrice = realm.objects(LocalPriceData.self).first(where: {$0.id == data.id})?.data?.usd ?? 0.0
        let balance = data.getBalance()
        self.imageToken.kf.setImage(with: URL(string: data.urlImage))
        self.symbolToken.text = data.symbol.uppercased()
        self.amountToken.text = "\(balance) \(data.symbol.uppercased())"
        self.currentPriceLb.text = "$ \(currentPrice)"
        self.holdingValueLb.text = "$ \(currentPrice * balance)"
        self.profitLb.text = "$ \(data.getProfit())"
    }
}
