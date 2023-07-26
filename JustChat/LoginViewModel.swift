//
//  LoginViewModel.swift
//  JustChat
//
//  Created by Александра Кострова on 21.06.2023.
//

import Foundation
import Combine

enum ViewStates {
    case loading
    case success
    case failed
    case none
}

class LoginViewModel {

    @Published var email = ""
    @Published var password = ""
    @Published var state: ViewStates = .none
    
    var isValidEmailPublisher: AnyPublisher <Bool, Never> {
        $email
            .map { $0.isEmail() }
            .eraseToAnyPublisher()
    }
    
    var isValidPasswordPasswordPublisher: AnyPublisher <Bool, Never> {
        $password
            .map { !$0.isEmpty}
            .eraseToAnyPublisher()
    }
    
    var isLoginEnable: AnyPublisher <Bool, Never> {
        Publishers.CombineLatest(isValidEmailPublisher, isValidPasswordPasswordPublisher)
            .map { $0 && $1 }
            .eraseToAnyPublisher()
    }
    
    func submitLogin() {
        state = .loading
        
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2)) { [weak self] in guard let self = self else { return }
            
            if self.isCorrectLogin() {
                self.state = .success
            } else {
                self.state = .failed
            }
        }
    }
    
    func isCorrectLogin() -> Bool {
        return email == "user@mail.com" && password == "12345"
    }
}
