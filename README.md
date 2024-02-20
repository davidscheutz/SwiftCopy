![Supports iOS](https://img.shields.io/badge/iOS-Supported-blue.svg)
![Supports macOS](https://img.shields.io/badge/macOS-Supported-blue.svg)
![Supports watchOS](https://img.shields.io/badge/watchOS-Supported-blue.svg)
![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green)

# SwiftCopy

A Swift Package that provides a convenient, Kotlin-like way to copy immutable instances of Swift types such as `struct`.

## Usage

Simply conform your structs to the `Copyable` protocol.
 
```swift
struct State: Copyable {
    let id: Int
    let text: String
    let isLoading: Bool
}

let intial = State(id: "123", text: "", isLoading: false)   // id: "123", text: "",  isLoading: false

let updated = intial.copy(text: "hello")    // id: "123", text: "hello",  isLoading: false 

let loading = updated.copy(isLoading: true) // id: "123", text: "hello",  isLoading: true

```

#### Optional Properties Support

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

#### 1. Add Swift Package
You can use the [Swift Package Manager](https://swift.org/package-manager/) to install `SwiftCopy` by adding it as a dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "git@github.com:davidscheutz/SwiftCopy.git", from: "1.0.0")
]
```

Make sure to add `SwiftCopy` as a dependency to your Target.

#### 2. Add SwiftCopy CodeGeneratorPlugin as Build Tool Plugin

Select your Project -> Your Target -> Build Phases -> Add CodeGeneratorPlugin (SwiftCopy)

<img width="571" alt="Screenshot 2023-10-17 at 21 29 47" src="https://github.com/davidscheutz/SwiftCopy/assets/14020916/215b75f0-f557-41dd-b89b-1fb3378df4ab">

## Demo Project

Feel free to take a look at the `SwiftCopyDemo.xcodeproj` to see the library in action.

## Contributing

Contributions to SwiftCopy are welcomed and encouraged!

It is easy to get involved. Open an issue to discuss a new feature, write clean code, show some love using unit tests and open a Pull Request.

A list of contributors will be available through GitHub.

PS: Check the open issues and pull requests for existing discussions.

## License

SwiftCopy is available under the MIT license. See [LICENSE](https://github.com/davidscheutz/SwiftCopy/blob/master/LICENSE) for more information.

## Credit

This project uses [Sourcery](https://github.com/krzysztofzablocki/Sourcery) for the code generation.
