// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GRDB",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "GRDB", targets: ["GRDB", "_GRDBDummy"]),
    ],
    targets: [
        .binaryTarget(
            name: "GRDB",
            url: "https://github.com/inline-chat/GRDB.swift/releases/download/3.1.1/GRDB.xcframework.zip",
            checksum: "d0cb96c05a0605b435b74e6f56470b9f175cd53db42c968a7ac1af7b67b34e3c"
        ),
        .target(name: "_GRDBDummy")
    ]
)
