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
    
    func test_builder() throws {
        let id1 = UUID().hashValue
        let id2 = UUID().hashValue
        
        let builder = User2Builder()
        
        XCTAssertFalse(builder.readyToBuild())
        
        do {
            _ = try builder.buildSafely()
            XCTFail("Expected to fail")
        } catch {}
        
        builder.with(id: id1)
        
        XCTAssertFalse(builder.readyToBuild())
        
        builder.id = id2
        
        builder.name = "Name 1"
        builder.with(name: "Name 2")
        
        XCTAssertTrue(builder.readyToBuild())
        
        let user = builder.build()
        
        XCTAssertEqual(user, .init(id: id2, name: "Name 2", profilePicture: nil))
    }
    
    func test_updated() {
        let id1 = UUID().hashValue
        let id2 = UUID().hashValue
        let initialUser = User2(id: id1, name: "Test User", profilePicture: nil)
        
        let updater = User2Updater(user2: initialUser)
        
        var updatedUser = updater.build()
        
        XCTAssertEqual(initialUser, updatedUser)
        
        updater.with(id: id2)
        
        updater.with(name: "Updated Name")
        
        updater.profilePicture = "https://test.url"
        
        updatedUser = updater.build()
        
        XCTAssertEqual(updatedUser, .init(id: id2, name: "Updated Name", profilePicture: "https://test.url"))
    }
    
    func test_copyOnlyStoredProperties() {
        let user = User3(id: UUID().hashValue)
        XCTAssertEqual(user.copy(id: 123), User3(id: 123))
    }
    
    func test_updater() {
        let user = User1(id: UUID().hashValue, firstName: "Test", lastName: "User", created: Date())
        
        let updater = user.updater()
        
        XCTAssertFalse(updater.hasChanges())
        
        let updatedFirstName = "Updated First Name"
        updater.with(firstName: updatedFirstName)
        
        XCTAssertTrue(updater.hasChanges())
        
        XCTAssertEqual(updater.build(), user.copy(firstName: updatedFirstName))
    }
}
