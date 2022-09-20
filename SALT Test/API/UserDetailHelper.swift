//
//  UserDetailHelper.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import Foundation

public class UserDetailHelper {
    private let client: HTTPClient
    
    private let publicAPI = "https://reqres.in"
    // P.s I don't know how to use token. Instead, I hardcode it to user 2
    private let path = "/api/users/2"
    
    func getData(completion: @escaping (HTTPClientResult<UserResponse>) -> Void) {
        let url = URL(string: publicAPI+path)!
        client.get(url: url, completion: completion)
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
}
