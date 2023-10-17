<p>
    <img src="https://img.shields.io/badge/Swift-5.9-orange.svg" />
    <a href="https://swift.org/package-manager">
        <img src="https://img.shields.io/badge/spm-compatible-brightgreen.svg?style=flat" alt="Swift Package Manager" />
    </a>
    <img src="https://img.shields.io/badge/platforms-macOS | iOS | tvOS | watchOS" alt="Platforms: macOS, iOS, tvOS, watchOS" />
</p>

# SwiftCopy

SwiftCopy is a Swift Package that provides a convenient, Kotlin-like way to copy immutable instances of Swift structs.

## Usage

Simply conform your structs to the `Copyable` protocol.
 
```swift
struct User: Copyable {
    let id: Int
    let firstName: String
    let lastName: String
    let created: Date
}

let myUser = User(id: "123", firstName: "David", lastName: "Scheutz", created = .now)

// Copy the instance by changing the `firstName` and `lastName` properties
let updatedUser = myUser.copy(firstName: "Your", lastName: "Name")
```

### Optional Properties Support

`SwiftCopy` wraps optional properties using the `OptionalCopy` enum providing explicit control over how to update or reset it's state.

```swift
public enum OptionalCopy<T> {
    case update(T)
    case reset
    case noChange // default value used by the copy function
}
```

```swift
struct User: Copyable {
    let id: Int
    let name: String
    let profilePicture: String?
}

let myUser = User(id: "123", name: "David", profilePicture: nil)

// Copy the instance by setting the `profilePicture`
_ = myUser.copy(profilePicture: .update("https://dave.com/pictures/214381"))

// Copy the instance by resetting the `profilePicture`
_ = myUser.copy(profilePicture: .reset)

// Copy the instance by using an optional type directly
let optionalValue: String? = "Value"
_ = myUser.copy(profilePicture: .use(optionalValue))
```

## Installation

### 1. Swift Package Manager
You can use the [Swift Package Manager](https://swift.org/package-manager/) to install `SwiftCopy` by adding it as a dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "git@github.com:davidscheutz/SwiftCopy.git", from: "1.0.0")
]
```

Make sure to add `SwiftCopy` as a dependency to your Target.

### 2. Add SwiftCopy CodeGeneratorPlugin as Build Tool Plugin

Select your Project -> Your Target -> Build Phases -> Add CodeGeneratorPlugin (SwiftCopy)

// TODO: Insert screenshot  

## Demo Project

Feel free to take a look at the `SwiftCopyDemo.xcodeproj` to see the library in action.

## Credit

This project uses [Sourcery](https://github.com/krzysztofzablocki/Sourcery) for the code generation.
