//
//  DescriptionCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 06/11/2023.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var descriptionLb: UILabel!
    @IBOutlet weak var categoryList: TagListView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
}
