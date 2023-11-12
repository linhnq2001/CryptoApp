//
//  SearchViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import Foundation
import RxSwift
import RxRelay

final public class SearchViewModel: NSObject {
    private let disposeBag = DisposeBag()
    private let repository = DefaultMarketRepository()
    private var listSection: [SearchSection] = []
    public struct Input {
        let trigger: PublishSubject<Void>
        let inSearch: PublishRelay<String>
        let actionTapToken: PublishRelay<(SearchTitle,String)>
        let actionCleanRecent: PublishSubject<Void>
    }
    
    public struct Output {
        let showLoading: PublishRelay<Bool>
        let searchResult: PublishRelay<[SearchSection]>
        let didCleanRecent: PublishRelay<Bool>
    }

    public func transform(_ input: SearchViewModel.Input) -> SearchViewModel.Output {
        let showLoading = PublishRelay<Bool>()
        let searchResult = PublishRelay<[SearchSection]>()
        let historySearch = PublishRelay<[CoinInfoResponse]>()
        let trendingSearch = PublishRelay<[CoinInfoResponse]>()
        let didCleanRecent = PublishRelay<Bool>()
        let output = SearchViewModel.Output(showLoading: showLoading, searchResult: searchResult, didCleanRecent: didCleanRecent)
        handleInitData(input, output)
        handleInSearch(input, output)
        handleDidTapToken(input,output)
        handleDidTapCleanRecent(input,output)
        return output
    }

    private func handleDidTapCleanRecent(_ input: SearchViewModel.Input, _ output: SearchViewModel.Output) {
        input.actionCleanRecent.flatMap { _ in
            return FirestoreHelper.shared.clearRecentSearchList()
        }.subscribe(onNext: { [weak self] (result, error) in
            guard let self = self else { return }
            if result {
                self.listSection = self.listSection.filter({$0.model != .recentSearch})
                output.searchResult.accept(self.listSection)
            }
        }).disposed(by: disposeBag)
    }

    private func handleDidTapToken(_ input: SearchViewModel.Input, _ output: SearchViewModel.Output) {
        input.actionTapToken.flatMap { (searchTitle, id) -> Observable<(Bool,String)> in
            if searchTitle == .searchResult {
                 return FirestoreHelper.shared.addTokenToRecentSearch(id)
            }
            return .just((false, ""))
        }.subscribe(onNext: { (result, _) in
            if result {
                print("addTokenToRecentSearch Success")
            } else {
                print("addTokenToRecentSearch Fail")
            }
        }).disposed(by: disposeBag)
    }

    private func handleInitData(_ input: SearchViewModel.Input, _ output: SearchViewModel.Output) {
        input.trigger.flatMap { _ -> Observable<(TrendingSearchResponse,[CoinInfoResponse])> in
            output.showLoading.accept(true)
            let trendingSearch: Observable<TrendingSearchResponse> = self.repository.getTrending()
//            let finalTrendingResult: Observable<[CoinInfoResponse]> = trendingSearch.flatMap { response -> Observable<[CoinInfoResponse]> in
//                guard let listId = response.coins?.map({$0.item?.id ?? ""}) else {
//                    return .just([])
//                }
//                return Observable.zip(listId.map({ id in
//                    let coinInfo: Observable<CoinInfoResponse> = self.repository.getDetailCoin(id: id)
//                    return coinInfo
//                }))
//            }
            let recentSearch: Observable<[CoinInfoResponse]> = FirestoreHelper.shared.getRecentSearchList().flatMap { result, listId -> Observable<[CoinInfoResponse]> in
                if listId.isEmpty {
                    return .just([])
                }
                return Observable.zip(listId.map({ id in
                    let coinInfo: Observable<CoinInfoResponse> = self.repository.getDetailCoin(id: id)
                    return coinInfo
                }))
            }
            return Observable.combineLatest(trendingSearch,recentSearch)
        }.subscribe(onNext: { trendingSearch,recentSearch in
            output.showLoading.accept(false)
            var trendingCoins = trendingSearch.coins ?? []
            trendingCoins = trendingCoins.sorted(by: { item1, item2 in
                guard let rank1 = item1.item?.marketCapRank, let rank2 = item2.item?.marketCapRank else {return false}
                return rank1 < rank2
            })
            var item = [
                SearchSection(model: .recentSearch, items: [RecentSearchDataSource(listItem: recentSearch)]),
                SearchSection(model: .trendingSearch, items: trendingCoins)]
            if recentSearch.isEmpty {
                item.removeAll(where: {$0.model == .recentSearch})
            }
            self.listSection = item
            output.searchResult.accept(item)
        }).disposed(by: disposeBag)
    }

    private func handleInSearch(_ input: SearchViewModel.Input, _ output: SearchViewModel.Output) {
        input.inSearch.flatMap {[weak self] text -> Observable<SearchResponse> in
            guard let self = self else {
                return .empty()
            }
            output.showLoading.accept(true)
//            let searchResult: Observable<SearchResponse> = self.repository.searchEntity(text: text)
//            let finalResult = searchResult.flatMap { response -> Observable<[CoinInfoResponse]> in
//                guard let listId = response.coins?.sorted(by: { coin1, coin2 in
//                    guard let rank1 = coin1.marketCapRank, let rank2 = coin2.marketCapRank else {
//                        return false
//                    }
//                    return rank1 < rank2
//                }).map({$0.id ?? ""})[0..<10] else {
//                    return .empty()
//                }
//                return Observable.zip(listId.map({ id in
//                    let coinInfo: Observable<CoinInfoResponse> = self.repository.getDetailCoin(id: id)
//                    return coinInfo
//                }))
//            }
            return self.repository.searchEntity(text: text)
        }.subscribe(onNext: { response in
            output.showLoading.accept(false)
            let item = [SearchSection(model: .searchResult, items: response.coins ?? [])]
            self.listSection = item
            output.searchResult.accept(item)
        }).disposed(by: disposeBag)
    }
    
}
