//
//  ExchangeCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import UIKit
import Kingfisher
import RxSwift

class ExchangeCell: UITableViewCell {

    @IBOutlet weak var exchangeImage: UIImageView!{
        didSet{
            exchangeImage.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var symbolLb: UILabel!
    @IBOutlet weak var nameLb: UILabel!
    @IBOutlet weak var priceLb: UILabel!
    @IBOutlet weak var volLb: UILabel!
    private let trigger = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    private let repository = DefaultMarketRepository()

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        selectionStyle = .none
        // Configure the view for the selected state
    }
    
    public func configData(data: Ticker) {
        if let base = data.base, let target = data.target {
            self.symbolLb.text = "\(base)/\(target)"
        }
        self.nameLb.text = data.market?.name ?? ""
        self.priceLb.text = String(format: "%.2f", data.last ?? 0)
        self.volLb.text = "$ \(formatNumber(number: data.volume ?? 0))"
        trigger.onNext(data.market?.identifier ?? "")
        trigger.flatMap({ [weak self] id -> Observable<ExchangeInfoResponse> in
            guard let self = self else {
                return .empty()
            }
            if !id.isEmpty {
                return self.repository.getExchangeInfo(id: id)
            }
            return .empty()
        }).subscribe(onNext: {[weak self] info in
            guard let self = self else { return }
            if let url = URL(string: info.image ?? "") {
                self.exchangeImage.kf.setImage(with: url)
            }
        }).disposed(by: disposeBag)
    }
    
    private func formatNumber(number: Double) -> String{
        let knumber = round(number/1000.0 * 100) / 100.0
        let mnumber = round(number/1000000.0 * 100) / 100.0
        let bnumber = round(number/1000000000.0 * 100) / 100.0
        if bnumber >= 1{
            return "\(bnumber) B"
        } else if mnumber >= 1 {
            return "\(mnumber) M"
        } else if knumber >= 1{
            return "\(knumber) K"
        } else {
            return "\(number)"
        }
    }
    
}
