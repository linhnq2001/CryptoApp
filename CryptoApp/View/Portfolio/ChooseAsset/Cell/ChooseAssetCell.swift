//
//  ChooseAssetCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 13/11/2023.
//

import UIKit
import Kingfisher

class ChooseAssetCell: UITableViewCell {

    @IBOutlet weak var tokenImage: UIImageView!{
        didSet {
            tokenImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var symbolLb: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: SearchDataSource , type: SearchTitle) {
        switch type {
        case .marketCoin:
            guard let data = data as? CoinInMarketResponse else {return}
            self.tokenImage.kf.setImage(with: URL(string: data.image ?? ""))
            self.nameLb.text = data.name ?? ""
            self.symbolLb.text = data.symbol?.uppercased() ?? ""
        case .portfolioCoin:
            guard let data = data as? TokenInPortfolio else {return}
            self.tokenImage.kf.setImage(with: URL(string: data.urlImage ))
            self.nameLb.text = data.name 
            self.symbolLb.text = data.symbol.uppercased()
        case .searchResult:
            guard let data = data as? CoinSearchResponse else {return}
            self.tokenImage.kf.setImage(with: URL(string: data.large ?? ""))
            self.nameLb.text = data.name
            self.symbolLb.text = data.symbol?.uppercased()
        default:
            break
        }
    }
    
}
