// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "httpServer",
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
	    .package(url: "https://github.com/IBM-Swift/BlueSocket.git", .upToNextMinor(from: "0.12.76")),
	    .package(url: "https://github.com/Quick/Quick.git", from: "1.2.0"),
        .package(url: "https://github.com/Quick/Nimble.git", from: "7.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
                name: "CobSpec",
                dependencies: ["HttpServer"]),
        .target(
                name: "HttpServer",
                dependencies: ["Socket"]),
        .testTarget(
                name: "HttpServerSpec",
                dependencies: ["HttpServer", "Quick", "Nimble"])
    ]
)
