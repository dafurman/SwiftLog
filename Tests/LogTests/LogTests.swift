import XCTest
@testable import Log

@available(iOS 13, tvOS 10, macOS 10.12, *)
final private class LogTests: XCTestCase {

    private struct LoggableStruct: Loggable {
        let logCategory: String
    }

    func testLog() {
        let message = "Test Message"
        let category = "Category"

        XCTAssertEqual(Log(category).info(message), message)
        XCTAssertEqual(Log(category).debug(message), message)
        XCTAssertEqual(Log(category).error(message), message)
        XCTAssertEqual(Log(category).fault(message), message)
        XCTAssertEqual(Log(category).default(message), message)
    }

    func testLogCodeLocation() {
        let message = "Test Message"
        let category = "Category"

        func codeLocationSuffix(function: StaticString = #function, line: UInt) -> String {
            " - \(#file).\(function):\(line)"
        }

        XCTAssertEqual(Log(category).info(message, includeCodeLocation: true), message + codeLocationSuffix(line: #line))
        XCTAssertEqual(Log(category).debug(message, includeCodeLocation: true), message + codeLocationSuffix(line: #line))
        XCTAssertEqual(Log(category).error(message, includeCodeLocation: true), message + codeLocationSuffix(line: #line))
        XCTAssertEqual(Log(category).fault(message, includeCodeLocation: true), message + codeLocationSuffix(line: #line))
        XCTAssertEqual(Log(category).default(message, includeCodeLocation: true), message + codeLocationSuffix(line: #line))
    }

    func testLogCategoryFromType() {
        let inputType: Int = 0
        let log = Log(inputType)
        let expectedCategory = "\(type(of: inputType))"
        XCTAssertEqual(log.category, expectedCategory)
    }

    func testLogCategoryFromLoggable() {
        let logCategory = "LogCategory"
        let loggable: Loggable = LoggableStruct(logCategory: logCategory)
        let log = Log(loggable)
        XCTAssertEqual(log.category, logCategory)
    }

    func testLogCategoryFromRawString() {
        let logCategory = "LogCategory"
        let log = Log(logCategory)
        XCTAssertEqual(log.category, logCategory)
    }

    func testIsLoggingEnabled() {
        let log = Log(self)
        let message = "Message"
        let enabledMessage = log.info(message)
        XCTAssertEqual(enabledMessage, message)

        Log.isLoggingEnabled = false
        let disabledMessage = log.info(message)
        XCTAssertNil(disabledMessage)

        Log.isLoggingEnabled = true
        let reenabledMessage = log.info(message)
        XCTAssertEqual(reenabledMessage, message)
    }

    static var allTests = [
        ("testLog", testLog),
        ("testLogCodeLocation", testLogCodeLocation),
        ("testLogCategoryFromType", testLogCategoryFromType),
        ("testLogCategoryFromLoggable", testLogCategoryFromLoggable),
        ("testLogCategoryFromRawString", testLogCategoryFromRawString),
        ("testIsLoggingEnabled", testIsLoggingEnabled),
    ]

}
