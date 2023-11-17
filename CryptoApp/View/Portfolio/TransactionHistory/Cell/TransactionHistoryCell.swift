//
//  TransactionHistoryCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/11/2023.
//

import UIKit

class TransactionHistoryCell: UITableViewCell {

    @IBOutlet weak var tokenImage: UIImageView!
    @IBOutlet weak var symbolLb: UILabel!
    @IBOutlet weak var percentGainLb: UILabel!
    @IBOutlet weak var gainLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var amountLb: UILabel!
    @IBOutlet weak var valueLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configData(data: TradeDetailHistory) {
        self.tokenImage.kf.setImage(with: URL(string: data.urlImage))
        self.priceLb.text = "$ \(data.price) Price"
        self.symbolLb.text = "\(data.type.rawValue.uppercased()) \(data.symbol.uppercased())"
        self.amountLb.text = "\(data.type == .buy ? "+" : "-")\(data.amount) \(data.symbol.uppercased())"
        self.amountLb.textColor = data.type == .buy ? .systemGreen : .systemRed
        self.valueLb.text = "$ \(data.amount * data.price)"
//        self.percentGainLb
//        self.gainLb
    }
    
}
