//
//  Roi.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 29/10/2023.
//

import Foundation

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
