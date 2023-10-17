//
//  RegisterViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import Foundation
import RxSwift
import RxRelay
import RxCocoa

public class RegisterViewModel: NSObject {
    
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let username: Driver<String>
        let email: Driver<String>
        let password: Driver<String>
        let registerAction: Driver<Void>
    }
    
    public struct Output {
        let validationUsername: PublishRelay<(Bool,String)>
        let validationEmail: PublishRelay<(Bool,String)>
        let validationPassword: PublishRelay<(Bool,String)>
        let showLoading: PublishSubject<Bool>
        let registerResult: PublishRelay<(Bool,String)>
    }
    
    public func tranform(_ input: RegisterViewModel.Input) -> RegisterViewModel.Output {
        let validationUsername = PublishRelay<(Bool,String)>()
        let validationEmail = PublishRelay<(Bool,String)>()
        let validationPassword = PublishRelay<(Bool,String)>()
        let showLoading = PublishSubject<Bool>()
        let registerResult = PublishRelay<(Bool,String)>()
        
        let output = Output(validationUsername: validationUsername, validationEmail: validationEmail, validationPassword: validationPassword, showLoading: showLoading, registerResult: registerResult)
        handleRegisterAction(input,output)
        return output
    }
    
    private func  handleRegisterAction(_ input: RegisterViewModel.Input,_ output: RegisterViewModel.Output) {
        let registerInfo = Observable.combineLatest(input.username.asObservable(), input.email.asObservable(), input.password.asObservable())
        input.registerAction.asObservable().withLatestFrom(registerInfo).flatMap { (username, email ,password) -> Observable<(Bool,String)> in
            output.showLoading.onNext(true)
            return FirebaseAuthHelper.shared.createAccountWithEmail(username, email, password)
        }.subscribe(onNext: { (result,error) in
            output.showLoading.onNext(false)
            output.registerResult.accept((result,error))
        }).disposed(by: disposeBag)
    }
    
}
