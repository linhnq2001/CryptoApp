//
//  FirebaseAuthHelper.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/10/2023.
//

import Foundation
import FirebaseAuth
import RxSwift

final class FirebaseAuthHelper: NSObject {
    public static let shared = FirebaseAuthHelper()
    
    func loginWithEmail(_ email: String, _ password: String) -> Observable<(Bool,String)>{
        return Observable.create { observable in
            Auth.auth().signIn(withEmail: email, password: password) { result, error in
                guard let error = error else {
                    observable.onNext((true,""))
                    return
                }
                observable.onNext((false,error.localizedDescription))
            }
            return Disposables.create()
        }
    }
    
    func createAccountWithEmail(_ email: String, _ password: String) -> Observable<(Bool,String)>{
        return Observable.create { observable in
            Auth.auth().createUser(withEmail: email, password: password) { result, error in
                guard let error = error else {
                    observable.onNext((true,""))
                    return
                }
                observable.onNext((false,error.localizedDescription))
            }
            return Disposables.create()
        }
    }
    
    func logout() -> Observable<(Bool,String)> {
        do {
           try Auth.auth().signOut()
            return Observable.just((true,""))
        } catch {
            return Observable.just((false,error.localizedDescription))
        }
    }
    
}
