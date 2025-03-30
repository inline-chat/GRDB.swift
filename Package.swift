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
            url: "https://github.com/inline-chat/GRDB.swift/releases/download/3.0.8/GRDB.xcframework.zip",
            checksum: "02849a50c8649b64cf7d844374506313e9ccac21925284c5f65ea2ee48c89f9c"
        ),
        .target(name: "_GRDBDummy")
    ]
)
