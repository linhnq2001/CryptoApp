//
//  CategoryView.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 06/11/2023.
//

import Foundation
import UIKit

@IBDesignable
final public class CategoryView: UIView {
    @IBOutlet weak var titleLb: UILabel!
    @IBOutlet weak var contentView: UIView!
    var title: String? = "" {
        didSet {
            self.titleLb.text = title
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    init(title: String) {
        self.title = title
        let maxWidth = UIScreen.main.bounds.size.width - 40
        let sizeOfLabel = self.titleLb.sizeThatFits(CGSize(width: maxWidth, height: CGFloat.greatestFiniteMagnitude))
        super.init(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: sizeOfLabel))
    }

    func setupUI() {
        guard let view = self.loadViewFromNib(nibName: "CategoryView") else {return}
        view.frame = self.bounds
        addSubview(view)
    }
}
