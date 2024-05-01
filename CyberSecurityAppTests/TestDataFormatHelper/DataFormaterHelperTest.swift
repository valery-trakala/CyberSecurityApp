import XCTest
@testable import CyberSecurityApp

final class DateFormatterHelperTests: XCTestCase {
    
    var dateFormatterHelper: DateFormatterHelper!
    
    override func setUpWithError() throws {
        dateFormatterHelper = DateFormatterHelper()
    }
    
    override func tearDownWithError() throws {
        dateFormatterHelper = nil
    }
    
    func testFormatDate() {
        let inputDate = Date(timeIntervalSince1970: 1619782800)
        let customFormat = "MMMM dd, yyyy"
        let expectedOutput = "April 30, 2021"
        
        let formattedDate = dateFormatterHelper.formatDate(date: inputDate, to: customFormat)
        
        XCTAssertEqual(formattedDate, expectedOutput, "Date should be formatted correctly")
    }
}
