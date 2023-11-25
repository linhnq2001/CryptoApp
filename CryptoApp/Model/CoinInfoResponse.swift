//
//  CoinInfoResponse.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 29/10/2023.
//

import Foundation

class CoinInfoResponse: Codable, SearchDataSource {
    var id: String?
    var symbol, name: String?
    var assetPlatformID: String?
    var platforms: Platforms?
    var detailPlatforms: [String: DetailPlatform]?
    var blockTimeInMinutes: Int?
    var hashingAlgorithm: String?
    var categories: [String]?
    var previewListing: Bool?
    var publicNotice: String?
    var localization, description: Tion?
    var links: Links?
    var image: ImageData?
    var countryOrigin, genesisDate: String?
    var sentimentVotesUpPercentage, sentimentVotesDownPercentage: Double?
    var watchlistPortfolioUsers, marketCapRank, coingeckoRank: Int?
    var coingeckoScore, developerScore, communityScore, liquidityScore: Double?
    var publicInterestScore: Double?
    var marketData: MarketData?
    var communityData: CommunityData?
    var developerData: DeveloperData?
//    var publicInterestStats: PublicInterestStats?
//    var statusUpdates: [JSONAny]?
    var lastUpdated: String?
    var tickers: [Ticker]?

    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case assetPlatformID = "asset_platform_id"
        case platforms
        case detailPlatforms = "detail_platforms"
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case previewListing = "preview_listing"
        case publicNotice = "public_notice"
        case localization, description, links, image
        case countryOrigin = "country_origin"
        case genesisDate = "genesis_date"
        case sentimentVotesUpPercentage = "sentiment_votes_up_percentage"
        case sentimentVotesDownPercentage = "sentiment_votes_down_percentage"
        case watchlistPortfolioUsers = "watchlist_portfolio_users"
        case marketCapRank = "market_cap_rank"
        case coingeckoRank = "coingecko_rank"
        case coingeckoScore = "coingecko_score"
        case developerScore = "developer_score"
        case communityScore = "community_score"
        case liquidityScore = "liquidity_score"
        case publicInterestScore = "public_interest_score"
        case marketData = "market_data"
        case communityData = "community_data"
        case developerData = "developer_data"
//        case publicInterestStats = "public_interest_stats"
//        case statusUpdates = "status_updates"
        case lastUpdated = "last_updated"
        case tickers
    }
    
    enum PlatformID: String, Codable {
        case ethereum
        case oasys
        case xdai
        case thundercore
        case mantle
        case base
        case neonEvm = "neon-evm"
        case zksync
        case polygonZkEvm = "polygon-zkevm"
        case arbitrumOne = "arbitrum-one"
        case hederaHashgraph = "hedera-hashgraph"
        case kardiachain
        case polkadot
        case tron
        case rollux
        case aptos
        case bsc = "binance-smart-chain"
        case op = "optimistic-ethereum"
        case polygonPos = "polygon-pos"
        case moonbeam
        case solana
        case tomochain
        case avalanche
        case fantom
        case harmonyShardZero = "harmony-shard-0"
        case okexChain = "okex-chain"
        case sora
        case ronin
        case boba
        case cronos
        case aurora
        case metisAndromeda = "metis-andromeda"
        case fuse
        case kucoinCommunityChain = "kucoin-community-chain"
        case meter
        case telos
        case syscoin
        case milkomedaCardano = "milkomeda-cardano"
        case defiKingdomsBlockchain = "defi-kingdoms-blockchain"
        case elastos
        case evmos
        case sxNetwork = "sx-network"
        case energi
        case conflux
        case cosmos
        case astar
        case kava
        case bitgert
        case arbitrumNova = "arbitrum-nova"
        case canto
        case dogechain
        case velas
        case klayToken = "klay-token"
        case stepNetwork = "step-network"
        case empty = ""
    }

    init(id: String?, symbol: String?, name: String?, assetPlatformID: String?, platforms: Platforms, detailPlatforms: [String : DetailPlatform]?, blockTimeInMinutes: Int?, hashingAlgorithm: String?, categories: [String]?, previewListing: Bool?, publicNotice: String?, localization: Tion?, description: Tion?, links: Links?, image: ImageData?, countryOrigin: String?, genesisDate: String?, sentimentVotesUpPercentage: Double?, sentimentVotesDownPercentage: Double?, watchlistPortfolioUsers: Int?, marketCapRank: Int?, coingeckoRank: Int?, coingeckoScore: Double?, developerScore: Double?, communityScore: Double?, liquidityScore: Double?, publicInterestScore: Double?, marketData: MarketData?,communityData: CommunityData?, developerData: DeveloperData?, lastUpdated: String?, tickers: [Ticker]?) {
        self.id = id
        self.symbol = symbol
        self.name = name
        self.assetPlatformID = assetPlatformID
        self.platforms = platforms
        self.detailPlatforms = detailPlatforms
        self.blockTimeInMinutes = blockTimeInMinutes
        self.hashingAlgorithm = hashingAlgorithm
        self.categories = categories
        self.previewListing = previewListing
        self.publicNotice = publicNotice
        self.localization = localization
        self.description = description
        self.links = links
        self.image = image
        self.countryOrigin = countryOrigin
        self.genesisDate = genesisDate
        self.sentimentVotesUpPercentage = sentimentVotesUpPercentage
        self.sentimentVotesDownPercentage = sentimentVotesDownPercentage
        self.watchlistPortfolioUsers = watchlistPortfolioUsers
        self.marketCapRank = marketCapRank
        self.coingeckoRank = coingeckoRank
        self.coingeckoScore = coingeckoScore
        self.developerScore = developerScore
        self.communityScore = communityScore
        self.liquidityScore = liquidityScore
        self.publicInterestScore = publicInterestScore
        self.marketData = marketData
        self.communityData = communityData
        self.developerData = developerData
//        self.publicInterestStats = publicInterestStats
//        self.statusUpdates = statusUpdates
        self.lastUpdated = lastUpdated
        self.tickers = tickers
    }
    
    public func getCurrentPrice() -> String {
        return String(describing: self.marketData?.currentPrice?["usd"] ?? 0)
    }
}

// MARK: - Platforms
class Platforms: Codable {
    var ethereum, xdai, nearProtocol, arbitrumOne: String?
    var binanceSmartChain, polygonPos, huobiToken, optimisticEthereum: String?
    var avalanche, harmonyShard0, sora, energi: String?

    enum CodingKeys: String, CodingKey {
        case ethereum, xdai
        case nearProtocol = "near-protocol"
        case arbitrumOne = "arbitrum-one"
        case binanceSmartChain = "binance-smart-chain"
        case polygonPos = "polygon-pos"
        case huobiToken = "huobi-token"
        case optimisticEthereum = "optimistic-ethereum"
        case avalanche
        case harmonyShard0 = "harmony-shard-0"
        case sora, energi
    }

    init(ethereum: String?, xdai: String?, nearProtocol: String?, arbitrumOne: String?, binanceSmartChain: String?, polygonPos: String?, huobiToken: String?, optimisticEthereum: String?, avalanche: String?, harmonyShard0: String?, sora: String?, energi: String?) {
        self.ethereum = ethereum
        self.xdai = xdai
        self.nearProtocol = nearProtocol
        self.arbitrumOne = arbitrumOne
        self.binanceSmartChain = binanceSmartChain
        self.polygonPos = polygonPos
        self.huobiToken = huobiToken
        self.optimisticEthereum = optimisticEthereum
        self.avalanche = avalanche
        self.harmonyShard0 = harmonyShard0
        self.sora = sora
        self.energi = energi
    }
}

// MARK: - CommunityData
class CommunityData: Codable {
    var facebookLikes: Int?
    var twitterFollowers, redditSubscribers: Int?
    var redditAveragePosts48H, redditAverageComments48H: Double?
    var redditAccountsActive48H: Int?
    var telegramChannelUserCount: Int?

    enum CodingKeys: String, CodingKey {
        case facebookLikes = "facebook_likes"
        case twitterFollowers = "twitter_followers"
        case redditAveragePosts48H = "reddit_average_posts_48h"
        case redditAverageComments48H = "reddit_average_comments_48h"
        case redditSubscribers = "reddit_subscribers"
        case redditAccountsActive48H = "reddit_accounts_active_48h"
        case telegramChannelUserCount = "telegram_channel_user_count"
    }

    init(facebookLikes: Int?, twitterFollowers: Int?, redditAveragePosts48H: Double?, redditAverageComments48H: Double?, redditSubscribers: Int?, redditAccountsActive48H: Int?, telegramChannelUserCount: Int?) {
        self.facebookLikes = facebookLikes
        self.twitterFollowers = twitterFollowers
        self.redditAveragePosts48H = redditAveragePosts48H
        self.redditAverageComments48H = redditAverageComments48H
        self.redditSubscribers = redditSubscribers
        self.redditAccountsActive48H = redditAccountsActive48H
        self.telegramChannelUserCount = telegramChannelUserCount
    }
}

class Tion: Codable {
    var en, de, es, fr: String?
    var it, pl, ro, hu: String?
    var nl, pt, sv, vi: String?
    var tr, ru, ja, zh: String?
    var zhTw, ko, ar, th: String?
    var id, cs, da, el: String?
    var hi, no, sk, uk: String?
    var he, fi, bg, hr: String?
    var lt, sl: String?

    enum CodingKeys: String, CodingKey {
        case en, de, es, fr, it, pl, ro, hu, nl, pt, sv, vi, tr, ru, ja, zh
        case zhTw = "zh-tw"
        case ko, ar, th, id, cs, da, el, hi, no, sk, uk, he, fi, bg, hr, lt, sl
    }

    init(en: String?, de: String?, es: String?, fr: String?, it: String?, pl: String?, ro: String?, hu: String?, nl: String?, pt: String?, sv: String?, vi: String?, tr: String?, ru: String?, ja: String?, zh: String?, zhTw: String?, ko: String?, ar: String?, th: String?, id: String?, cs: String?, da: String?, el: String?, hi: String?, no: String?, sk: String?, uk: String?, he: String?, fi: String?, bg: String?, hr: String?, lt: String?, sl: String?) {
        self.en = en
        self.de = de
        self.es = es
        self.fr = fr
        self.it = it
        self.pl = pl
        self.ro = ro
        self.hu = hu
        self.nl = nl
        self.pt = pt
        self.sv = sv
        self.vi = vi
        self.tr = tr
        self.ru = ru
        self.ja = ja
        self.zh = zh
        self.zhTw = zhTw
        self.ko = ko
        self.ar = ar
        self.th = th
        self.id = id
        self.cs = cs
        self.da = da
        self.el = el
        self.hi = hi
        self.no = no
        self.sk = sk
        self.uk = uk
        self.he = he
        self.fi = fi
        self.bg = bg
        self.hr = hr
        self.lt = lt
        self.sl = sl
    }
}

// MARK: - DetailPlatform
class DetailPlatform: Codable {
    var decimalPlace: Int?
    var contractAddress: String?

    enum CodingKeys: String, CodingKey {
        case decimalPlace = "decimal_place"
        case contractAddress = "contract_address"
    }

    init(decimalPlace: Int?, contractAddress: String?) {
        self.decimalPlace = decimalPlace
        self.contractAddress = contractAddress
    }
}

// MARK: - DeveloperData
class DeveloperData: Codable {
    var forks, stars, subscribers, totalIssues: Int?
    var closedIssues, pullRequestsMerged, pullRequestContributors: Int?
    var codeAdditionsDeletions4_Weeks: CodeAdditionsDeletions4_Weeks?
    var commitCount4_Weeks: Int?
    var last4_WeeksCommitActivitySeries: [Int]?

    enum CodingKeys: String, CodingKey {
        case forks, stars, subscribers
        case totalIssues = "total_issues"
        case closedIssues = "closed_issues"
        case pullRequestsMerged = "pull_requests_merged"
        case pullRequestContributors = "pull_request_contributors"
        case codeAdditionsDeletions4_Weeks = "code_additions_deletions_4_weeks"
        case commitCount4_Weeks = "commit_count_4_weeks"
        case last4_WeeksCommitActivitySeries = "last_4_weeks_commit_activity_series"
    }

    init(forks: Int?, stars: Int?, subscribers: Int?, totalIssues: Int?, closedIssues: Int?, pullRequestsMerged: Int?, pullRequestContributors: Int?, codeAdditionsDeletions4_Weeks: CodeAdditionsDeletions4_Weeks?, commitCount4_Weeks: Int?, last4_WeeksCommitActivitySeries: [Int]?) {
        self.forks = forks
        self.stars = stars
        self.subscribers = subscribers
        self.totalIssues = totalIssues
        self.closedIssues = closedIssues
        self.pullRequestsMerged = pullRequestsMerged
        self.pullRequestContributors = pullRequestContributors
        self.codeAdditionsDeletions4_Weeks = codeAdditionsDeletions4_Weeks
        self.commitCount4_Weeks = commitCount4_Weeks
        self.last4_WeeksCommitActivitySeries = last4_WeeksCommitActivitySeries
    }
}

// MARK: - CodeAdditionsDeletions4_Weeks
class CodeAdditionsDeletions4_Weeks: Codable {
    var additions, deletions: Int?

    init(additions: Int?, deletions: Int?) {
        self.additions = additions
        self.deletions = deletions
    }
}

// MARK: - Links
class Links: Codable {
    var homepage: [String]?
    var blockchainSite, officialForumURL: [String]?
    var chatURL, announcementURL: [String]?
    var twitterScreenName: String?
    var facebookUsername: String?
    var telegramChannelIdentifier: String?
    var subredditURL: String?
    var reposURL: ReposURL?

    enum CodingKeys: String, CodingKey {
        case homepage
        case blockchainSite = "blockchain_site"
        case officialForumURL = "official_forum_url"
        case chatURL = "chat_url"
        case announcementURL = "announcement_url"
        case twitterScreenName = "twitter_screen_name"
        case facebookUsername = "facebook_username"
        case telegramChannelIdentifier = "telegram_channel_identifier"
        case subredditURL = "subreddit_url"
        case reposURL = "repos_url"
    }

    init(homepage: [String]?, blockchainSite: [String]?, officialForumURL: [String]?, chatURL: [String]?, announcementURL: [String]?, twitterScreenName: String?, facebookUsername: String?, telegramChannelIdentifier: String?, subredditURL: String?, reposURL: ReposURL?) {
        self.homepage = homepage
        self.blockchainSite = blockchainSite
        self.officialForumURL = officialForumURL
        self.chatURL = chatURL
        self.announcementURL = announcementURL
        self.twitterScreenName = twitterScreenName
        self.facebookUsername = facebookUsername
        self.telegramChannelIdentifier = telegramChannelIdentifier
        self.subredditURL = subredditURL
        self.reposURL = reposURL
    }
}

// MARK: - ReposURL
class ReposURL: Codable {
    var github: [String]?
    var bitbucket: [String]?

    init(github: [String]?, bitbucket: [String]?) {
        self.github = github
        self.bitbucket = bitbucket
    }
}

// MARK: - MarketData
class MarketData: Codable {
    var currentPrice: [String: Double]?
    var totalValueLocked: [String: Double]?
    var mcapToTvlRatio, fdvToTvlRatio: Double?
    var roi: Roi?
    var ath, athChangePercentage: [String: Double]?
    var athDate: [String: String]?
    var atl, atlChangePercentage: [String: Double]?
    var atlDate: [String: String]?
    var marketCap: [String: Double]?
    var marketCapRank: Int?
    var fullyDilutedValuation: [String: Double]?
    var marketCapFdvRatio: Double?
    var totalVolume, high24H, low24H: [String: Double?]?
    var priceChange24H, priceChangePercentage24H, priceChangePercentage7D, priceChangePercentage14D: Double?
    var priceChangePercentage30D, priceChangePercentage60D, priceChangePercentage200D, priceChangePercentage1Y: Double?
    var marketCapChange24H: Double?
    var marketCapChangePercentage24H: Double?
    var priceChange24HInCurrency, priceChangePercentage1HInCurrency, priceChangePercentage24HInCurrency, priceChangePercentage7DInCurrency: [String: Double]?
    var priceChangePercentage14DInCurrency, priceChangePercentage30DInCurrency, priceChangePercentage60DInCurrency, priceChangePercentage200DInCurrency: [String: Double]?
    var priceChangePercentage1YInCurrency, marketCapChange24HInCurrency, marketCapChangePercentage24HInCurrency: [String: Double]?
    var totalSupply, maxSupply, circulatingSupply: Double?
    var sparkline7D: Sparkline7D?
    var lastUpdated: String?

    enum CodingKeys: String, CodingKey {
        case currentPrice = "current_price"
        case totalValueLocked = "total_value_locked"
        case mcapToTvlRatio = "mcap_to_tvl_ratio"
        case fdvToTvlRatio = "fdv_to_tvl_ratio"
        case roi, ath
        case athChangePercentage = "ath_change_percentage"
        case athDate = "ath_date"
        case atl
        case atlChangePercentage = "atl_change_percentage"
        case atlDate = "atl_date"
        case marketCap = "market_cap"
        case marketCapRank = "market_cap_rank"
        case fullyDilutedValuation = "fully_diluted_valuation"
        case marketCapFdvRatio = "market_cap_fdv_ratio"
        case totalVolume = "total_volume"
        case high24H = "high_24h"
        case low24H = "low_24h"
        case priceChange24H = "price_change_24h"
        case priceChangePercentage24H = "price_change_percentage_24h"
        case priceChangePercentage7D = "price_change_percentage_7d"
        case priceChangePercentage14D = "price_change_percentage_14d"
        case priceChangePercentage30D = "price_change_percentage_30d"
        case priceChangePercentage60D = "price_change_percentage_60d"
        case priceChangePercentage200D = "price_change_percentage_200d"
        case priceChangePercentage1Y = "price_change_percentage_1y"
        case marketCapChange24H = "market_cap_change_24h"
        case marketCapChangePercentage24H = "market_cap_change_percentage_24h"
        case priceChange24HInCurrency = "price_change_24h_in_currency"
        case priceChangePercentage1HInCurrency = "price_change_percentage_1h_in_currency"
        case priceChangePercentage24HInCurrency = "price_change_percentage_24h_in_currency"
        case priceChangePercentage7DInCurrency = "price_change_percentage_7d_in_currency"
        case priceChangePercentage14DInCurrency = "price_change_percentage_14d_in_currency"
        case priceChangePercentage30DInCurrency = "price_change_percentage_30d_in_currency"
        case priceChangePercentage60DInCurrency = "price_change_percentage_60d_in_currency"
        case priceChangePercentage200DInCurrency = "price_change_percentage_200d_in_currency"
        case priceChangePercentage1YInCurrency = "price_change_percentage_1y_in_currency"
        case marketCapChange24HInCurrency = "market_cap_change_24h_in_currency"
        case marketCapChangePercentage24HInCurrency = "market_cap_change_percentage_24h_in_currency"
        case totalSupply = "total_supply"
        case maxSupply = "max_supply"
        case circulatingSupply = "circulating_supply"
        case sparkline7D = "sparkline_7d"
        case lastUpdated = "last_updated"
        
    }

    init(currentPrice: [String: Double]?, totalValueLocked: [String: Double]?, mcapToTvlRatio: Double?, fdvToTvlRatio: Double?, roi: Roi?, ath: [String: Double]?, athChangePercentage: [String: Double]?, athDate: [String: String]?, atl: [String: Double]?, atlChangePercentage: [String: Double]?, atlDate: [String: String]?, marketCap: [String: Double]?, marketCapRank: Int?, fullyDilutedValuation: [String: Double]?, marketCapFdvRatio: Double?, totalVolume: [String: Double]?, high24H: [String: Double]?, low24H: [String: Double]?, priceChange24H: Double?, priceChangePercentage24H: Double?, priceChangePercentage7D: Double?, priceChangePercentage14D: Double?, priceChangePercentage30D: Double?, priceChangePercentage60D: Double?, priceChangePercentage200D: Double?, priceChangePercentage1Y: Double?, marketCapChange24H: Double?, marketCapChangePercentage24H: Double?, priceChange24HInCurrency: [String: Double]?, priceChangePercentage1HInCurrency: [String: Double]?, priceChangePercentage24HInCurrency: [String: Double]?, priceChangePercentage7DInCurrency: [String: Double]?, priceChangePercentage14DInCurrency: [String: Double]?, priceChangePercentage30DInCurrency: [String: Double]?, priceChangePercentage60DInCurrency: [String: Double]?, priceChangePercentage200DInCurrency: [String: Double]?, priceChangePercentage1YInCurrency: [String: Double]?, marketCapChange24HInCurrency: [String: Double]?, marketCapChangePercentage24HInCurrency: [String: Double]?, totalSupply: Double?, maxSupply: Double?, circulatingSupply: Double?, lastUpdated: String?, sparkline7D: Sparkline7D?) {
        self.currentPrice = currentPrice
        self.totalValueLocked = totalValueLocked
        self.mcapToTvlRatio = mcapToTvlRatio
        self.fdvToTvlRatio = fdvToTvlRatio
        self.roi = roi
        self.ath = ath
        self.athChangePercentage = athChangePercentage
        self.athDate = athDate
        self.atl = atl
        self.atlChangePercentage = atlChangePercentage
        self.atlDate = atlDate
        self.marketCap = marketCap
        self.marketCapRank = marketCapRank
        self.fullyDilutedValuation = fullyDilutedValuation
        self.marketCapFdvRatio = marketCapFdvRatio
        self.totalVolume = totalVolume
        self.high24H = high24H
        self.low24H = low24H
        self.priceChange24H = priceChange24H
        self.priceChangePercentage24H = priceChangePercentage24H
        self.priceChangePercentage7D = priceChangePercentage7D
        self.priceChangePercentage14D = priceChangePercentage14D
        self.priceChangePercentage30D = priceChangePercentage30D
        self.priceChangePercentage60D = priceChangePercentage60D
        self.priceChangePercentage200D = priceChangePercentage200D
        self.priceChangePercentage1Y = priceChangePercentage1Y
        self.marketCapChange24H = marketCapChange24H
        self.marketCapChangePercentage24H = marketCapChangePercentage24H
        self.priceChange24HInCurrency = priceChange24HInCurrency
        self.priceChangePercentage1HInCurrency = priceChangePercentage1HInCurrency
        self.priceChangePercentage24HInCurrency = priceChangePercentage24HInCurrency
        self.priceChangePercentage7DInCurrency = priceChangePercentage7DInCurrency
        self.priceChangePercentage14DInCurrency = priceChangePercentage14DInCurrency
        self.priceChangePercentage30DInCurrency = priceChangePercentage30DInCurrency
        self.priceChangePercentage60DInCurrency = priceChangePercentage60DInCurrency
        self.priceChangePercentage200DInCurrency = priceChangePercentage200DInCurrency
        self.priceChangePercentage1YInCurrency = priceChangePercentage1YInCurrency
        self.marketCapChange24HInCurrency = marketCapChange24HInCurrency
        self.marketCapChangePercentage24HInCurrency = marketCapChangePercentage24HInCurrency
        self.totalSupply = totalSupply
        self.maxSupply = maxSupply
        self.circulatingSupply = circulatingSupply
        self.lastUpdated = lastUpdated
        self.sparkline7D = sparkline7D
    }
}

// MARK: - Sparkline7D
class Sparkline7D: Codable {
    var price: [Double]?

    init(price: [Double]?) {
        self.price = price
    }
}

// MARK: - PublicInterestStats
//class PublicInterestStats: Codable {
//    var alexaRank: Int?
//    var bingMatches: JSONNull?
//
//    enum CodingKeys: String, CodingKey {
//        case alexaRank = "alexa_rank"
//        case bingMatches = "bing_matches"
//    }
//
//    init(alexaRank: Int?, bingMatches: JSONNull?) {
//        self.alexaRank = alexaRank
//        self.bingMatches = bingMatches
//    }
//}
