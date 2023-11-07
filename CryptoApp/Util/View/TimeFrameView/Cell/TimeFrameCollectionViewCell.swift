//
//  TimeFrameCollectionViewCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 02/11/2023.
//

import UIKit

class TimeFrameCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var timeFrameLb: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func configData(timeFrame: String, isSelected: Bool) {
        self.timeFrameLb.text = timeFrame
        self.containerView.backgroundColor = isSelected ? UIColor.tintColor : UIColor.white
    }

}
