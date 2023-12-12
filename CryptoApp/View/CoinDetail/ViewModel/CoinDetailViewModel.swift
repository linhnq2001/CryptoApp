//
//  CoinDetailViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 02/11/2023.
//

import Foundation
import RxSwift
import RxRelay

final public class CoinDetailViewModel: NSObject {
    let disposeBag = DisposeBag()
    let repository = DefaultMarketRepository()
    var id: String
    init(id: String) {
        self.id = id
    }
//    var data: CoinInfoResponse?
//
//    init(data: CoinInfoResponse? = nil) {
//        self.data = data
//    }
    public struct Input {
        let trigger: PublishSubject<Void>
    }

    public struct Output {
        let showLoading: PublishRelay<Bool>
        let infoCoin: PublishSubject<CoinInfoResponse>
    }

    public func transform(_ input: CoinDetailViewModel.Input) -> CoinDetailViewModel.Output {
        let showLoading = PublishRelay<Bool>()
        let infoCoin = PublishSubject<CoinInfoResponse>()
        let output = CoinDetailViewModel.Output(showLoading: showLoading, infoCoin: infoCoin)
        handleInitData(input, output)
        return output
    }

    private func handleInitData(_ input: CoinDetailViewModel.Input, _ output: CoinDetailViewModel.Output) {
        input.trigger.flatMap { [weak self] _ -> Observable<CoinInfoResponse> in
            guard let self = self else {
                return .empty()
            }
            return self.repository.getDetailCoin(id: self.id)
        }.subscribe(onNext: { info in
            output.infoCoin.onNext(info)
        }).disposed(by: disposeBag)
    }
}
