//
//  WatchListViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 28/10/2023.
//

import Foundation
import RxSwift
import RxRelay

final public class WatchListViewModel: NSObject {
    let repository = DefaultMarketRepository()
    let disposeBag = DisposeBag()
    
    public struct Input {
        let trigger: PublishSubject<Void>
        let tapToWatchList: PublishRelay<CoinInfoResponse>
    }
    
    public struct Output {
        let showLoading: PublishRelay<Bool>
        let watchList: PublishRelay<[CoinInfoResponse]>
        let didTapToWatchList: PublishRelay<(Bool,String)>
    }
    
    public func transform(_ input: WatchListViewModel.Input) -> WatchListViewModel.Output {
        let showLoading = PublishRelay<Bool>()
        let watchList = PublishRelay<[CoinInfoResponse]>()
        let didTapToWatchList = PublishRelay<(Bool,String)>()
        let output = Output(showLoading: showLoading, watchList: watchList, didTapToWatchList: didTapToWatchList)
        handleInitData(input, output)
        return output
    }

    private func handleInitData(_ input: WatchListViewModel.Input, _ output: WatchListViewModel.Output) {
        input.trigger.flatMap { _ -> Observable<[CoinInfoResponse]> in
            let data = FirebaseAuthHelper.shared.getCurrentUser().flatMap { user -> Observable<[CoinInfoResponse]> in
                guard let user = user else {
                    return .empty()
                }
                return Observable.zip(user.watchList.map({ id in
                    let detailCoin: Observable<CoinInfoResponse> = self.repository.getDetailCoin(id: id)
                    return detailCoin
                })) 
            }
            return data
        }.subscribe(onNext: { listData in
            output.watchList.accept(listData)
        }).disposed(by: disposeBag)
    }
}
