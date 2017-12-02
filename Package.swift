// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "WidgetDesigner",
    dependencies: [
        
      .package(url: "https://github.com/IBM-Swift/Kitura-TemplateEngine.git", .upToNextMinor(from: "1.7.2")),
      .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.8.0"),
      .package(url: "https://github.com/IBM-Swift/Kitura.git", .upToNextMinor(from: "2.0.0")),
      .package(url: "https://github.com/IBM-Swift/HeliumLogger.git", .upToNextMinor(from: "1.7.0")),
      .package(url: "https://github.com/IBM-Swift/CloudEnvironment.git", .upToNextMinor(from: "4.0.5")),
      .package(url: "https://github.com/IBM-Swift/Configuration.git", .upToNextMinor(from: "1.0.0")),
      .package(url: "https://github.com/RuntimeTools/SwiftMetrics.git", from: "2.0.0"),
      .package(url: "https://github.com/IBM-Swift/Health.git", from: "0.0.0"),
      .package(url: "https://github.com/IBM-Swift/Kitura-Markdown.git", .upToNextMinor(from: "0.9.1")),
     // .package(url: "https://github.com/IBM-Swift/Kitura-StencilTemplateEngine.git", from: "1.8.0"),
    //.package(url: "https://github.com/IBM-Swift/Kitura-MustacheTemplateEngine.git", from: "1.7.2"),
    
    ],
    targets: [
        .target(name: "WidgetDesigner", dependencies: [ .target(name: "Application"),
//                                                        "Kitura" ,
//                                                        "HeliumLogger",
//                                                        "KituraMarkdown",
                                                      //  "KituraStencil",
                                                        ]),
        
      .target(name: "Application", dependencies: [ "Kitura", "KituraTemplateEngine", "KituraMarkdown",
                                                   "HeliumLogger",
                                                   "Configuration",
                                                   "CloudEnvironment",
                                                   "SwiftMetrics",
                                                   "Health",
                                                   
                                                   "KituraStencil",
                                             //      "KituraMustache",
        ]),

      .testTarget(name: "ApplicationTests" , dependencies: [.target(name: "Application"), "Kitura", "HeliumLogger" ])
    ]
)
