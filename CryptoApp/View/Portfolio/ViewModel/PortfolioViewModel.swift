//
//  PortfolioViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 09/11/2023.
//

import Foundation
import RxSwift
import RxRelay
import Differentiator
import RealmSwift

final public class PortfolioViewModel: NSObject {
    private let repository = DefaultMarketRepository()
    private let disposeBag = DisposeBag()

    public struct Input {
        let trigger: PublishSubject<Void>
        let actionCreatePortfolio: PublishSubject<Portfolio>
        let actionChangePortfolio: PublishSubject<Portfolio>
    }

    public struct Output {
        let listPortfolio: PublishRelay<[PortfolioSection]>
        let showLoading: PublishRelay<Bool>
        let didChangePortfolio: PublishSubject<Portfolio>
        let didCreatePortfolio: PublishSubject<(Bool,String)>
        let listTokenPortfolio: PublishSubject<[SectionModel<String,CoinInfoResponse>]>
    }
    
    func transform(_ input: PortfolioViewModel.Input) -> PortfolioViewModel.Output {
        let listPortfolio = PublishRelay<[PortfolioSection]>()
        let showLoading = PublishRelay<Bool>()
        let didChangePortfolio = PublishSubject<Portfolio>()
        let didCreatePortfolio = PublishSubject<(Bool,String)>()
        let listTokenPortfolio = PublishSubject<[SectionModel<String,CoinInfoResponse>]>()
        
        let output = PortfolioViewModel.Output(listPortfolio: listPortfolio, showLoading: showLoading, didChangePortfolio: didChangePortfolio, didCreatePortfolio: didCreatePortfolio, listTokenPortfolio: listTokenPortfolio)
        
        handleInitData(input, output)
        handleActionCreatePortfolio(input,output)
        handleActionChangePortfolio(input,output)
        return output
    }

    private func handleInitData(_ input: PortfolioViewModel.Input, _ output: PortfolioViewModel.Output) {
        input.trigger.flatMap { _ in
            return FirestoreHelper.shared.getAllPortfolio().map({$0.1})
        }.subscribe(onNext: { listPortfolio in
            var item = [PortfolioSection(model: .newPortfolio, items: [NewPortfolioData()])]
            if !listPortfolio.isEmpty {
                item.append(PortfolioSection(model: .portfolio, items: listPortfolio))
            }
            output.listPortfolio.accept(item.reversed())
        }).disposed(by: disposeBag)
    }

    private func handleActionCreatePortfolio(_ input: PortfolioViewModel.Input, _ output: PortfolioViewModel.Output) {
        input.actionCreatePortfolio.flatMap { portfolio in
            return FirestoreHelper.shared.addNewPortfolio(portfolio)
        }.subscribe(onNext: { (result, text) in
            output.didCreatePortfolio.onNext((result, text))
        }).disposed(by: disposeBag)
    }

    private func handleActionChangePortfolio(_ input: PortfolioViewModel.Input, _ output: PortfolioViewModel.Output) {
        input.actionChangePortfolio.flatMap { [weak self] portfolio -> Observable<[CoinInfoResponse]> in
            guard let listtoken = portfolio.listToken, let self = self else {
                return .empty()
            }
            let listid = listtoken.map({$0.id})
            return Observable.zip(listid.map({ id in
                let coinInfo: Observable<CoinInfoResponse> = self.repository.getDetailCoin(id: id)
                return coinInfo
            }))
        }.subscribe(onNext: { [weak self] data in
            guard let self = self else {return}
            self.saveLocalDataPrice(data: data)
            output.listTokenPortfolio.onNext([SectionModel(model: "", items: data)])
        }).disposed(by: disposeBag)
    }
    
    private func saveLocalDataPrice(data: [CoinInfoResponse]) {
        let realm = try! Realm()
        let listPrice: [LocalPriceData] = data.map { info in
            let priceData = LocalPriceData(id: info.id ?? "", data: SimplePrice(usd: info.marketData?.currentPrice?["usd"], usdMarketCap: info.marketData?.marketCap?["usd"], usd24HVol: 0, usd24HChange: info.marketData?.priceChange24H))
            return priceData
        }
        try! realm.write({
            realm.add(listPrice)
        })
    }
}
