// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "AutoPagingTabView",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "AutoPagingTabView",
            targets: ["AutoPagingTabView"]
        )
    ],
    targets: [
        .target(
            name: "AutoPagingTabView",
            dependencies: [],
            path: "Sources"
        )
    ]
)
