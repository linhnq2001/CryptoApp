//
//  LinkCoinCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 26/11/2023.
//

import UIKit

class LinkCoinCell: UITableViewCell,TagListViewDelegate {

    @IBOutlet weak var tagView: TagListView! {
        didSet {
            tagView.delegate = self
        }
    }
    @IBOutlet weak var titleLb: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: LinkData) {
        titleLb.text = data.title
        tagView.addTags(data.links)
    }
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        if let url = URL(string: title) {
            UIApplication.shared.open(url)
        }
    }
}
