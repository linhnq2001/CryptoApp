//
//  ResultSearchCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 12/11/2023.
//

import UIKit

class ResultSearchCell: UITableViewCell {
    
    @IBOutlet weak var tokenImage: UIImageView! {
        didSet {
            tokenImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var symbolLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    func configData(data: SearchDataSource , type: SearchTitle) {
        switch type {
        case .recentSearch:
            break
        case .searchResult:
            guard let data = data as? CoinSearchResponse else { return }
            self.nameLb.text = data.name ?? ""
            self.symbolLb.text = data.symbol ?? ""
            self.tokenImage.kf.setImage(with: URL(string: data.thumb ?? ""))
        case .trendingSearch:
            guard let data = data as? CoinItem else { return }
            self.nameLb.text = data.item?.name ?? ""
            self.symbolLb.text = data.item?.symbol ?? ""
            self.tokenImage.kf.setImage(with: URL(string: data.item?.thumb ?? ""))
            break
        default:
            break
        }
    }
    
}
