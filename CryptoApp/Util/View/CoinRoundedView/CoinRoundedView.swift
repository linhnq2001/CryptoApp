//
//  CoinRoundedView.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 08/11/2023.
//

import Foundation
import UIKit
import Kingfisher

final public class CoinRoundedView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var logoImage: UIImageView!{
        didSet {
            logoImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet private weak var symbolLb: UILabel!
    @IBOutlet private weak var nameLb: UILabel!
    @IBOutlet private weak var priceLb: UILabel!
    @IBOutlet private weak var priceChangeLb: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        guard let view = self.loadViewFromNib(nibName: "CoinRoundedView") else {return}
        view.frame = self.bounds
        addSubview(view)
    }
    
    func configData(data: CoinInfoResponse) {
        self.logoImage.kf.setImage(with: URL(string: data.image?.large ?? ""))
        self.symbolLb.text = data.symbol?.uppercased()
        self.nameLb.text = data.name
        self.priceLb.text = "$ \(data.marketData?.currentPrice?["usd"] ?? 0)"
        
    }
}
