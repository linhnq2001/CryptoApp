//
//  ExchangesCell.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import UIKit
import RxSwift

class ExchangesCell: UITableViewCell {

    @IBOutlet weak var exchangesView: UIView!

    @IBOutlet weak var imageOne: UIImageView! {
        didSet {
            imageOne.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var symbolOneLb: UILabel!
    @IBOutlet weak var nameOneLb: UILabel!
    @IBOutlet weak var priceOneLb: UILabel!
    @IBOutlet weak var volOneLb: UILabel!
    
    @IBOutlet weak var imageTwo: UIImageView! {
        didSet {
            imageTwo.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var symbolTwoLb: UILabel!
    @IBOutlet weak var nameTwoLb: UILabel!
    @IBOutlet weak var priceTwoLb: UILabel!
    @IBOutlet weak var volTwoLb: UILabel!
    
    @IBOutlet weak var imageThree: UIImageView! {
        didSet {
            imageThree.layer.cornerRadius = 15
        }
    }
    @IBOutlet weak var symbolThreeLb: UILabel!
    @IBOutlet weak var nameThreeLb: UILabel!
    @IBOutlet weak var priceThreeLb: UILabel!
    @IBOutlet weak var volThreeLb: UILabel!
    
    var listTicker: [Ticker] = []
    private let trigger = PublishSubject<String>()
    private let triggerTwo = PublishSubject<String>()
    private let triggerThree = PublishSubject<String>()
    private let disposeBag = DisposeBag()
    private let repository = DefaultMarketRepository()
    
    var didTapSeeMore: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        exchangesView.addShadow()
        selectionStyle = .none
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
                self.imageOne.kf.setImage(with: url)
            }
        }).disposed(by: disposeBag)
        
        triggerTwo.flatMap({ [weak self] id -> Observable<ExchangeInfoResponse> in
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
                self.imageTwo.kf.setImage(with: url)
            }
        }).disposed(by: disposeBag)
        
        triggerThree.flatMap({ [weak self] id -> Observable<ExchangeInfoResponse> in
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
                self.imageThree.kf.setImage(with: url)
            }
        }).disposed(by: disposeBag)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configData(data: CoinInfoResponse) {
        listTicker = data.tickers?.filter({$0.base?.uppercased() == data.symbol?.uppercased()}).sorted(by: { tickerOne, tickerTwo in
            return tickerOne.volume ?? 0.0 > tickerTwo.volume ?? 0.0
        }) ?? []
        listTicker = Array(listTicker[0..<3])
        let dataOne = listTicker[0]
        if let base = dataOne.base, let target = dataOne.target {
            self.symbolOneLb.text = "\(base)/\(target)"
        }
        self.nameOneLb.text = dataOne.market?.name ?? ""
        self.priceOneLb.text = String(format: "%.2f", dataOne.last ?? 0)
        self.volOneLb.text = "$ \(formatNumber(number: dataOne.volume ?? 0))"
        trigger.onNext(dataOne.market?.identifier ?? "")
        
        
        let dataTwo = listTicker[1]
        if let base = dataTwo.base, let target = dataTwo.target {
            self.symbolTwoLb.text = "\(base)/\(target)"
        }
        self.nameTwoLb.text = dataTwo.market?.name ?? ""
        self.priceTwoLb.text = String(format: "%.2f", dataTwo.last ?? 0)
        self.volTwoLb.text = "$ \(formatNumber(number: dataTwo.volume ?? 0))"
        triggerTwo.onNext(dataTwo.market?.identifier ?? "")
        
        let dataThree = listTicker[2]
        if let base = dataThree.base, let target = dataThree.target {
            self.symbolThreeLb.text = "\(base)/\(target)"
        }
        self.nameThreeLb.text = dataThree.market?.name ?? ""
        self.priceThreeLb.text = String(format: "%.2f", dataThree.last ?? 0)
        self.volThreeLb.text = "$ \(formatNumber(number: dataThree.volume ?? 0))"
        triggerThree.onNext(dataTwo.market?.identifier ?? "")

    }
    
    @IBAction func didTapSeeMore(_ sender: Any) {
        self.didTapSeeMore?()
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
