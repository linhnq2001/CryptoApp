//
//  Date+Extension.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 17/11/2023.
//

import Foundation

extension Date {

    func stripTime() -> Date {
        let components = Calendar.current.dateComponents([.year, .month, .day], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

    func stripDay() -> Date {
        let components = Calendar.current.dateComponents([.hour, .minute], from: self)
        let date = Calendar.current.date(from: components)
        return date!
    }

}
