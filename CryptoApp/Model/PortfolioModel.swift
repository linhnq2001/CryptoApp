//
//  PortfolioModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 13/11/2023.
//

import Foundation
import RealmSwift

final public class Portfolio: NSObject,Codable,SearchDataSource,PortfolioDataSource {
    var name: String
    var color: String
    var createdAt: Int
    var listToken: [TokenInPortfolio] = []
    
    init(name: String, color: String, createdAt: Int, listToken: [TokenInPortfolio]) {
        self.name = name
        self.color = color
        self.createdAt = createdAt
        self.listToken = listToken
    }

    init(name: String, color: String, createdAt: Int) {
        self.name = name
        self.color = color
        self.createdAt = createdAt
    }
    
    func getValue() -> Double {
        var sum = 0.0
        listToken.forEach { tokenInPortfolio in
            let realm = try! Realm()
            let currentPrice = realm.objects(LocalPriceData.self).first(where: {$0.id == tokenInPortfolio.id})?.data?.usd ?? 0
            tokenInPortfolio.tradesHistory.forEach { tradeHistory in
                switch tradeHistory.type {
                case .buy:
                    sum += tradeHistory.amount * currentPrice
                case .sell:
                    sum -= tradeHistory.amount * currentPrice
                }
            }
        }
        return sum
    }

    func getValueChange() -> Double {
        
        return 0
    }

    func getPercentChange() -> Double {
        
        return 0
    }

    func addTransaction(tokeninPortfolio: TokenInPortfolio) {
        if let index = listToken.firstIndex(where: {$0.id == tokeninPortfolio.id}) {
            listToken[index].tradesHistory.append(contentsOf: tokeninPortfolio.tradesHistory)
        } else {
            listToken.append(tokeninPortfolio)
        }
    }
}

final public class TokenInPortfolio: NSObject,Codable,SearchDataSource {
    var id: String
    var name: String
    var symbol: String
    var urlImage: String
    var tradesHistory: [TradeHistory]
    
    init(id: String, name: String, symbol: String, urlImage: String, tradesHistory: [TradeHistory]) {
        self.id = id
        self.name = name
        self.symbol = symbol
        self.urlImage = urlImage
        self.tradesHistory = tradesHistory
    }
    
    func getBalance() -> Double {
        var sum = 0.0
        tradesHistory.forEach { tradeHistory in
            if tradeHistory.type == .buy {
                sum += tradeHistory.amount
            } else if tradeHistory.type == .sell {
                sum -= tradeHistory.amount
            }
        }
        return sum
    }
    
    func getProfit() -> Double {
        return 0
    }
}

final public class TradeHistory: NSObject,Codable {
    var type: TradeType
    var price: Double
    var amount: Double
    var createAt: Int
    
    init(type: TradeType, price: Double, amount: Double, createAt: Int) {
        self.type = type
        self.price = price
        self.amount = amount
        self.createAt = createAt
    }
}

public enum TradeType: String,Codable {
    case buy
    case sell
}

extension Encodable {
    var toDictionnary: [String : Any]? {
        guard let data =  try? JSONEncoder().encode(self) else {
            return nil
        }
        return try? JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
    }
}
