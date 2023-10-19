//
//  SettingViewModel.swift
//  CryptoApp
//
//  Created by Linh Nguyễn on 19/10/2023.
//

import Foundation
import RxSwift
import RxRelay

public class SettingViewModel: NSObject {
    
    private let disposeBag = DisposeBag()
    
    public struct Input {
        let trigger: PublishSubject<Void>
    }
    
    public struct Output {
        let showLoading: PublishRelay<Bool>
        let isLogin: PublishRelay<(Bool,User?)>
    }
    
    public func transform(_ input: SettingViewModel.Input) -> SettingViewModel.Output {
        let showLoading = PublishRelay<Bool>()
        let isLogin = PublishRelay<(Bool,User?)>()
        
        let output = SettingViewModel.Output(showLoading: showLoading, isLogin: isLogin)
        
        handleInitData(input,output)
        return output
    }

    private func handleInitData(_ input: SettingViewModel.Input, _ output: SettingViewModel.Output){
        input.trigger.flatMap { _ -> Observable<User?> in
            return FirebaseAuthHelper.shared.isLogin()
        }.subscribe(onNext: { user in
            output.isLogin.accept((user != nil, user))
        }).disposed(by: disposeBag)
    }

}
