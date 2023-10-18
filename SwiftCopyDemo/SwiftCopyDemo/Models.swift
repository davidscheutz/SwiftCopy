//
//  Models.swift
//  SwiftCopyDemo
//
//  Created by David's MBP16 on 17.10.23.
//

import Foundation
import SwiftCopy

struct User1: Equatable, Copyable {
    let id: Int
    let firstName: String
    let lastName: String
    let created: Date
}

struct User2: Equatable, Copyable {
    let id: Int
    let name: String
    let profilePicture: String?
}

struct User3: Equatable, Copyable {
    let id: Int

    init(id: Int) {
        self.id = id
    }
    
    /// This should not generate a copy function because it's a private property
    private var name = ""

    /// This should not generate a copy function because it's not a stored property
    var fullName: String {
        get { name }
        set { name = newValue }
    }

    /// This should not generate a copy function because it's not a stored property.
    var uppercasedName: String {
        name.uppercased()
    }
}
