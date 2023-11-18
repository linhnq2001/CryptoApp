//
//  ExchangesCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit

class ExchangesCell: UITableViewCell {

    
    @IBOutlet weak var exchangesView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        exchangesView.addShadow()
        selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: CoinInfoResponse) {
        
    }
    
}
