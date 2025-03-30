// swift-tools-version: 5.7
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
            url: "https://github.com/inline-chat/GRDB.swift/releases/download/3.1.0/GRDB.xcframework.zip",
            checksum: "f6fa67a7ae52c99f96f7859e506c2186e30313c92a50dd7f7a9303af2b5a7bf3"
        ),
        .target(name: "_GRDBDummy")
    ]
)
