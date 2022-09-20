//
//  LoginTest.swift
//  SALT TestTests
//
//  Created by Farras Doko on 20/09/22.
//

import XCTest
import SALT_Test

class LoginTest: XCTestCase {
    
    /// To make sure when it failed, it completee as failed.
    func testLoginFailed() {
        createSUT(toCompleteWith: .otherError)
    }
    
    /// To make sure when it succeed, it complete as succeess.
    func testLoginSuccess() {
        createSUT(toCompleteWith: .success("Congrats"))
    }
    
    /// Reusable function to make sure the total completion is as same as total request.
    private func createSUT(toCompleteWith expected: HTTPClientResult<String>, file: StaticString = #filePath, line: UInt = #line) {
        let client = HTTPClientSpy()
        let helper = LoginHelper(client: client)
        let vm = LoginVM(loginHelper: helper)
        
        var capturedResults = [HTTPClientResult<String>]()
        
        let expectation = expectation(description: "Timed Out.")
        vm.login(email: "email", password: "password") { result in
            capturedResults.append(result)
            expectation.fulfill()
        }
        client.complete(with: expected)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(capturedResults, [expected], file: file, line: line)
    }
    
}

private class HTTPClientSpy: HTTPClient {
    func get(url: URL, completion: @escaping (HTTPClientResult<UserResponse>) -> Void) {
        // not used in this test
    }
    
    private var messages = [(HTTPClientResult<String>)->Void]()
    
    func post(request: NSMutableURLRequest, completion: @escaping (HTTPClientResult<String>)->Void) {
        self.messages.append(completion)
    }
    func complete(with result: HTTPClientResult<String>, at index: Int = 0) {
        messages[index](result)
    }
}
