//
//  LoginViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 04/10/2023.
//

import Foundation
import RxSwift
import RxCocoa

class LoginViewModel: NSObject{
    
    private var disposeBag = DisposeBag()
    
    public struct Input {
        let loginAction: Driver<Void>
        let resetPasswordAction: Driver<Void>
        let loginWithGoogleAction: Driver<Void>
        let email: Driver<String>
        let password: Driver<String>
    }
    
    public struct Output {
        let validationEmail: PublishRelay<(Bool,String)>
        let validationPassword: PublishRelay<(Bool,String)>
        let showLoading: PublishSubject<Bool>
        let loginResult: PublishRelay<(Bool,String)>
    }
    
    public func tranform(_ input: LoginViewModel.Input) -> LoginViewModel.Output {
        let validationEmail = PublishRelay<(Bool,String)>()
        let validationPassword = PublishRelay<(Bool,String)>()
        let showLoading = PublishSubject<Bool>()
        let loginResult = PublishRelay<(Bool,String)>()
        
        let output = Output(validationEmail: validationEmail, validationPassword: validationPassword, showLoading: showLoading, loginResult: loginResult)
        
        handleLoginAction(input,output)
        return output
    }
    
    private func handleLoginAction(_ input: LoginViewModel.Input,_ output: LoginViewModel.Output) {
        let loginInfo = Observable.combineLatest(input.email.asObservable(), input.password.asObservable())
        input.loginAction.asObservable().withLatestFrom(loginInfo).flatMap { (email,password) -> Observable<(Bool,String)> in
            output.showLoading.onNext(true)
            return FirebaseAuthHelper.shared.loginWithEmail(email, password)
        }.subscribe(onNext: { (result, error) in
            output.showLoading.onNext(false)
            output.loginResult.accept((result, error))
        }).disposed(by: disposeBag)
    }
    
}
