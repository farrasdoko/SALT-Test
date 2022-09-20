//
//  HTTPClient.swift
//  SALT Test
//
//  Created by Farras Doko on 20/09/22.
//

import Foundation

public protocol HTTPClient {
    func post(request: NSMutableURLRequest, completion: @escaping (HTTPClientResult<String>)->Void)
    func get(url: URL, completion: @escaping (HTTPClientResult<UserResponse>)->Void)
}

public enum HTTPClientResult<T: Equatable>: Equatable {
    public static func == (lhs: HTTPClientResult<T>, rhs: HTTPClientResult<T>) -> Bool {
        switch (lhs, rhs) {
        case (.otherError, .otherError):
            return true
        case (.success(let asd), .success(let dsa)):
            return asd == dsa
        case (.failed(msg: let msg), .failed(msg: let msg2)):
            return msg == msg2
        default:
            return false
        }
    }
    
    case success(T)
    case failed(msg: String)
    case otherError
}
