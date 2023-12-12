//
//  ChooseAssetViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 13/11/2023.
//

import Foundation
import RxSwift
import RxRelay

final public class ChooseAssetViewModel: NSObject {
    private let disposeBag = DisposeBag()
    private let repository = DefaultMarketRepository()
    var portfolioName: String?
    var portfolio: Portfolio?
    var didEditPortfolio: PublishSubject<Void>
    init(portfolioName: String? = nil, portfolio: Portfolio? = nil, didEditPortfolio: PublishSubject<Void>) {
        self.portfolioName = portfolioName
        self.portfolio = portfolio
        self.didEditPortfolio = didEditPortfolio
    }
    
    public struct Input {
        let trigger: PublishSubject<Void>
        let inSearch: PublishRelay<String>
        let choosseAsset: PublishRelay<String>
    }
    
    public struct Output {
        let showLoading: PublishRelay<Bool>
        let searchResult: PublishRelay<[SearchSection]>
    }
    
    public func transform(_ input: ChooseAssetViewModel.Input) -> ChooseAssetViewModel.Output {
        let showLoading = PublishRelay<Bool>()
        let searchResult = PublishRelay<[SearchSection]>()
        let output = ChooseAssetViewModel.Output(showLoading: showLoading, searchResult: searchResult)
        
        handleInitData(input, output)
        handleInSearch(input, output)
        return output
    }

    private func handleInitData(_ input: ChooseAssetViewModel.Input, _ output: ChooseAssetViewModel.Output) {
        input.trigger.flatMap { _ -> Observable<([Portfolio], [CoinInMarketResponse])> in
            let getPortfolio = FirestoreHelper.shared.getAllPortfolio().map({ $0.1 })
            let coinInMarket: Observable<[CoinInMarketResponse]> = self.repository.getListCoinMarket(currency: "usd",
                                                                                                     orderBy: .market_cap_desc,
                                                                                                     priceChangeByTime: .day,
                                                                                                     page: 1,
                                                                                                     coinPerPage: 120)
            return Observable.zip(getPortfolio, coinInMarket)
        }.subscribe(onNext: { listPortfolio, coinInMarket in
            let portfolio = listPortfolio.first(where: { $0.name == self.portfolioName })
            var item = [SearchSection(model: .portfolioCoin, items: portfolio?.listToken ?? []),
                        SearchSection(model: .marketCoin, items: coinInMarket)]
            item.removeAll(where: { $0.model == .portfolioCoin && $0.items.isEmpty })
            output.searchResult.accept(item)
        }).disposed(by: disposeBag)
    }

    private func handleInSearch(_ input: ChooseAssetViewModel.Input, _ output: ChooseAssetViewModel.Output) {
        input.inSearch.flatMap {[weak self] text -> Observable<SearchResponse> in
            guard let self = self else {
                return .empty()
            }
            output.showLoading.accept(true)
            return self.repository.searchEntity(text: text)
        }.subscribe(onNext: { response in
            output.showLoading.accept(false)
            let item = [SearchSection(model: .searchResult, items: response.coins ?? [])]
            output.searchResult.accept(item)
        }).disposed(by: disposeBag)
    }

}
