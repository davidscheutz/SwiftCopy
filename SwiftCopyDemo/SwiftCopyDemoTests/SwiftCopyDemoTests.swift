//
//  SwiftCopyDemoTests.swift
//  SwiftCopyDemoTests
//
//  Created by David's MBP16 on 17.10.23.
//

import XCTest
@testable import SwiftCopyDemo

final class SwiftCopyDemoTests: XCTestCase {
    
    func test_copy() {
        let id = UUID().hashValue
        let now = Date()
        let user = User1(id: id, firstName: "Test", lastName: "User", created: now)
        let updatedUser = User1(id: id, firstName: "Updated Test", lastName: "Updated User", created: now)
        
        XCTAssertEqual(user.copy(firstName: "Updated Test", lastName: "Updated User"), updatedUser)
    }
    
    func test_optionalCopy() {
        let id = UUID().hashValue
        let user = User2(id: id, name: "Test User", profilePicture: nil)
        let updatedUser = User2(id: id, name: "Test User", profilePicture: "https://profile-url-123")
        
        XCTAssertEqual(user.copy(profilePicture: .update("https://profile-url-123")), updatedUser)
        
        XCTAssertEqual(user.copy(profilePicture: .reset), user)
        
        XCTAssertEqual(user.copy(profilePicture: .use("https://profile-url-123")), updatedUser)
        
        XCTAssertEqual(user.copy(profilePicture: .use(nil)), user)
    }
}
