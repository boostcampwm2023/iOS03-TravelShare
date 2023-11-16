// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MacroDesignSystem",
    platforms: [.iOS(.v16)],
    products: [
        .library(
            name: "MacroDesignSystem",
            targets: ["MacroDesignSystem"]),
        .library(
            name: "Network",
            targets: ["Network"])
    ],
    targets: [
        .target(
            name: "MacroDesignSystem"),
        .testTarget(
            name: "MacroDesignSystemTests",
            dependencies: ["MacroDesignSystem"]),
        .target(
            name: "Network"),
        .testTarget(
            name: "NetworkTests",
            dependencies: ["Network"]),
    ]
)
