//
//  HTTPClientTests.swift
//  SALT TestTests
//
//  Created by Farras Doko on 20/09/22.
//

import XCTest
import SALT_Test

class HTTPClientTests: XCTestCase {
    
    func testEquatableSuccess_success() {
        let sut = HTTPClientResult<String>.success("asd")
        let sut2 = HTTPClientResult<String>.success("asd")
        
        XCTAssertEqual(sut, sut2)
    }
    
    func testEquatableSuccess_differentContent_failed() {
        let sut = HTTPClientResult<String>.success("asd")
        let sut2 = HTTPClientResult<String>.success("dsa")
        
        XCTAssertNotEqual(sut, sut2)
    }
    
    func testEquatableFailed_success() {
        let sut = HTTPClientResult<String>.failed(msg: "asd")
        let sut2 = HTTPClientResult<String>.failed(msg: "asd")
        
        XCTAssertEqual(sut, sut2)
    }
    
    func testEquatableFailed_failed() {
        let sut = HTTPClientResult<String>.failed(msg: "asd")
        let sut2 = HTTPClientResult<String>.failed(msg: "dsa")
        
        XCTAssertNotEqual(sut, sut2)
    }
    
    func testEquatableOtherError_success() {
        let sut = HTTPClientResult<String>.otherError
        let sut2 = HTTPClientResult<String>.otherError
        
        XCTAssertEqual(sut, sut2)
    }
    
    func testEquatableDifferent_success() {
        let sut = HTTPClientResult<String>.failed(msg: "asd")
        let sut2 = HTTPClientResult<String>.success("asd")
        
        XCTAssertNotEqual(sut, sut2)
    }

}
