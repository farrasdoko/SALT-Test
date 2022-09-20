//
//  LoginVM.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import Foundation

public class LoginVM {
    private let loginHelper: LoginHelper

    public init(loginHelper: LoginHelper) {
        self.loginHelper = loginHelper
    }
    
    public func login(email: String?, password: String?, completion: @escaping (HTTPClientResult<String>) -> Void) {
        loginHelper.login(email: email, password: password) { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
