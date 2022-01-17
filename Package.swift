// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ClampedInteger",
    products: [
        .library(
            name: "ClampedInteger",
            targets: ["ClampedInteger"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "ClampedInteger",
            dependencies: []),
        .testTarget(
            name: "ClampedIntegerTests",
            dependencies: ["ClampedInteger"]),
    ]
)
