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
    private let disposeBag = DisposeBag()
    
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
    
    func createAccountWithEmail(_ username: String,_ email: String, _ password: String) -> Observable<(Bool,String)>{
        return Observable.create { observable in
            Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
                guard let self = self else {
                    observable.onNext((false,"Something wrong"))
                    return
                }
                if let error = error {
                    observable.onNext((false,error.localizedDescription))
                } else {
                    let user = User(id: result!.user.uid, username: username, email: email, password: password, loginType: .email)
                    FirestoreHelper.shared.addUser(user).subscribe(onNext: {(result,error) in
                        observable.onNext((result,error))
                    }).disposed(by: self.disposeBag)
                }
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
    
    func getCurrentUser() -> Observable<User?> {
        if let userId = Auth.auth().currentUser?.uid {
            return FirestoreHelper.shared.getUser(userId)
        } else {
            return Observable.just(nil)
        }
    }
    
    func isLogin() -> Bool {
        print("linhdebug \(Auth.auth().currentUser)")
        return Auth.auth().currentUser != nil
    }
    
}
