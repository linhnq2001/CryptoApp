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
}

public final class DefaultMarketRepository: MarketRepository{
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
