//
//  DescriptionCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 06/11/2023.
//

import UIKit

class DescriptionCell: UITableViewCell {
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var descriptionLb: UILabel!
    @IBOutlet private weak var categoryList: TagListView!
    
    func configData(data: CoinInfoResponse?) {
        nameLb.text = data?.name
        descriptionLb.text = data?.description?.en
        if let list = data?.categories {
            categoryList.addTags(list)
        }
    }
}
