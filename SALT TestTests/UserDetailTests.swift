//
//  UserDetailTests.swift
//  SALT TestTests
//
//  Created by Farras Doko on 20/09/22.
//

import XCTest
import SALT_Test

class UserDetailTests: XCTestCase {
    
    func testGetDataFailed() {
        createSUT(toCompleteWith: .otherError)
    }
    
    func testGetDataSuccess() {
        let responseDummy = UserResponse()
        createSUT(toCompleteWith: .success(responseDummy))
    }
    
    /// Reusable function to make sure the total completion is as same as total request.
    private func createSUT(toCompleteWith expected: HTTPClientResult<UserResponse>, file: StaticString = #filePath, line: UInt = #line) {
        let client = HTTPClientSpy()
        let helper = UserDetailHelper(client: client)
        let vm = UserDetailVM(helper: helper)
        
        var capturedResults = [HTTPClientResult<UserResponse>]()
        
        let expectation = expectation(description: "Timed Out.")
        vm.getUser() { result in
            capturedResults.append(result)
            expectation.fulfill()
        }
        client.complete(with: expected)
        
        wait(for: [expectation], timeout: 2)
        XCTAssertEqual(capturedResults, [expected], file: file, line: line)
    }
    
}

private class HTTPClientSpy: HTTPClient {
    private var messages = [(HTTPClientResult<UserResponse>)->Void]()
    
    func post(request: NSMutableURLRequest, completion: @escaping (HTTPClientResult<String>)->Void) {
        // not used in this test
    }
    
    func get(url: URL, completion: @escaping (HTTPClientResult<UserResponse>) -> Void) {
        self.messages.append(completion)
    }
    
    func complete(with result: HTTPClientResult<UserResponse>, at index: Int = 0) {
        messages[index](result)
    }
}
