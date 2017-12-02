import Foundation
import Kitura

import KituraMarkdown
import KituraStencil // required for using StencilTemplateEngine
import Stencil // required for adding a Stencil namespace to StencilTemplateEngine

import LoggerAPI
import Configuration
import CloudEnvironment
import KituraContracts
import Health
import SwiftMetrics
import SwiftMetricsDash
import SwiftMetricsPrometheus
import LoggerAPI

var swiftMetrics: SwiftMetrics?
var swiftMetricsDash: SwiftMetricsDash?
var swiftMetricsPrometheus: SwiftMetricsPrometheus?

public let projectPath = ConfigurationManager.BasePath.project.path
public let health = Health()

public class App {
    let router = Router()
    let cloudEnv = CloudEnv()

    public init() throws {
        //router.add(templateEngine: MustacheTemplateEngine())
        let engine = StencilTemplateEngine()
        
        
        
        router.add(templateEngine: engine)
    }

    func initializeHealthRoutes(app: App) {
        app.router.get("/health") { request, response, _ in
            let result = health.status.toSimpleDictionary()
            if health.status.state == .UP {
                try response.send(json: result).end()
            } else {
                try response.status(.serviceUnavailable).send(json: result).end()
            }
        }
    }

    func initializeMetrics(app: App) {
        do {
            let metrics = try SwiftMetrics()
            let dashboard = try SwiftMetricsDash(swiftMetricsInstance: metrics, endpoint: app.router)
            let prometheus = try SwiftMetricsPrometheus(swiftMetricsInstance: metrics, endpoint: app.router)

            swiftMetrics = metrics
            swiftMetricsDash = dashboard
            swiftMetricsPrometheus = prometheus
            Log.info("Initialized metrics.")
        } catch {
            Log.warning("Failed to initialize metrics: \(error)")
        }
    }


    func postInit() throws {
        // Capabilities
        initializeMetrics(app: self)

        // Endpoints
        initializeHealthRoutes(app: self)
        
        // Get current directory path
        

        router.get("/") { req, res, next in
            let fileName:String = req.parsedURL.path ?? ""
            res.headers.append("Content-Type", value: "text/html")
            
            Log.info("GET: \(fileName) \(self.router.viewsPath)")
            //if let fileData: Data = try? Data(contentsOf: URL(fileURLWithPath: "\(projectPath)/Resources/index.html")), let html = String(data: fileData, encoding:.utf8) {
                //try res.send(html).end()
                
            var context = [
                "articles": [
                    ["title": "Migrating from OCUnit to XCTest", "author": "Kyle Fuller"],
                    ["title": "Memory Management with ARC", "author": "Kyle Fuller" ]
                ]
            ]

            do{
                try res.render("index.stencil", context: context).end()
            }catch{
                
                Log.error(error.localizedDescription)
            }
                
//            }else{
//                Log.info("path: \(fileName)")
//                next()
//            }
        }
        
        router.all("/", middleware: StaticFileServer(path: "\(projectPath)/Resources"))
        
        // A custom Not found handler
        router.all { request, response, next in
            if  response.statusCode == .unknown  {
                // Remove this wrapping if statement, if you want to handle requests to / as well
                let path = request.urlURL.path
                if  path != "/" && path != ""  {
                    try response.status(.notFound).send("Route not found in Sample application!").end()
                }
            }
            next()
        }
    }

    public func run() throws {
        try postInit()
        Kitura.addHTTPServer(onPort: 1661, with: router)
        Kitura.run()
    }
}
