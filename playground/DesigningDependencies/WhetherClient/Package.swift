// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WhetherClient",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "WhetherClient",
            type: .dynamic,
            targets: ["WhetherClient"]),
        .library(
            name: "WhetherClientLive",
            type: .dynamic,
            targets: ["WhetherClientLive"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "WhetherClient",
            dependencies: []),
        .testTarget(
            name: "WhetherClientTests",
            dependencies: ["WhetherClient"]),
        .target(
            name: "WhetherClientLive",
            dependencies: ["WhetherClient"]),
    ])
