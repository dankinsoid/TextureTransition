// swift-tools-version:5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "TextureTransition",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "TextureTransition",
            targets: ["TextureTransition"]
		),
    ],
    dependencies: [
        .package(url: "https://github.com/FluidGroup/Texture.git", branch: "spm"),
        .package(url: "https://github.com/dankinsoid/VDTransition.git", from: "1.11.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "TextureTransition",
            dependencies: [
                "VDTransition",
                .product(name: "AsyncDisplayKit", package: "Texture")
            ]
        ),
        .testTarget(
            name: "TextureTransitionTests",
            dependencies: ["TextureTransition"]
        ),
    ]
)
