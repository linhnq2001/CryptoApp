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
            let data = UserDataFb(watchList: [], recentSearch: [], portfolio: [])
            let userReference = self.db.collection("users").document(user.id)
            let dataReference = self.db.collection("data").document(user.id)
            self.db.runTransaction { transaction, error in
                transaction.setData(user.convertToDictionary(), forDocument: userReference)
                transaction.setData(data.convertToDictionary(), forDocument: dataReference)
                return nil
            } completion: { object, error in
                observable.onNext((error == nil,error.debugDescription))
                if let error = error {
                    print("Transaction failed: \(error)")
                } else {
                    print("Transaction successfully committed!")
                }
            }
            return Disposables.create()
        }
    }
    
    func addDataForNewUser(_ user: User) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings Wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            let data = UserDataFb(watchList: [], recentSearch: [], portfolio: [])
            self.db.collection("data").document(user.id).setData(data.convertToDictionary()) { error in
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
                    case .failure(let error):
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

    func clearRecentSearchList() -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Something wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            let uid = FirebaseAuthHelper.shared.getUID()
            if !uid.isEmpty {
                self.db.collection("data").document(uid).updateData(["recentSearch": []]) { error in
                    observable.onNext((error == nil, error == nil ? "" : "Something wrong"))
                    observable.onCompleted()
                }
            } else {
                observable.onNext((false,"Something wrong"))
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }
}
//MARK: Portfolio
extension FirestoreHelper {
    func getAllPortfolio() -> Observable<(Bool,[Portfolio])> {
        return Observable.create {[weak self] observable in
            guard let self = self else {
                observable.onNext((false, []))
                observable.onCompleted()
                return Disposables.create()
            }
            let uid = FirebaseAuthHelper.shared.getUID()
            if !uid.isEmpty {
                self.db.collection("data").document(uid).getDocument(as: UserDataFb.self) { result in
                    switch result {
                    case .success(let data):
                        observable.onNext((true,data.portfolio))
                        observable.onCompleted()
                    case .failure(let failure):
                        print("get Portfolio fail \(failure.localizedDescription)")
                        observable.onNext((false,[]))
                        observable.onCompleted()
                    }
                }
            } else {
                observable.onNext((false,[]))
                observable.onCompleted()
            }
            return Disposables.create()
        }
    }

    func addNewPortfolio(_ portfolio: Portfolio) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
                observable.onNext((false,"Somethings wrong"))
                observable.onCompleted()
                return Disposables.create()
            }
            let uid = FirebaseAuthHelper.shared.getUID()
            let docRef = self.db.collection("data").document(uid)
            self.getAllPortfolio().subscribe { result, listPortfolio in
                var newPortfolio = listPortfolio
                if !result {
                    observable.onNext((false,"Somethings wrong"))
                    observable.onCompleted()
                } else {
                    if !newPortfolio.contains(where: {$0.name == portfolio.name}) {
                        docRef.updateData(["portfolio": FieldValue.arrayUnion([portfolio.toDictionnary])]) { error in
                            if error != nil {
                                observable.onNext((false,"Somethings wrong"))
                                observable.onCompleted()
                            } else {
                                observable.onNext((true,"Success"))
                                observable.onCompleted()
                            }
                        }
                    } else {
                        observable.onNext((false,"Wrong Name"))
                        observable.onCompleted()
                    }
                }
            }.disposed(by: disposeBag)
            return Disposables.create()
        }
    }

    func removePortfolio(_ portfolio: Portfolio) -> Observable<(Bool,String)> {
        return .create { observable in
            let uid = FirebaseAuthHelper.shared.getUID()
            self.db.collection("data").document(uid).getDocument(as: UserDataFb.self) { result in
                switch result {
                case .success(let success):
                    let data = success
                    data.portfolio.removeAll(where: {$0.name == portfolio.name})
                    self.db.collection("data").document(uid).updateData(["portfolio": data.portfolio.map({$0.toDictionnary})]) { error in
                        observable.onNext((error == nil,error != nil ? "Something wrong" : ""))
                        observable.onCompleted()
                    }
                case .failure(_):
                    observable.onNext((false,"Something wrong"))
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func renamePortfolio(portfolio: Portfolio, newName: String) -> Observable<(Bool,String)> {
        return .create { observable in
            let uid = FirebaseAuthHelper.shared.getUID()
            self.db.collection("data").document(uid).getDocument(as: UserDataFb.self) { result in
                switch result {
                case .success(let success):
                    var data = success
                    if let index = data.portfolio.firstIndex(where: {$0.name == portfolio.name}) {
                        data.portfolio[index].name = newName
                        self.db.collection("data").document(uid).updateData(["portfolio": data.portfolio.map({$0.toDictionnary})]) { error in
                            observable.onNext((error == nil,error != nil ? "Something wrong" : ""))
                            observable.onCompleted()
                        }
                    } else {
                        observable.onNext((false,"Something wrong"))
                        observable.onCompleted()
                    }
                case .failure(_):
                    observable.onNext((false,"Something wrong"))
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func duplicatePortfolio(portfolio: Portfolio, newName: String) -> Observable<(Bool,String)> {
        return .create { observable in
            let uid = FirebaseAuthHelper.shared.getUID()
            self.db.collection("data").document(uid).getDocument(as: UserDataFb.self) { result in
                switch result {
                case .success(let success):
                    var data = success
                    if let newPortfolio = data.portfolio.first(where: {$0.name == portfolio.name}) {
                        if newName == newPortfolio.name {
                            observable.onNext((false,"InValid Name"))
                            observable.onCompleted()
                        }
                        newPortfolio.name = newName
                        data.portfolio.append(newPortfolio)
                        self.db.collection("data").document(uid).updateData(["portfolio": data.portfolio.map({$0.toDictionnary})]) { error in
                            observable.onNext((error == nil,error != nil ? "Something wrong" : ""))
                            observable.onCompleted()
                        }
                    } else {
                        observable.onNext((false,"Something wrong"))
                        observable.onCompleted()
                    }
                case .failure(_):
                    observable.onNext((false,"Something wrong"))
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

    func addTransaction(_ transaction: TokenInPortfolio, namePortfolio: String) -> Observable<(Bool,String)> {
        return Observable.create { observable in
            let uid = FirebaseAuthHelper.shared.getUID()
            self.db.collection("data").document(uid).getDocument(as: UserDataFb.self) { result in
                switch result {
                case .success(let success):
                    var data = success
                    if let index = data.portfolio.firstIndex(where: {$0.name == namePortfolio}) {
                        if let indexToken = data.portfolio[index].listToken.firstIndex(where: {$0.id == transaction.id}) {
                            data.portfolio[index].listToken[indexToken].tradesHistory.append(contentsOf: transaction.tradesHistory)
                        } else {
                            data.portfolio[index].listToken.append(transaction)
                        }
                        self.db.collection("data").document(uid).updateData(["portfolio": data.portfolio.map({$0.toDictionnary})]) { error in
                            observable.onNext((error == nil,error != nil ? "Something wrong" : ""))
                            observable.onCompleted()
                        }
                    } else {
                        observable.onNext((false,"Something wrong"))
                        observable.onCompleted()
                    }
                case .failure(_):
                    observable.onNext((false,"Something wrong"))
                    observable.onCompleted()
                }
            }
            return Disposables.create()
        }
    }

}
