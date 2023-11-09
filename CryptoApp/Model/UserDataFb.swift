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
    init(watchList: [String], recentSearch: [String]) {
        self.watchList = watchList
        self.recentSearch = recentSearch
    }
    func convertToDictionary() -> [String: Any] {
        return ["watchList": watchList,
                "recentSearch":recentSearch]
    }
}
