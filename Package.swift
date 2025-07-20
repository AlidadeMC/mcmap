// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "MCMap",
    platforms: [.macOS(.v15), .iOS(.v18), .tvOS(.v18), .watchOS(.v11), .visionOS(.v2)],
    products: [
        .library(
            name: "MCMap",
            targets: ["MCMap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/jrothwell/VersionedCodable.git", from: "1.1.0")
    ],
    targets: [
        .target(
            name: "MCMap",
            dependencies: ["VersionedCodable"]
        ),
        .testTarget(
            name: "MCMapTests",
            dependencies: ["MCMap"]
        ),
    ]
)
