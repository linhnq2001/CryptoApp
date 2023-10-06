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
        let loginAction: PublishSubject<Void>
        let resetPasswordAction: PublishSubject<Void>
        let loginWithGoogleAction: PublishSubject<Void>
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
         input.loginAction.withLatestFrom(input.email).flatMap { email -> Observable<(Bool,String)> in
            return Observable.create { observable in
                if email.isEmpty {
                    observable.onNext((false,"Email is empty"))
                }
                if isValidEmail(email){
                    observable.onNext((true,""))
                } else {
                    observable.onNext((false,"Email isn't valid"))
                }
                return Disposables.create()
            }
        }.subscribe(onNext: { (result, error) in
            output.validationEmail.accept((result, error))
        }).disposed(by: disposeBag)
    }
    
}
