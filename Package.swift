// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "swift-training-backend",
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        .package(url: "https://github.com/vapor/fluent-postgresql.git", from: "1.0.0"),
        .package(url: "https://github.com/vapor-community/pagination.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "App", dependencies: ["Vapor", "FluentPostgreSQL", "Pagination"]),
        .target(name: "Run", dependencies: ["App"]),
        .testTarget(name: "AppTests", dependencies: ["App"])
    ]
)
