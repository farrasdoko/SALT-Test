//
//  UserDetailVM.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import Foundation

public class UserDetailVM {
    private let userDetailHelper: UserDetailHelper
    
    public init(helper: UserDetailHelper) {
        self.userDetailHelper = helper
    }
    
    public func getUser(completion: @escaping (HTTPClientResult<UserResponse>) -> Void) {
        userDetailHelper.getData { result in
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }
}
