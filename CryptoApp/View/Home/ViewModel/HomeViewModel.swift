//
//  HomeViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/10/2023.
//

import Foundation
import RxSwift
import RxRelay

final public class HomeViewModel: NSObject {
    
    private var disposeBag = DisposeBag()
    private let repository = DefaultMarketRepository()
    
    public struct Input {
        let trigger: PublishSubject<Void>
    }
    
    public struct Output {
        let marketResponse: PublishSubject<[CoinInMarketResponse]>
        let showLoading: PublishRelay<Bool>
    }
    
    public func transform(_ input: HomeViewModel.Input) -> HomeViewModel.Output {
        let marketResponse = PublishSubject<[CoinInMarketResponse]>()
        let showLoading = PublishRelay<Bool>()
        
        let output = Output(marketResponse: marketResponse, showLoading: showLoading)
        
        handleTrigger(input,output)
        
        return output
    }
    
    private func handleTrigger(_ input: HomeViewModel.Input, _ output: HomeViewModel.Output){
        input.trigger.flatMap { [weak self] _ -> Observable<[CoinInMarketResponse]> in
            guard let self = self else {
                return .empty()
            }
            output.showLoading.accept(true)
            return self.repository.getListCoinMarket(currency: "usd", orderBy: .market_cap_desc, priceChangeByTime: .day, page: 1, coinPerPage: 100, sparkline: false)
        }.subscribe(onNext: {response in
            output.showLoading.accept(false)
            output.marketResponse.onNext(response)
        }).disposed(by: disposeBag)
    }
}
