![Supports iOS](https://img.shields.io/badge/iOS-Supported-blue.svg)
![Supports macOS](https://img.shields.io/badge/macOS-Supported-blue.svg)
![Supports watchOS](https://img.shields.io/badge/watchOS-Supported-blue.svg)
![SwiftPM Compatible](https://img.shields.io/badge/SwiftPM-Compatible-brightgreen.svg)
![License](https://img.shields.io/badge/license-MIT-green)

# SwiftCopy

A Swift Package that provides convenient copy functionality for immutable `struct`'s in Swift using code generation.

**Immutability - Why bother?**

Thread-safety, as they can't be modified after creation.

Predictability, makes debugging and reasoning about state changes easier. 

Essential for unidirectional data flow architecture and Functional Programming. 

## Usage

Simply conform your structs to the `Copyable` protocol.
 
```swift
struct Example: Copyable {
    let id: Int
    let input: String
    let isLoading: Bool
}
```

### - Copy

Build your project and you a `copy` method will be generated.

```swift
let intial = Example(id: "123", input: "", isLoading: false)
// id: "123", input: "", isLoading: false

let updated = intial.copy(input: "hello")
// id: "123", input: "hello", isLoading: false 

let loading = updated.copy(isLoading: true)
// id: "123", input: "hello", isLoading: true
```

#### Optional Properties Support

`SwiftCopy` wraps optional properties using the `OptionalCopy` enum providing control over how to update or reset it's value.

Available options are:

```swift
update(T)
use(T?)
reset
noChange
```

Example:

```swift
struct User: Copyable {
    let id: Int
    let name: String
    let profilePicture: String?
}
```

```swift
let myUser = User(id: "123", name: "David", profilePicture: nil)

// Assign a value to `profilePicture`
_ = myUser.copy(profilePicture: .update("https://dave.com/pictures/214381"))

// Reset `profilePicture`
_ = myUser.copy(profilePicture: .reset)

// Copy the instance by using an optional type
let optionalValue: String? = "Value"
_ = myUser.copy(profilePicture: .use(optionalValue))
```

### - Builder

Used to collect values required to instantiate your `struct`. Especially useful for object being created using user input.

```swift
struct OnboardingUser: Copyable {
    let firstName: String
    let lastName: String
    let username: String
    let dateOfBirth: Date
}
```

Compile your project and a `Builder` type will be generated for every type that confirms to `Copyable`. 

Each builder is nested within it's associated type and can be used as followed:

**Builder pattern**

```swift
let builder = OnboardingUser.Builder()

let user = builder
    .with(firstName: "David")
    .with(lastName: "Scheutz")
    // ...
    .build()
```

**Assign directly**

```swift
let builder = OnboardingUser.Builder()

builder.firstName = "David"
builder.lastName = "Scheutz"
// ...
let user = builder.build()
```

Note: The `build()` method force unwraps optional types and therefore will crash if a required value is missing. To avoid this you can either use `readyToBuild()` to check first or use `buildSafely()`, which will throw an exception.

### - Updater

Similar to the Builder, this object can be used to mutate an existing struct.

```swift
// Instantiate directly from Copyable instance
let updater = existingUser.updater()

// Instantiate using constructor
let updater = OnboardingUser.Updater(onboardingUser: existingUser)
```

```swift
// Usage via Builder pattern
let updatedUser = updater
    .with(firstName: "David New")
    ...
    .build()

// Usage via direct assignment
updater.firstName = "David"
...
let updatedUser = updater.build()
```

Note: The `build()` method is safe to use, as all values are present at all times, due to the Updated being instantiated with an existing object. 

#### Observable

Both the `Builder` and the `Updater` implement `ObservableObject`. Additionally to the `objectWillChange` there is a `objectDidChange` subject, making it ideal to use within SwiftUI views as well as outside views.

## Installation

#### 1. Add Swift Package
You can use the [Swift Package Manager](https://swift.org/package-manager/) to install `SwiftCopy` by adding it as a dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "git@github.com:davidscheutz/SwiftCopy.git", from: "1.2.0")
]
```

Make sure to add `SwiftCopy` as a dependency to your Target.

#### 2. Add SwiftCopy CodeGeneratorPlugin as Build Tool Plugin

Select your Project -> Your Target -> Build Phases -> Add SwiftCopyCodeGeneratorPlugin (SwiftCopy)

<img width="571" alt="Screenshot 2023-10-17 at 21 29 47" src="https://github.com/davidscheutz/SwiftCopy/assets/14020916/215b75f0-f557-41dd-b89b-1fb3378df4ab">

## Demo Project

Feel free to take a look at the `SwiftCopyDemo.xcodeproj` to see the library in action. The usage is demonstrated using tests, which can be found in `SwiftCopyDemoTests.swift` file.

## Contributing

Contributions to SwiftCopy are welcomed and encouraged!

It is easy to get involved. Open an issue to discuss a new feature, write clean code, show some love using unit tests and open a Pull Request.

A list of contributors will be available through GitHub.

PS: Check the open issues and pull requests for existing discussions.

## License

SwiftCopy is available under the MIT license. See [LICENSE](https://github.com/davidscheutz/SwiftCopy/blob/master/LICENSE) for more information.

## Credit

This project uses [Sourcery](https://github.com/krzysztofzablocki/Sourcery) for the code generation.
