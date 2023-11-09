//
//  FirestoreHelper.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/10/2023.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import RxSwift

final public class FirestoreHelper: NSObject{
    public static let shared = FirestoreHelper()
    
    private let db = Firestore.firestore()
    private let disposeBag = DisposeBag()
    
    func addUser(_ user: User) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings Wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            self.db.collection("users").document(user.id).setData(user.convertToDictionary()) { error in
                observable.onNext((error == nil,error.debugDescription))
            }
            return Disposables.create()
        }
    }
    
    func deleteUser(_ user: User) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings Wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            self.db.collection("users").document(user.id).delete { error in
                observable.onNext((error == nil,error.debugDescription))
            }
            return Disposables.create()
        }
    }
    
    func updateUser(_ user: User) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings Wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            self.db.collection("users").document(user.id).updateData(user.convertToDictionary()) { error in
                observable.onNext((error == nil,error.debugDescription))
            }
            return Disposables.create()
        }
    }
    
    func getUser(_ uid: String) -> Observable<User?>{
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext(nil)
                observable.onCompleted()
                return Disposables.create()
            }
            self.db.collection("users").document(uid).getDocument(as: User.self) { result in
                switch result {
                case .success(let user):
                    observable.onNext(user)
                    observable.onCompleted()
                case .failure(_):
                    observable.onNext(nil)
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }
    
    func addOrRemoveWatchList(_ coin: CoinInMarketResponse) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            if FirebaseAuthHelper.shared.isLogin() {
                FirebaseAuthHelper.shared.getCurrentUser().subscribe(onNext: { user in
                    guard let user = user else {
                        return
                    }
                    let watchList = user.watchList
                    if let index = watchList.firstIndex(where: {$0 == coin.id}) {
                        user.watchList.remove(at: index)
                        self.updateUser(user).subscribe(onNext: { (result, error) in
                            observable.onNext((result, result ? "Success Remove token from watch list" : "Somethings wrong"))
                        }).disposed(by: self.disposeBag)
                    } else {
                        user.watchList.append(coin.id)
                        self.updateUser(user).subscribe(onNext: { (result, error) in
                            observable.onNext((result, result ? "Success add token to watch list" : "Somethings wrong"))
                        }).disposed(by: self.disposeBag)
                    }
                }).disposed(by: self.disposeBag)
            } else {
                
            }
            return Disposables.create()
        }
    }
    
    func addTokenToRecentSearch(_ id: String) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            let uid = FirebaseAuthHelper.shared.getUID()
            let docRef = self.db.collection("data").document(uid)
            self.getRecentSearchList().subscribe { result, recentSearch in
                var newRecentSearch = recentSearch
                if !result {
                    observable.onNext((false,"Somethings wrong"))
                    observable.onCompleted()
                } else {
                    if !recentSearch.contains(id) {
                        newRecentSearch.append(id)
                        docRef.updateData(["recentSearch": newRecentSearch]) { error in
                            if let error = error {
                                observable.onNext((false,"Somethings wrong"))
                                observable.onCompleted()
                            } else {
                                observable.onNext((true,"Success"))
                                observable.onCompleted()
                            }
                        }
                    }
                }
            }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }

    func getRecentSearchList() -> Observable<(Bool,[String])> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,[]))
                observable.onCompleted()
                return Disposables.create()
            }
            let uid = FirebaseAuthHelper.shared.getUID()
            if !uid.isEmpty {
                self.db.collection("data").document(uid).getDocument(as: UserDataFb.self) { result in
                    switch result {
                    case .success(let data):
                        observable.onNext((true,data.recentSearch))
                        observable.onCompleted()
                        break
                    case .failure(_):
                        observable.onNext((false,[]))
                        observable.onCompleted()
                        break
                    }
                }
            } else {
                observable.onNext((false,[]))
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }

}
