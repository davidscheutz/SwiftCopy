// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftCopy",
    products: [
        .library(name: "SwiftCopy", targets: ["SwiftCopy"]),
        .plugin(name: "CodeGeneratorPlugin", targets: ["CodeGeneratorPlugin"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftCopy",
            dependencies: []
        ),
        .plugin(
            name: "CodeGeneratorPlugin",
            capability: .buildTool(),
            dependencies: [
                .target(name: "sourcery")
            ]
        ),
        .binaryTarget(
            name: "sourcery",
            path: "Binaries/sourcery.artifactbundle"
        ),
    ]
)
