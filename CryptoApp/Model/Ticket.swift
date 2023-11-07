//
//  Ticket.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import Foundation
// MARK: - Ticker
class Ticker: Codable {
    var base: String?
    var target: String?
    var market: MarketInfo?
    var last, volume: Double?
    var convertedLast, convertedVolume: [String: Double]?
    var trustScore: String?
    var bidAskSpreadPercentage: Double?
    var timestamp, lastTradedAt, lastFetchAt: String?
    var isAnomaly, isStale: Bool?
    var tradeURL: String?
    var tokenInfoURL: String?
    var coinID: String?
    var targetCoinID: String?

    enum CodingKeys: String, CodingKey {
        case base, target, market, last, volume
        case convertedLast = "converted_last"
        case convertedVolume = "converted_volume"
        case trustScore = "trust_score"
        case bidAskSpreadPercentage = "bid_ask_spread_percentage"
        case timestamp
        case lastTradedAt = "last_traded_at"
        case lastFetchAt = "last_fetch_at"
        case isAnomaly = "is_anomaly"
        case isStale = "is_stale"
        case tradeURL = "trade_url"
        case tokenInfoURL = "token_info_url"
        case coinID = "coin_id"
        case targetCoinID = "target_coin_id"
    }

    init(base: String?, target: String?, market: MarketInfo?, last: Double?, volume: Double?, convertedLast: [String: Double]?, convertedVolume: [String: Double]?, trustScore: String?, bidAskSpreadPercentage: Double?, timestamp: String?, lastTradedAt: String?, lastFetchAt: String?, isAnomaly: Bool?, isStale: Bool?, tradeURL: String?, tokenInfoURL: String?, coinID: String?, targetCoinID: String?) {
        self.base = base
        self.target = target
        self.market = market
        self.last = last
        self.volume = volume
        self.convertedLast = convertedLast
        self.convertedVolume = convertedVolume
        self.trustScore = trustScore
        self.bidAskSpreadPercentage = bidAskSpreadPercentage
        self.timestamp = timestamp
        self.lastTradedAt = lastTradedAt
        self.lastFetchAt = lastFetchAt
        self.isAnomaly = isAnomaly
        self.isStale = isStale
        self.tradeURL = tradeURL
        self.tokenInfoURL = tokenInfoURL
        self.coinID = coinID
        self.targetCoinID = targetCoinID
    }
}

// MARK: - Market
class MarketInfo: Codable {
    var name, identifier: String?
    var hasTradingIncentive: Bool?

    enum CodingKeys: String, CodingKey {
        case name, identifier
        case hasTradingIncentive = "has_trading_incentive"
    }

    init(name: String?, identifier: String?, hasTradingIncentive: Bool?) {
        self.name = name
        self.identifier = identifier
        self.hasTradingIncentive = hasTradingIncentive
    }
}
