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

public struct ApiHelper<T: Decodable> {
    
    public static func get(baseOtherUrl: String,
                           url: ApiEndPoint,
                           otherHeaders: [String: String]? = nil,
                           params: [String: Any]) -> Observable<T> {
        return Observable.create { observer in
            var pramsTwo = params
            pramsTwo["x_cg_demo_api_key"] = "CG-m1fosyDHP7Pyn6yb65zxJdHA"
            AF.request(baseOtherUrl + url.endpoint, method: .get, parameters: pramsTwo).responseDecodable(of: T.self) { response in
                print("===== Request GET URL: \(response.response?.url?.absoluteString ?? "")")
                print(response.data?.prettyJson ?? "")
                print("===========================")
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error as Error): 
                    print("== API FAILURE URL: \(response.response?.url?.absoluteString ?? "") ")
                    print("== ERROR: \(error)")
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    public static func post(baseOtherUrl: String,
                            url: ApiEndPoint,
                            params: [String: Any]) -> Observable<T> {
        return Observable.create { observer in
            AF.request(baseOtherUrl + url.endpoint, method: .post, parameters: params).responseDecodable(of: T.self) { response in
                print("===== Request POST URL: \(response.response?.url?.absoluteString ?? "")")
                print(response.data?.prettyJson ?? "")
                print("===========================")
                switch response.result {
                case .success(let data):
                    observer.onNext(data)
                    observer.onCompleted()
                case .failure(let error as Error):
                    observer.onError(error)
                }
            }
            return Disposables.create()
        }
    }
    
    private static func printRequestLog(dataResponse: DataResponse<Data, Error>, params: [String: Any]) {
        let requestURL = dataResponse.request?.url?.absoluteString ?? ""
        
        print("\n===> Request GET URL : \(requestURL)")
        print("Request params = ", params)
        print("Request Header = ", dataResponse.request?.allHTTPHeaderFields ?? [:])
        print("Response Header x-request-id", dataResponse.response?.allHeaderFields["x-request-id"] ?? "")
        print("Response statusCode", dataResponse.response?.statusCode ?? 0)
    }
    
}

public enum ApiEndPoint {
    case markets
    case getAllCoin
    case getCoinDetail(id: String)
    case simplePrice
    case getExchangeInfo(id: String)
    case search
    case searchTrending
    
    public var endpoint: String {
        switch self {
        case .markets:
            return "coins/markets"
        case .getCoinDetail(let id):
            return  "coins/\(id)"
        case .getAllCoin:
            return "coins/list"
        case .simplePrice:
            return "simple/price"
        case .getExchangeInfo(let id):
            return "exchanges/\(id)"
        case .search:
            return "search"
        case .searchTrending:
            return "search/trending"
        }
    }
}

extension Data {
    var prettyJson: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = String(data: data, encoding: .utf8) else { return nil }

        return prettyPrintedString
    }
}
