import XCTest
@testable import CyberSecurityApp

//MARK: Constants
let date = Date(timeIntervalSince1970: 1619782800)
let sectionDateFormat = "MMM dd, yyyy"

//MARK: Mocks
class MockDateFormatterHelper: DateFormatterHelperProtocol {
    func formatDate(date: Date, to format: String) -> String {
        return "Mocked Date"
    }
}

class MockDataFetcher: DataFetcherProtocol {
    func getCategories() async throws -> [CategoriesModelResponse]? {
        let networkCategory = CategoriesModelResponse(id: 1, type: "Network", notifications: 3)
        let browserCategory = CategoriesModelResponse(id: 2, type: "Browser", notifications: 0)
        
        return [networkCategory, browserCategory]
    }
    
    
    func getNotifications(categoryId: Int, page: Int, pageSize: Int) async throws -> [CategoryNotificationModelResponse]? {
        let notifications = [
            CategoryNotificationModelResponse(id: 1, categoryId: categoryId, type: "Network", severity: .low, date: date),
            CategoryNotificationModelResponse(id: 2, categoryId: categoryId, type: "Network", severity: .medium, date: date),
            CategoryNotificationModelResponse(id: 3, categoryId: categoryId, type: "Network", severity: .high, date: date)
        ]
        
        return notifications
    }
}

//MARK: Tests
class AllCategoryNotificationsViewModelTests: XCTestCase {
    let categoryId = 1
    let totalCount = 3
    
    var viewModel: AllCategoryNotificationsViewModel!
    
    override func setUpWithError() throws {
        let dateFormatterHelper = MockDateFormatterHelper()
        let dataFetcher = MockDataFetcher()
        
        self.viewModel = AllCategoryNotificationsViewModel(
            for: categoryId,
            totalCount: totalCount,
            dateFormatterHelper: dateFormatterHelper,
            dataFetcher: dataFetcher)
    }
    
    override func tearDownWithError() throws {
        self.viewModel = nil
    }
    
    func testGetCategories() async {
        await handleDispatchCallOfGetCategories()
        
        XCTAssertFalse(viewModel.isLoading, "Loading should be set to false after fetching categories")
        XCTAssertFalse(viewModel.isNextPageLoading, "Next page loading should be set to false after fetching categories")
        XCTAssertEqual(viewModel.pageIndex, 2, "Page index should be incremented after fetching categories")
        XCTAssertEqual(viewModel.notificationSections.count, 1, "Notification sections should be created after fetching categories")
    }
    
    func testIsLastNotification() async {
        
        await handleDispatchCallOfGetCategories()
        
        let isLastNotification = viewModel.isLastNotification(CategoryNotificationModelResponse(
            id: 3,
            categoryId: categoryId,
            type: "Network",
            severity: .high,
            date: Date()))
        
        XCTAssertTrue(isLastNotification, "Notification should be last")
    }
    
    
    func testIsLastSection() async {
        await handleDispatchCallOfGetCategories()
        
        let formattedDate = viewModel.dateFormatterHelper.formatDate(date: date, to: sectionDateFormat)
        let isLastSection = viewModel.isLastSection(NotificationsSectionModel(notifications: [], date: formattedDate))
        
        XCTAssertTrue(isLastSection, "Section should be last")
    }
    
    func testIsAllDataLoaded() async {
        await handleDispatchCallOfGetCategories()
        
        let isAllDataLoaded = viewModel.isAllDataLoaded()
        XCTAssertTrue(isAllDataLoaded, "All data should be loaded")
    }
    
    func handleDispatchCallOfGetCategories() async {
        let expectation = XCTestExpectation(description: "Async operation completed")
        
        await viewModel.getCategories()
        
        DispatchQueue.main.async {
            expectation.fulfill()
        }
        await fulfillment(of: [expectation], timeout: 5)
    }
}


