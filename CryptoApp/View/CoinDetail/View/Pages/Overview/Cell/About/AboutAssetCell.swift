//
//  AboutAssetCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit

class AboutAssetCell: UITableViewCell {
    @IBOutlet private weak var titleLb: UILabel!
    @IBOutlet private weak var aboutLb: UITextView!
    var didTapSeeMore: (() -> Void)?

    @IBAction func didTapSeeMore(_ sender: Any) {
        self.didTapSeeMore?()
    }
    
    func configData(data: CoinInfoResponse) {
        self.titleLb.text = "About \(data.symbol?.uppercased() ?? "")"
        self.aboutLb.text = data.description?.en ?? ""
    }

}
