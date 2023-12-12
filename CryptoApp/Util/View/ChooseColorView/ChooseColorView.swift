//
//  ChooseColorView.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 13/11/2023.
//

import Foundation
import UIKit

final public class ChooseColorView: UIView {
    @IBOutlet private weak var contentView: UIView!
    @IBOutlet private weak var stackView: UIStackView!
    var listColor = ["#69D5EF", "#9098F4", "#C193F8", "#80E094", "#7DAEF6", "#80E094"]
    var selectedColor: String = "#69D5EF"
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }

    func setupUI() {
        guard let view = self.loadViewFromNib(nibName: "ChooseColorView") else {return}
        view.frame = self.bounds
        addSubview(view)
        listColor.forEach { color in
            let color = UIColor(hex: color)
            let view1 = createColorView(color: color)
            stackView.addArrangedSubview(view1)
        }
    }

    func createColorView(color: UIColor) -> UIView {
        let view = UIView()
        let size = (self.bounds.size.width - 72) / 6
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.widthAnchor.constraint(equalToConstant: size),
            view.heightAnchor.constraint(equalToConstant: size)
        ])
        view.borderWidth = 3
        view.borderColor = color
        view.backgroundColor = .white
        view.cornerRadius = size / 2
        let subView = UIView()
        view.addSubview(subView)
        subView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            subView.widthAnchor.constraint(equalToConstant: size - 10),
            subView.heightAnchor.constraint(equalToConstant: size - 10)
        ])
        subView.backgroundColor = color
        subView.cornerRadius = (size - 10) / 2
        return view
    }
}
