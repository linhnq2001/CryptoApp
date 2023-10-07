//
//  FirestoreHelper.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 07/10/2023.
//

import Foundation
import FirebaseFirestore
import RxSwift

final public class FirestoreHelper: NSObject{
    public static let shared = FirestoreHelper()
    
    private let db = Firestore.firestore()
    
    func addUser(_ user: User) -> Observable<(Bool,String)> {
        return Observable.create { [weak self] observable in
            guard let self = self else {
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
                return Disposables.create()
            }
            self.db.collection("users").document(user.id).updateData(user.convertToDictionary()) { error in
                observable.onNext((error == nil,error.debugDescription))
            }
            return Disposables.create()
        }
    }
    
}
