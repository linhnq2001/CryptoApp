//
//  MarketRepository.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/10/2023.
//

import Foundation
import RxSwift

protocol MarketRepository {
    func getListCoinMarket<T:Decodable>(currency: String?, orderBy: OrderMarketBy?, priceChangeByTime: Interval, page: Int?, coinPerPage: Int?, sparkline: Bool?) -> Observable<T>
    func getDetailCoin<T:Decodable>(id: String) -> Observable<T>
    func getSimplePrice<T:Decodable>(id: String, currency: String?) -> Observable<T>
    func getExchangeInfo<T:Decodable>(id: String) -> Observable<T>
    func searchEntity<T:Decodable>(text: String) -> Observable<T>
    func getTrending<T: Decodable>() -> Observable<T>
}

public final class DefaultMarketRepository: MarketRepository{
    func searchEntity<T>(text: String) -> RxSwift.Observable<T> where T : Decodable {
        let params = ["query":text]
        return ApiHelper<T>.get(baseOtherUrl: ServiceUrl.baseUrl,url: ApiEndPoint.search, params: params)
    }
    
    func getTrending<T>() -> RxSwift.Observable<T> where T : Decodable {
        return ApiHelper<T>.get(baseOtherUrl: ServiceUrl.baseUrl, url: .searchTrending, params: [:])
    }
    
    func getExchangeInfo<T>(id: String) -> RxSwift.Observable<T> where T : Decodable {
        return ApiHelper<T>.get(baseOtherUrl: ServiceUrl.baseUrl, url: ApiEndPoint.getExchangeInfo(id: id), params: [:])
    }
    
    func getDetailCoin<T>(id: String) -> RxSwift.Observable<T> where T : Decodable {
        let params = ["localization": "false",
                      "tickers": "true",
                      "market_data": "true",
                      "community_data": "true",
                      "developer_data": "true",
                      "sparkline": "true"]
        return ApiHelper<T>.get(baseOtherUrl: ServiceUrl.baseUrl, url: ApiEndPoint.getCoinDetail(id: id), params: params)
    }
    
    func getSimplePrice<T>(id: String, currency: String?) -> RxSwift.Observable<T> where T : Decodable {
        let params = ["ids": id,
                      "vs_currencies": currency ?? "usd",
                      "include_market_cap": "true",
                      "include_24hr_vol": "true",
                      "include_24hr_change": "true",
                      "include_last_updated_at": "true",
                      "precision": "2"] as [String : Any]
        return ApiHelper<T>.get(baseOtherUrl: ServiceUrl.baseUrl,url: ApiEndPoint.simplePrice, params: params)
    }
    
    public init(){}

    func getListCoinMarket<T>(currency: String?,orderBy: OrderMarketBy?, priceChangeByTime: Interval,page: Int? = 1, coinPerPage: Int? = 100, sparkline: Bool? = false) -> RxSwift.Observable<T> where T : Decodable {
        let params = ["vs_currency": currency ?? "usd",
                      "order": orderBy?.rawValue ?? OrderMarketBy.market_cap_desc.rawValue,
                      "page": page ?? 1,
                      "per_page": coinPerPage ?? 1,
                      "sparkline": sparkline ?? false,
                      "price_change_percentage":priceChangeByTime.rawValue,
                      "locale":"en",
                      "precision":"2"] as [String : Any]
        return ApiHelper<T>.get(baseOtherUrl: ServiceUrl.baseUrl, url: ApiEndPoint.markets, params: params)
    }

}

public enum OrderMarketBy: String{
    case market_cap_desc = "market_cap_desc"
    case market_cap_asc = "market_cap_asc"
    case volume_asc = "volume_asc"
    case volume_desc = "volume_desc"
    case id_asc = "id_asc"
    case id_desc = "id_desc"
}

public enum Interval: String {
    case hour = "1h"
    case day = "24h"
    case week = "7d"
    case twoWeeks = "14d"
    case month = "30d"
    case twoHundredDay = "200d"
    case year = "1y"
}
