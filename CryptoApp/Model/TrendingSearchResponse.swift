//
//  TrendingSearchResponse.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import Foundation

class TrendingSearchResponse: Codable {
    var coins: [CoinItem]?
    var categories: [CategoryTrending]?

    init(coins: [CoinItem]?, categories: [CategoryTrending]?) {
        self.coins = coins
        self.categories = categories
    }
}

// MARK: - Category
class CategoryTrending: Codable {
    var id: Int?
    var name: String?
    var marketCap1HChange: Double?
    var slug: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case marketCap1HChange = "market_cap_1h_change"
        case slug
    }

    init(id: Int?, name: String?, marketCap1HChange: Double?, slug: String?) {
        self.id = id
        self.name = name
        self.marketCap1HChange = marketCap1HChange
        self.slug = slug
    }
}

// MARK: - Coin
class CoinItem: Codable {
    var item: TrendingCoin?

    init(item: TrendingCoin?) {
        self.item = item
    }
}

// MARK: - Item
class TrendingCoin: Codable {
    var id: String?
    var coinID: Int?
    var name, symbol: String?
    var marketCapRank: Int?
    var thumb, small, large: String?
    var slug: String?
    var priceBtc: Double?
    var score: Int?

    enum CodingKeys: String, CodingKey {
        case id
        case coinID = "coin_id"
        case name, symbol
        case marketCapRank = "market_cap_rank"
        case thumb, small, large, slug
        case priceBtc = "price_btc"
        case score
    }

    init(id: String?, coinID: Int?, name: String?, symbol: String?, marketCapRank: Int?, thumb: String?, small: String?, large: String?, slug: String?, priceBtc: Double?, score: Int?) {
        self.id = id
        self.coinID = coinID
        self.name = name
        self.symbol = symbol
        self.marketCapRank = marketCapRank
        self.thumb = thumb
        self.small = small
        self.large = large
        self.slug = slug
        self.priceBtc = priceBtc
        self.score = score
    }
}
