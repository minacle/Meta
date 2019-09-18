// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "Meta",
    products: [
        .library(name: "Meta", targets: ["Meta"]),
    ],
    dependencies: [
        .package(url: "https://github.com/minacle/Poste", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Meta", dependencies: ["Poste"]),
    ]
)
