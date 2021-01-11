import Foundation
import os.log

/// This a wrapper that's used to abstract out direct use of Apple's logging APIs, to allow logging to be performed in a more convenient manner.
@available(iOS 13, tvOS 10, macOS 10.12, *)
public struct Log {

    // MARK: - Properties

    /// This subsystem will be used whenever no subsystem is passed to an initializer. Defaults to `Bundle.main.bundleIdentifier`, or an empty string if that identifier can't be found.
    public static var defaultSubsystem = Bundle.main.bundleIdentifier ?? ""
    /// This can be set to `false` to completely disable logging. Defaults to `true`.
    public static var isLoggingEnabled = true

    /// The subsystem that is used in logging.
    public let subsystem: String
    /// The category that is used in logging.
    public let category: String
    /// The underlying logger being used.
    public let oslog: OSLog

    // MARK: - Object Lifecycle

    public init(_ category: String, subsystem: String = Self.defaultSubsystem) {
        self.category = category
        self.subsystem = subsystem
        self.oslog = OSLog(subsystem: subsystem, category: category)
    }

    public init(_ subject: Any, subsystem: String = Self.defaultSubsystem) {
        self.init("\(type(of: subject))", subsystem: subsystem)
    }

    // MARK: - Helper Functions

    private func createOSLog(category: String) -> OSLog {
        guard
            Self.isLoggingEnabled
        else {
            return .disabled
        }

        return OSLog(subsystem: subsystem, category: category)
    }

    // MARK: - Logging Functions

    @discardableResult
    private func performLog(
        _ message: String,
        type: OSLogType,
        includeCodeLocation: Bool,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> String? {
        var modifiedMessage = message
        if includeCodeLocation {
            modifiedMessage += " - \(file).\(function):\(line)"
        }

        guard
            Self.isLoggingEnabled == true
        else {
            return nil
        }

        os_log("%{public}@", log: self.oslog, type: type, modifiedMessage)
        return modifiedMessage
    }

    /// Use this level to capture information about process-level errors.
    ///
    /// The system always saves error messages in the data store. They remain there until a storage quota is exceeded, at which point the system purges the oldest messages.
    /// When you log an error message, the system saves other messages to the data store. If an activity object exists, the system captures information for the entire process chain related to that activity.
    ///
    /// - Warning: All logging is performed publicly and without redactions, so sensitive data should not be logged.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - includeCodeLocation: Whether or not the code location of this log should be appended to the message. If `true`, this will use the implicitly passed `file`, `function`, and `line` parameters.
    ///   - file: See `includeCodeLocation`
    ///   - function: See `includeCodeLocation`
    ///   - line: See `includeCodeLocation`
    /// - Returns: The message that was logged.
    @discardableResult
    public func error(
        _ message: String,
        includeCodeLocation: Bool = false,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> String? {
        performLog(
            message,
            type: .error,
            includeCodeLocation: includeCodeLocation,
            file: file,
            function: function,
            line: line
        )
    }

    /// Use this level to capture information that may be helpful, but isn’t essential, for troubleshooting errors.
    ///
    /// The system's default behavior is to store info messages in memory buffers. The system purges these messages when the memory buffers are full.
    /// When a piece of code logs an error or fault message, the info messages are also copied to the data store. They remain there until a storage quota is exceeded, at which point the system purges the oldest messages.
    ///
    /// - Warning: All logging is performed publicly and without redactions, so sensitive data should not be logged.
    /// - Parameters:
    ///   - message: The message to log.
    ///   - includeCodeLocation: Whether or not the code location of this log should be appended to the message. If `true`, this will use the implicitly passed `file`, `function`, and `line` parameters.
    ///   - file: See `includeCodeLocation`
    ///   - function: See `includeCodeLocation`
    ///   - line: See `includeCodeLocation`
    /// - Returns: The message that was logged.
    @discardableResult
    public func info(
        _ message: String,
        includeCodeLocation: Bool = false,
        file: StaticString = #file,
        function: StaticString = #function,
        line: UInt = #line
    ) -> String? {
        performLog(
            message,
            type: .info,
            includeCodeLocation: includeCodeLocation,
            file: file,
            function: function,
            line: line
        )
    }

}
