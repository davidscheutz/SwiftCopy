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
        let user = User1(id: id, name: .init(first: "Test", last: "User"), created: now)
        let updatedName = User1.Name(first: " Updated Test", last: "Updated User")
        let updatedUser = User1(id: id, name: updatedName, created: now)
        
        XCTAssertEqual(user.copy(name: updatedName), updatedUser)
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
        
        let builder = User2.Builder()
        
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
        
        let updater = initialUser.updater()
        
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
        let initialUser = User1(id: UUID().hashValue, name: .init(first: "Test", last: "User"), created: Date())
        
        let updater = initialUser.updater()
        
        XCTAssertFalse(updater.hasChanges())
        
        let updatedFirstName = "Updated First Name"
        updater.with(name: initialUser.name.copy(first: updatedFirstName))
        
        XCTAssertTrue(updater.hasChanges())
        XCTAssertEqual(updater.build(), initialUser.copy(name: initialUser.name.copy(first: updatedFirstName)))
        
        updater.reset()
        XCTAssertFalse(updater.hasChanges())
        XCTAssertEqual(updater.build(), initialUser)
        
        let updatedUser = initialUser.copy(name: .init(first: "New first name", last: "New last name"))
        updater.update(using: updatedUser)
        
        XCTAssertTrue(updater.hasChanges())
        XCTAssertEqual(updater.build(), updatedUser)
    }
}
