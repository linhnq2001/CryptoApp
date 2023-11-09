//
//  RecentSearchCollectionViewCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 09/11/2023.
//

import UIKit

class RecentSearchCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var coinView: CoinRoundedView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: CoinInfoResponse) {
        coinView.configData(data: data)
    }

}
