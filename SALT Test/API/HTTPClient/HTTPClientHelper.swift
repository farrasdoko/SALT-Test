//
//  HTTPClientHelper.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import Foundation

class HTTPClientHelper: HTTPClient {
    func get(url: URL, completion: @escaping (HTTPClientResult<UserResponse>) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                if let errorMsg = error?.localizedDescription {
                    completion(.failed(msg: errorMsg))
                } else {
                    completion(.otherError)
                }
                
                return
            }
            
            guard let data = data, let response = try? JSONDecoder().decode(Root.self, from: data) else {
                completion(.otherError)
                return
            }
            
            completion(.success(response.data))
        }.resume()
    }
    
    func post(request: NSMutableURLRequest, completion: @escaping (HTTPClientResult<String>)->Void) {
        URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
            guard error == nil else {
                if let errorMsg = error?.localizedDescription {
                    completion(.failed(msg: errorMsg))
                } else {
                    completion(.otherError)
                }
                
                return
            }
            
            guard let data = data, let loginResponse = try? JSONDecoder().decode(LoginResponse.self, from: data) else {
                completion(.otherError)
                return
            }
            
            if let error = loginResponse.error {
                completion(.failed(msg: error))
                return
            }
            
            guard let token = loginResponse.token else { completion(.otherError);return }
            completion(.success(token))
        }.resume()
    }
}

private struct LoginResponse: Decodable {
    let token: String?
    let error: String?
}

public struct Root: Decodable {
    let data: UserResponse
}

public struct UserResponse: Decodable, Equatable {
    let email: String
    let firstName: String
    let lastName: String
    let avatar: String
    
    public init() {
        self.email = ""
        self.firstName = ""
        self.lastName = ""
        self.avatar = ""
    }
    
    enum CodingKeys: String, CodingKey {
        case email
        case firstName = "first_name"
        case lastName = "last_name"
        case avatar
    }
}
