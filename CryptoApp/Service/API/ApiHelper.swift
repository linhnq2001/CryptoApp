//
//  ApiHelper.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 16/10/2023.
//

import Foundation
import RxSwift
import RxCocoa
import Alamofire

public enum APIError: Error, LocalizedError {
    case apiFailed(statusCode: Int?, message: String)
    case timeout(message: String?)
    case other(message: String)
}

public struct ApiHelper<T:Decodable> {
    
    public static func get(baseOtherUrl: String = "",
                           url: ApiEndPoint,
                           otherHeaders: [String : String]? = nil,
                           params: [String: Any]) -> Observable<T> {
        return Observable.create { observer in
            AF.request(baseOtherUrl + url.rawValue,method: .get,parameters: params).responseDecodable(of:T.self) { response in
                switch response.result {
                case .success(let data):
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []), let decodedData = try? JSONDecoder().decode(T.self,from: jsonData) {
                        observer.onNext(decodedData)
                        observer.onCompleted()
                    } else {
                        observer.onError(APIError.other(message: "Can't cover JSON"))
                    }
                case .failure(let error as Error): 
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    public static func post(baseOtherUrl: String = "",
                           url: ApiEndPoint,
                           params: [String: Any]) -> Observable<T> {
        return Observable.create { observer in
            AF.request(baseOtherUrl + url.rawValue,method: .post,parameters: params).responseDecodable(of:T.self) { response in
                switch response.result {
                case .success(let data):
                    if let jsonData = try? JSONSerialization.data(withJSONObject: data, options: []), let decodedData = try? JSONDecoder().decode(T.self,from: jsonData) {
                        observer.onNext(decodedData)
                        observer.onCompleted()
                    } else {
                        observer.onError(APIError.other(message: "Can't cover JSON"))
                    }
                case .failure(let error as Error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
}

public enum ApiEndPoint: String{
    case markets = "coins/markets"
}
