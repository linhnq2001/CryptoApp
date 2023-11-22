//
//  TransactionHistoryViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/11/2023.
//

import Foundation
import RxSwift
import RxRelay
import Differentiator

final public class TransactionHistoryViewModel: NSObject {
    private(set) var portfolio: Portfolio
    private(set) var didEditPortfolio: PublishSubject<Void>
    private let disposeBag = DisposeBag()
    
    init(portfolio: Portfolio, didEditPortfolio: PublishSubject<Void>) {
        self.portfolio = portfolio
        self.didEditPortfolio = didEditPortfolio
    }
    
    public struct Input {
        let trigger: PublishSubject<Void>
    }

    public struct Output {
        let showLoading: PublishRelay<Bool>
        let listTransactionHistory: PublishRelay<[SectionModel<String, TradeDetailHistory>]>
    }

    public func transform(_ input: TransactionHistoryViewModel.Input) -> TransactionHistoryViewModel.Output {
        let showLoading = PublishRelay<Bool>()
        let listTransactionHistory = PublishRelay<[SectionModel<String, TradeDetailHistory>]>()
        let output = TransactionHistoryViewModel.Output(showLoading: showLoading, listTransactionHistory: listTransactionHistory)
        handleInitData(input, output)
        return output
    }
    
    private func handleInitData(_ input: TransactionHistoryViewModel.Input, _ output: TransactionHistoryViewModel.Output) {
        input.trigger.flatMap { [weak self] _ -> Observable<[SectionModel<String, TradeDetailHistory>]> in
            guard let self = self else { return .empty() }
            var listToken: [TradeDetailHistory] = []
            self.portfolio.listToken.forEach { tokenInPortfolio in
                let id = tokenInPortfolio.id
                let name = tokenInPortfolio.name
                let symbol = tokenInPortfolio.symbol.uppercased()
                let urlImage = tokenInPortfolio.urlImage
                let listTrade = tokenInPortfolio.tradesHistory.map({TradeDetailHistory(id: id, name: name, symbol: symbol, urlImage: urlImage, type: $0.type, price: $0.price, amount: $0.amount, createAt: $0.createAt)})
                listToken.append(contentsOf: listTrade)
            }
            return Observable.just([SectionModel(model: "", items: listToken)])
        }.subscribe(onNext: { item in
            output.listTransactionHistory.accept(item)
        }).disposed(by: disposeBag)
    }
    
    func getName() -> String {
        return self.portfolio.name
    }
}

final public class TradeDetailHistory: NSObject,Codable {
    var id: String
    var name: String
    var symbol: String
    var urlImage: String
    var type: TradeType
    var price: Double
    var amount: Double
    var createAt: Int
    
    init(id: String, name: String, symbol: String, urlImage: String, type: TradeType, price: Double, amount: Double, createAt: Int) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.urlImage = urlImage
        self.type = type
        self.price = price
        self.amount = amount
        self.createAt = createAt
    }

}


