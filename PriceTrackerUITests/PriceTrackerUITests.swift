//
//  PriceTrackerUITests.swift
//  PriceTrackerUITests
//
//  Created by Ivan Shulev on 3.12.25.
//

import XCTest

final class PriceTrackerUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
    }

    @MainActor
    func testSymbolsAppearance() throws {
        let app = XCUIApplication()
        app.activate()
        
        let list = app.collectionViews["feed_list"]
        XCTAssertTrue(list.waitForExistence(timeout: 1))
        
        let rowPredicate = NSPredicate { _, _ in
            list.cells.count > 0
        }
        
        expectation(for: rowPredicate, evaluatedWith: nil)
        waitForExpectations(timeout: 2)
        
        let connectionStatus = app/*@START_MENU_TOKEN@*/.staticTexts["feed_connectionStatusTitle"]/*[[".otherElements[\"feed_connectionStatusTitle\"].staticTexts",".otherElements",".staticTexts[\"🔴\"]",".staticTexts[\"feed_connectionStatusTitle\"]"],[[[-1,3],[-1,2],[-1,1,1],[-1,0]],[[-1,3],[-1,2]]],[0]]@END_MENU_TOKEN@*/.firstMatch
        let toggleButton = app.buttons["feed_toggleButton"].firstMatch
        
        XCTAssertEqual(connectionStatus.label, "🟢")
        XCTAssertEqual(toggleButton.label, "Stop")

        toggleButton.tap()
        
        XCTAssertEqual(connectionStatus.label, "🔴")
        XCTAssertEqual(toggleButton.label, "Start")
        
        let row = app.buttons["feed_itemRow_0"].firstMatch
        _ = row.waitForExistence(timeout: 2)
        row.tap()
        
        let detailsTicker = app.staticTexts["feed_details_ticker"].firstMatch
        _ = detailsTicker.waitForExistence(timeout: 1)
        
        let detailsName = app.staticTexts["feed_details_name"].firstMatch
        let detailsPrice = app.staticTexts["feed_details_price"].firstMatch
        let detailsDescription = app.staticTexts["feed_details_description"].firstMatch
        
        XCTAssertNotNil(detailsTicker.label)
        XCTAssertNotNil(detailsName.label)
        XCTAssertNotNil(detailsPrice.label)
        XCTAssertNotNil(detailsDescription.label)
    }
    
    @MainActor
    func testLaunchPerformance() throws {
        // This measures how long it takes to launch your application.
        measure(metrics: [XCTApplicationLaunchMetric()]) {
            XCUIApplication().launch()
        }
    }
}
