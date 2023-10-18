//
//  NavigationUITests.swift
//  CristianINGAssignmentUITests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest

final class NavigationUITests: XCTestCase {
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func setUp() {
        super.setUp()
        
        app = XCUIApplication()
        app.launch()
    }
    
    func testTransitionFromSpecificsToChannels() {
        let specificsTitle = app.navigationBars["Specifics"]
        let specificCell = app.tables.cells.firstMatch
        XCTAssertTrue(specificsTitle.waitForExistence(timeout: 3))
        XCTAssertTrue(specificCell.waitForExistence(timeout: 3))
        
        specificCell.tap()
        
        let button = app.buttons["continue"]
        button.tap()
        
        let channelsTitle = app.navigationBars["Channels"]
        XCTAssertTrue(channelsTitle.waitForExistence(timeout: 5))
    }
    
    func testTransitionFromSpecificsToCampaigns() {
        let specificsTitle = app.navigationBars["Specifics"]
        XCTAssertTrue(specificsTitle.waitForExistence(timeout: 3))
        
        let specificCell = app.tables.cells.firstMatch
        XCTAssertTrue(specificCell.waitForExistence(timeout: 3))
        specificCell.tap()
        
        let specificsButton = app.buttons["continue"]
        XCTAssertTrue(specificsButton.waitForExistence(timeout: 3))
        specificsButton.tap()
        
        let channelsTitle = app.navigationBars["Channels"]
        XCTAssertTrue(channelsTitle.waitForExistence(timeout: 5))
        
        let channelsCell = app.tables.cells.firstMatch
        XCTAssertTrue(channelsCell.waitForExistence(timeout: 5))
        
        channelsCell.tap()
        
        let channelsButton = app.buttons["continue"]
        XCTAssertTrue(channelsButton.waitForExistence(timeout: 5))
        channelsButton.tap()
        
        let campaignsTitle = app.navigationBars["Campaigns"]
        XCTAssertTrue(campaignsTitle.waitForExistence(timeout: 8))
    }
    
    func testTransitionFromSpecificsToCampaignReview() {
        let specificsTitle = app.navigationBars["Specifics"]
        XCTAssertTrue(specificsTitle.waitForExistence(timeout: 3))
        
        let specificCell = app.tables.cells.firstMatch
        XCTAssertTrue(specificCell.waitForExistence(timeout: 3))
        specificCell.tap()
        
        let specificsButton = app.buttons["continue"]
        XCTAssertTrue(specificsButton.waitForExistence(timeout: 3))
        specificsButton.tap()
        
        let channelsTitle = app.navigationBars["Channels"]
        XCTAssertTrue(channelsTitle.waitForExistence(timeout: 5))
        
        let channelsCell = app.tables.cells.firstMatch
        XCTAssertTrue(channelsCell.waitForExistence(timeout: 5))
        
        channelsCell.tap()
        
        let channelsButton = app.buttons["continue"]
        XCTAssertTrue(channelsButton.waitForExistence(timeout: 5))
        channelsButton.tap()
        
        let campaignsTitle = app.navigationBars["Campaigns"]
        XCTAssertTrue(campaignsTitle.waitForExistence(timeout: 8))
        
        let campaignCell = app.collectionViews.cells.firstMatch
        XCTAssertTrue(campaignCell.waitForExistence(timeout: 8))
        
        let campaignButton = campaignCell.buttons["select"]
        XCTAssertTrue(campaignButton.waitForExistence(timeout: 8))
        campaignButton.tap()
        
        let campaignTitle = app.navigationBars["Campaign"]
        XCTAssertTrue(campaignTitle.waitForExistence(timeout: 10))
    }
}
