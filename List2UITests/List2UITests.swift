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
        
        app.buttons["add"].tap()
        
        let title = app.textFields["title"]
        title.tap()
        title.typeText(newItem)
        app.buttons["Save"].tap()
        
        XCTAssertTrue(app.buttons[newItem].waitForExistence(timeout: 1))
    }
    
}
