//
//  PortfolioCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 14/11/2023.
//

import UIKit

class PortfolioCell: UICollectionViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var portfolioImage: UIImageView!
    @IBOutlet weak var valueLb: UILabel!
    @IBOutlet weak var percentageChangeLb: UILabel!
    @IBOutlet weak var valueChangeLb: UILabel!
    @IBOutlet weak var timeframeLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configData(data: PortfolioDataSource) {
        guard let data = data as? Portfolio else { return }
        nameLb.text = data.name
        valueLb.text = "$ \(data.getValue())"
        
        timeframeLb.text = "24h change"
    }

}
