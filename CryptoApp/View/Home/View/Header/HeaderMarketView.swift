//
//  HeaderMarketView.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 20/10/2023.
//

import UIKit

class HeaderMarketView: UIView {
    
    
    @IBOutlet var contentView: UIView!
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }

    
    private func setupView(){
        Bundle.main.loadNibNamed("HeaderMarketView", owner: self)
        self.addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleWidth,.flexibleHeight]
    }
}
