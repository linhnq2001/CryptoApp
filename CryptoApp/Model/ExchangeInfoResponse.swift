//
//  ExchangeInfoResponse.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/11/2023.
//

import Foundation

class ExchangeInfoResponse: Codable {
    var name: String?
    var yearEstablished: Int?
    var country, description: String?
    var url: String?
    var image: String?
    var facebookURL, redditURL: String?
    var telegramURL, slackURL: String?
    var otherURL1, otherURL2: String?
    var twitterHandle: String?
    var hasTradingIncentive, centralized: Bool?
    var publicNotice, alertNotice: String?
    var trustScore, trustScoreRank: Int?
    var tradeVolume24HBtc, tradeVolume24HBtcNormalized: Double?
    var tickers: [Ticker]?
    var statusUpdates: [StatusUpdate]?

    enum CodingKeys: String, CodingKey {
        case name
        case yearEstablished = "year_established"
        case country, description, url, image
        case facebookURL = "facebook_url"
        case redditURL = "reddit_url"
        case telegramURL = "telegram_url"
        case slackURL = "slack_url"
        case otherURL1 = "other_url_1"
        case otherURL2 = "other_url_2"
        case twitterHandle = "twitter_handle"
        case hasTradingIncentive = "has_trading_incentive"
        case centralized
        case publicNotice = "public_notice"
        case alertNotice = "alert_notice"
        case trustScore = "trust_score"
        case trustScoreRank = "trust_score_rank"
        case tradeVolume24HBtc = "trade_volume_24h_btc"
        case tradeVolume24HBtcNormalized = "trade_volume_24h_btc_normalized"
        case tickers
        case statusUpdates = "status_updates"
    }

    init(name: String?, yearEstablished: Int?, country: String?, description: String?, url: String?, image: String?, facebookURL: String?, redditURL: String?, telegramURL: String?, slackURL: String?, otherURL1: String?, otherURL2: String?, twitterHandle: String?, hasTradingIncentive: Bool?, centralized: Bool?, publicNotice: String?, alertNotice: String?, trustScore: Int?, trustScoreRank: Int?, tradeVolume24HBtc: Double?, tradeVolume24HBtcNormalized: Double?, tickers: [Ticker]?, statusUpdates: [StatusUpdate]?) {
        self.name = name
        self.yearEstablished = yearEstablished
        self.country = country
        self.description = description
        self.url = url
        self.image = image
        self.facebookURL = facebookURL
        self.redditURL = redditURL
        self.telegramURL = telegramURL
        self.slackURL = slackURL
        self.otherURL1 = otherURL1
        self.otherURL2 = otherURL2
        self.twitterHandle = twitterHandle
        self.hasTradingIncentive = hasTradingIncentive
        self.centralized = centralized
        self.publicNotice = publicNotice
        self.alertNotice = alertNotice
        self.trustScore = trustScore
        self.trustScoreRank = trustScoreRank
        self.tradeVolume24HBtc = tradeVolume24HBtc
        self.tradeVolume24HBtcNormalized = tradeVolume24HBtcNormalized
        self.tickers = tickers
        self.statusUpdates = statusUpdates
    }
}

// MARK: - StatusUpdate
class StatusUpdate: Codable {
    var description, category, createdAt, user: String?
    var userTitle: String?
    var pin: Bool?
    var project: Project?

    enum CodingKeys: String, CodingKey {
        case description, category
        case createdAt = "created_at"
        case user
        case userTitle = "user_title"
        case pin, project
    }

    init(description: String?, category: String?, createdAt: String?, user: String?, userTitle: String?, pin: Bool?, project: Project?) {
        self.description = description
        self.category = category
        self.createdAt = createdAt
        self.user = user
        self.userTitle = userTitle
        self.pin = pin
        self.project = project
    }
}

// MARK: - Project
class Project: Codable {
    var type: String?
    var id: String?
    var name: String?
    var image: ImageData?

    init(type: String?, id: String?, name: String?, image: ImageData?) {
        self.type = type
        self.id = id
        self.name = name
        self.image = image
    }
}
