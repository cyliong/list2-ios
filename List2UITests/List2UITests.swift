import XCTest

class List2UITests: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false

    }

    override func tearDownWithError() throws {
        
    }
    
    func test_Add_an_item_to_the_list() throws {
        let app = XCUIApplication()
        app.launch()

        app.navigationBars["List"].buttons["plus"].tap()
        
        let title = app.textFields["Enter an item"]
        title.tap()
        title.typeText("Item 1")
        app.navigationBars["New Item"].buttons["Save"].tap()
        
        XCTAssertTrue(app.buttons["Item 1"].exists)
    }
    
}
