import XCTest
@testable import Log

@available(iOS 13, tvOS 10, macOS 10.12, *)
final class LogTests: XCTestCase {

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

    static var allTests = [
        ("testLog", testLog),
        ("testLogCodeLocation", testLogCodeLocation)
    ]

}
