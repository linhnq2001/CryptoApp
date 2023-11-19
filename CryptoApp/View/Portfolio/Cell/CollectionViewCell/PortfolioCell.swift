//
//  PortfolioCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 14/11/2023.
//

import UIKit
import RxSwift

class PortfolioCell: UICollectionViewCell {

    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var portfolioImage: UIImageView!
    @IBOutlet weak var valueLb: UILabel!
    @IBOutlet weak var percentageChangeLb: UILabel!
    @IBOutlet weak var valueChangeLb: UILabel!
    @IBOutlet weak var timeframeLb: UILabel!
    @IBOutlet weak var historyView: UIView!
    @IBOutlet weak var analyticsView: UIView!
    @IBOutlet weak var containerView: UIView!

    private let disposeBag = DisposeBag()
    let didTapHistoryAction = PublishSubject<Void>()
    let didTapAnalyticsAction = PublishSubject<Void>()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let didTapHistoryView = UITapGestureRecognizer(target: self, action: #selector(didTapHistory))
        historyView.addGestureRecognizer(didTapHistoryView)
        let didTapAnalyticsView = UITapGestureRecognizer(target: self, action: #selector(didTapAnalytics))
        analyticsView.addGestureRecognizer(didTapAnalyticsView)
        containerView.addShadow()
    }
    
    @objc func didTapHistory() {
        didTapHistoryAction.onNext(())
    }
    
    @objc func didTapAnalytics() {
        didTapAnalyticsAction.onNext(())
    }
    
    func configData(data: PortfolioDataSource, triggerUpdatePrice: PublishSubject<Void>) {
        guard let data = data as? Portfolio else { return }
        nameLb.text = data.name
        triggerUpdatePrice.subscribe { [weak self] _ in
            guard let self = self else {
                return
            }
            self.valueLb.text = "$ \(data.getValue())"
            self.valueChangeLb.text = "$ \(data.getValueChange())"
            self.percentageChangeLb.text = "\(data.getPercentChange()) %"
        }.disposed(by: disposeBag)
        valueLb.text = "$ \(data.getValue())"
        valueChangeLb.text = "$ \(data.getValueChange())"
        percentageChangeLb.text = "\(data.getPercentChange()) %"
        timeframeLb.text = "24h change"
    }

}
