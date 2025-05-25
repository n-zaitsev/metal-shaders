import ProjectDescription

let project = Project(
    name: "metal-shaders",
    targets: [
        .target(
            name: "metal-shaders",
            destinations: .macOS,
            product: .app,
            bundleId: "io.tuist.metal-shaders",
            infoPlist: .default,
            sources: ["metal-shaders/Sources/**"],
            resources: ["metal-shaders/Resources/**"],
            dependencies: []
        ),
        .target(
            name: "metal-shadersTests",
            destinations: .macOS,
            product: .unitTests,
            bundleId: "io.tuist.metal-shadersTests",
            infoPlist: .default,
            sources: ["metal-shaders/Tests/**"],
            resources: [],
            dependencies: [.target(name: "metal-shaders")]
        ),
    ]
)
