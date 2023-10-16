//
//  MarketResponse.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/10/2023.
//

import Foundation

public class CoinInMarketResponse: Codable {
    var id, symbol, name: String?
    var image: String?
    var currentPrice: Double?
    var marketCap, marketCapRank: Int?
    var fullyDilutedValuation: Int?
    var totalVolume, high24H, low24H, priceChange24H: Double?
    var priceChangePercentage24H, marketCapChange24H, marketCapChangePercentage24H, circulatingSupply: Double?
    var totalSupply, maxSupply: Double?
    var ath, athChangePercentage: Double?
    var athDate: String?
    var atl, atlChangePercentage: Double?
    var atlDate: String?
    var roi: Roi?
    var lastUpdated: String?
    var priceChangePercentage24HInCurrency: Double?
    var priceChangePercentage1HInCurrency: Double?
    var priceChangePercentage7DInCurrency: Double?
    var priceChangePercentage14DInCurrency: Double?
    var priceChangePercentage30DInCurrency: Double?
    var priceChangePercentage200DInCurrency: Double?
    var priceChangePercentage1YInCurrency: Double?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name, image
        case currentPrice = "current_price"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case circulatingSupply = "circulating_supply"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case roi
        case lastUpdated = "last_updated"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case priceChangePercentage1HInCurrency = "price_change_percentage_1h_in_currency"
        case priceChangePercentage7DInCurrency = "price_change_percentage_7d_in_currency"
        case priceChangePercentage14DInCurrency = "price_change_percentage_14d_in_currency"
        case priceChangePercentage30DInCurrency = "price_change_percentage_30d_in_currency"
        case priceChangePercentage200DInCurrency = "price_change_percentage_200d_in_currency"
        case priceChangePercentage1YInCurrency = "price_change_percentage_1y_in_currency"
    }

    init(id: String?, symbol: String?, name: String?, image: String?, currentPrice: Double?, marketCap: Int?, marketCapRank: Int?, fullyDilutedValuation: Int?, totalVolume: Double?, high24H: Double?, low24H: Double?, priceChange24H: Double?, priceChangePercentage24H: Double?, marketCapChange24H: Double?, marketCapChangePercentage24H: Double?, circulatingSupply: Double?, totalSupply: Double?, maxSupply: Double?, ath: Double?, athChangePercentage: Double?, athDate: String?, atl: Double?, atlChangePercentage: Double?, atlDate: String?, roi: Roi?, lastUpdated: String?, priceChangePercentage24HInCurrency: Double?, priceChangePercentage1HInCurrency: Double?, priceChangePercentage7DInCurrency: Double?, priceChangePercentage14DInCurrency: Double?, priceChangePercentage30DInCurrency: Double?, priceChangePercentage200DInCurrency: Double?, priceChangePercentage1YInCurrency: Double?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.image = image
        self.currentPrice = currentPrice
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.circulatingSupply = circulatingSupply
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.roi = roi
        self.lastUpdated = lastUpdated
        self.priceChangePercentage24HInCurrency = priceChangePercentage24HInCurrency
        self.priceChangePercentage1HInCurrency = priceChangePercentage1HInCurrency
        self.priceChangePercentage7DInCurrency = priceChangePercentage7DInCurrency
        self.priceChangePercentage14DInCurrency = priceChangePercentage14DInCurrency
        self.priceChangePercentage30DInCurrency = priceChangePercentage30DInCurrency
        self.priceChangePercentage200DInCurrency = priceChangePercentage200DInCurrency
        self.priceChangePercentage1YInCurrency = priceChangePercentage1YInCurrency
        
    }
}

// MARK: - Roi
class Roi: Codable {
    var times: Double?
    var currency: String?
    var percentage: Double?

    init(times: Double?, currency: String?, percentage: Double?) {
        self.times = times
        self.currency = currency
        self.percentage = percentage
    }
}
