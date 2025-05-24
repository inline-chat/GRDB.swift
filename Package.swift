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
            url: "https://github.com/inline-chat/GRDB.swift/releases/download/3.2.0/GRDB.xcframework.zip",
            checksum: "b37fcaa255238d5c4e43aba0a8619a0ba7a10785b457aba849d25f69f59a5c82"
        ),
        .target(name: "_GRDBDummy")
    ]
)
