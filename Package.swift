// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SerbianTranslit",
    platforms: [
        .iOS(.v15),
        .macOS(.v12)
    ],
    products: [
        .library(
            name: "SerbianTranslit",
            targets: ["SerbianTranslit"]),
    ],
    dependencies: [
        .package(url: "https://github.com/botforge-pro/swift-embed", from: "1.5.0")
    ],
    targets: [
        .target(
            name: "SerbianTranslit",
            dependencies: [
                .product(name: "SwiftEmbed", package: "swift-embed")
            ],
            resources: [.process("Resources")]),
        .testTarget(
            name: "SerbianTranslitTests",
            dependencies: [
                "SerbianTranslit",
                .product(name: "SwiftEmbed", package: "swift-embed")
            ],
            resources: [.process("Resources")]),
    ]
)
