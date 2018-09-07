//
//  AIYTests.swift
//  AIYTests
//
//  Created by Ashley F Dsouza on 9/4/18.
//  Copyright © 2018 Ashley F Dsouza. All rights reserved.
//

import XCTest
@testable import AIY

class AIYTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    //Initialize a User when Sign Up is complete with valid parameters
    func testUserSignUpFails() {
        let emptyName = User.init(name: "", loginUsername: "test", loginPassword: "test", photo: nil)
        XCTAssertNil(emptyName);
        
        let emptyUsername = User.init(name: "Test Test", loginUsername: "", loginPassword: "test", photo: nil)
        XCTAssertNil(emptyUsername);
        
        let emptyPassword = User.init(name: "Test Test", loginUsername: "test", loginPassword: "", photo: nil)
        XCTAssertNil(emptyPassword);
    }
    
    func testUserSignUpPasses() {
        let validUserData = User.init(name: "Test Test", loginUsername: "test", loginPassword: "test", photo: nil)
        XCTAssertNotNil(validUserData);
    }
    
}
