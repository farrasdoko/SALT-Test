//
//  LoginHelper.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import Foundation

public class LoginHelper {
    private let client: HTTPClient
    
    private let publicAPI = "https://reqres.in"
    private let loginPath = "/api/login"
    
    func login(email: String?, password: String?, completion: @escaping (HTTPClientResult<String>) -> Void) {
        let loginURL = URL(string: publicAPI+loginPath)!
        let request = NSMutableURLRequest(url: loginURL)
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        var json: [String:String] = [:]
        if let email = email {
            json["email"] = email
        }
        if let password = password {
            json["password"] = password
        }
        
        let data = try! JSONSerialization.data(withJSONObject: json)
        request.httpBody = data
        
        client.post(request: request, completion: completion)
    }
    
    public init(client: HTTPClient) {
        self.client = client
    }
}
