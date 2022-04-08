import XCTest

class List2UITests: XCTestCase {
    let app = XCUIApplication()

    override func setUpWithError() throws {
        continueAfterFailure = false
        app.launch()
    }

    override func tearDownWithError() throws {
    }
    
    func test_Add_an_item_to_the_list() throws {
        let newItem = "Item 1"
        
        // Given I am on the list screen
        XCTAssertTrue(app.navigationBars["List"].exists)
        
        // When I add a new item
        app.buttons["Add"].tap()
        let title = app.textFields["title"]
        title.tap()
        title.typeText(newItem)
        app.buttons["Save"].tap()
        
        // Then I should see the new item on the list
        XCTAssertTrue(app.buttons[newItem].waitForExistence(timeout: 1))
    }
    
}
