//
//  SearchResponse.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import Foundation

class SearchResponse: Codable {
    var coins: [CoinSearchResponse]?
    var exchanges: [ExchangeSearchResponse]?
    var categories: [CategorySearchResponse]?
    var nfts: [NftSearchResponse]?

    init(coins: [CoinSearchResponse]?, exchanges: [ExchangeSearchResponse]?, categories: [CategorySearchResponse]?, nfts: [NftSearchResponse]?) {
        self.coins = coins
        self.exchanges = exchanges
        self.categories = categories
        self.nfts = nfts
    }
}

// MARK: - Category
class CategorySearchResponse: Codable {
    var id: Int?
    var name: String?

    init(id: Int?, name: String?) {
        self.id = id
        self.name = name
    }
}

// MARK: - Coin
class CoinSearchResponse: Codable {
    var id, name, apiSymbol, symbol: String?
    var marketCapRank: Int?
    var thumb, large: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case apiSymbol = "api_symbol"
        case symbol
        case marketCapRank = "market_cap_rank"
        case thumb, large
    }

    init(id: String?, name: String?, apiSymbol: String?, symbol: String?, marketCapRank: Int?, thumb: String?, large: String?) {
        self.id = id
        self.name = name
        self.apiSymbol = apiSymbol
        self.symbol = symbol
        self.marketCapRank = marketCapRank
        self.thumb = thumb
        self.large = large
    }
}

// MARK: - Exchange
class ExchangeSearchResponse: Codable {
    var id, name: String?
    var marketType: String?
    var thumb, large: String?

    enum CodingKeys: String, CodingKey {
        case id, name
        case marketType = "market_type"
        case thumb, large
    }

    init(id: String?, name: String?, marketType: String?, thumb: String?, large: String?) {
        self.id = id
        self.name = name
        self.marketType = marketType
        self.thumb = thumb
        self.large = large
    }
}

// MARK: - Nft
class NftSearchResponse: Codable {
    var id, name, symbol: String?
    var thumb: String?

    init(id: String?, name: String?, symbol: String?, thumb: String?) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.thumb = thumb
    }
}

