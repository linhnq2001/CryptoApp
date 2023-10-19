//
//  User.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/10/2023.
//

import Foundation

enum LoginType: String, Codable{
    case email = "email"
    case google = "google"
    case anonymous = "anonymous"
}

class User: NSObject, Codable {
    var id: String
    var username: String
    var email: String?
    private var password: String?
    var loginType: LoginType
    
    init(id: String, username: String, email: String?, password: String?, loginType: LoginType) {
        self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.loginType = loginType
    }
    
    func convertToDictionary() -> [String: String] {
        return ["id":id,"username":username,"email":email ?? "","password":password ?? "", "loginType": loginType.rawValue]
    }

}
