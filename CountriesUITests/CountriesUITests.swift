//
//  CountriesUITests.swift
//  CountriesUITests
//
//  Created by Sujith Antony on 05/02/19.
//  Copyright © 2019 Sujith Antony. All rights reserved.
//

import XCTest

class CountriesUITests: XCTestCase {
   var app: XCUIApplication!
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    func testIntroScreenHasProperUIElements() {
        
        XCTAssert(app.tables["Countries Table"].exists)
        
        XCTAssert(app.searchFields.firstMatch.exists)
        
        
       // XCTAssert(app.searchFields["search-bar"].exists)
        
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testSearch(){
        app.navigationBars["Countries.OnlineSearch"].searchFields["Search Countries"].tap()
        app.typeText("India")
        let tablesQuery = app.tables["Countries Table"]
         let predicate = NSPredicate(format: "label CONTAINS[c] %@", "India")
         Thread.sleep(forTimeInterval: 1)
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts.element(matching: predicate)
        XCTAssert(firstCell.exists)//
        
        let secondCell = tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts.element(matching: predicate)
        XCTAssert(secondCell.exists)//
    }
    
    
    func testSearchLandScape(){
        
         XCUIDevice.shared.orientation = .landscapeLeft
        app.navigationBars["Countries.OnlineSearch"].searchFields["Search Countries"].tap()
        app.typeText("India")
        let tablesQuery = app.tables["Countries Table"]
        let predicate = NSPredicate(format: "label CONTAINS[c] %@", "India")
        Thread.sleep(forTimeInterval: 1)
        let firstCell = tablesQuery.children(matching: .cell).element(boundBy: 0).staticTexts.element(matching: predicate)
        XCTAssert(firstCell.exists && firstCell.isHittable)//
        
        let secondCell = tablesQuery.children(matching: .cell).element(boundBy: 1).staticTexts.element(matching: predicate)
        XCTAssert(secondCell.exists && secondCell.isHittable)//
        
        
        XCUIDevice.shared.orientation = .landscapeRight
        XCTAssert(firstCell.exists && firstCell.isHittable)//
        XCTAssert(secondCell.exists && secondCell.isHittable)
    }
    
}
