// swift-tools-version: 6.1

import PackageDescription

let package = Package(
    name: "union-haptics",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "UnionHaptics",
            targets: ["UnionHaptics"]
        )
    ],
    targets: [
        .target(
            name: "UnionHaptics"
        )
    ]
)
