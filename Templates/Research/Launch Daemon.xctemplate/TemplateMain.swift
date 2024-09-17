import Foundation
import OSLog

private let logger = Logger(subsystem: "___VARIABLE_bundleIdentifier___", category: "Daemon")

@main
struct ___PACKAGENAMEASIDENTIFIER___ {
    static func main() throws {
        logger.log("___PACKAGENAMEASIDENTIFIER___ daemon running!")
        
        dispatchMain()
    }
}
