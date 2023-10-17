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
