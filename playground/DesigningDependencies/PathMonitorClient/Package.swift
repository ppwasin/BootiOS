// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PathMonitorClient",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "PathMonitorClient",
            type: .dynamic,
            targets: ["PathMonitorClient"]),
        .library(
            name: "PathMonitorClientLive",
            type: .dynamic,
            targets: ["PathMonitorClientLive"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "PathMonitorClient",
            dependencies: []),
        .testTarget(
            name: "PathMonitorClientTests",
            dependencies: ["PathMonitorClient"]),
        .target(
            name: "PathMonitorClientLive",
            dependencies: ["PathMonitorClient"]),
    ])
