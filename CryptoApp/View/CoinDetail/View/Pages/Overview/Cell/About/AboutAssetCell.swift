//
//  AboutAssetCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit

class AboutAssetCell: UITableViewCell {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var aboutLb: UITextView!
    var didTapSeeMore: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func didTapSeeMore(_ sender: Any) {
        self.didTapSeeMore?()
    }
    
    func configData(data: CoinInfoResponse) {
        self.titleLb.text = "About \(data.symbol?.uppercased() ?? "")"
        self.aboutLb.text = data.description?.en ?? ""
    }

}
