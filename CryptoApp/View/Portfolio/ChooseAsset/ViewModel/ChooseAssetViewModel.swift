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
    init(portfolioName: String? = nil) {
        self.portfolioName = portfolioName
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
        input.trigger.flatMap { _ -> Observable<[CoinInMarketResponse]> in
            return self.repository.getListCoinMarket(currency: "usd", orderBy: .market_cap_desc, priceChangeByTime: .day,page: 1,coinPerPage: 120)
        }.subscribe(onNext: { response in
            output.searchResult.accept([SearchSection(model: .marketCoin, items: response)])
        }).disposed(by: disposeBag)
    }
    
    private func handleInSearch(_ input: ChooseAssetViewModel.Input, _ output: ChooseAssetViewModel.Output) {
        
    }
}
