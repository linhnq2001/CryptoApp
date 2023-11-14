//
//  SimplePriceResponse.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 29/10/2023.
//

import Foundation
import RealmSwift

typealias SimplePriceResponse = [String: SimplePrice]

class SimplePrice: Codable {
    var usd, usdMarketCap, usd24HVol, usd24HChange: Double?
    
    enum CodingKeys: String, CodingKey {
        case usd
        case usdMarketCap = "usd_market_cap"
        case usd24HVol = "usd_24h_vol"
        case usd24HChange = "usd_24h_change"
    }
    
    init(usd: Double?, usdMarketCap: Double?, usd24HVol: Double?, usd24HChange: Double?) {
        self.usd = usd
        self.usdMarketCap = usdMarketCap
        self.usd24HVol = usd24HVol
        self.usd24HChange = usd24HChange
    }
}

class LocalPriceData: Object {
    var id: String
    var data: SimplePrice
    init(id: String, data: SimplePrice) {
        self.id = id
        self.data = data
    }
}
