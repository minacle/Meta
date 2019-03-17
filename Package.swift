// swift-tools-version:4.2
// Managed by ice

import PackageDescription

let package = Package(
    name: "Meta",
    products: [
        .library(name: "Meta", targets: ["Meta"]),
    ],
    dependencies: [
        .package(url: "https://github.com/minacle/Poste", .revision("cd3cae796343fa06290e1d02d7ecf2f57dca9f4c")),
    ],
    targets: [
        .target(name: "Meta", dependencies: ["Poste"]),
    ]
)
