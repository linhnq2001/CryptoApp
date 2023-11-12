//
//  UserDataFb.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 08/11/2023.
//

import Foundation

final public class UserDataFb: NSObject, Codable{
    var watchList: [String] = []
    var recentSearch: [String] = []
    var portfolio: [Portfolio] = []

    init(watchList: [String], recentSearch: [String],portfolio: [Portfolio] ) {
        self.watchList = watchList
        self.recentSearch = recentSearch
        self.portfolio = portfolio
    }
    func convertToDictionary() -> [String: Any] {
        return ["watchList": watchList,
                "recentSearch":recentSearch,
                "portfolio":portfolio]
    }
}
