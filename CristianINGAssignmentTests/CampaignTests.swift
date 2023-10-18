//
//  CampaignTests.swift
//  CristianINGAssignmentTests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest
@testable import CristianINGAssignment

class CampaignTests: XCTestCase {
    func testCampaignProperties() {
        let attributes = ["$10", "Attribute 2", "Attribute 3"]
        let campaign = Campaign(attributes: attributes)
        
        XCTAssertEqual(campaign.price, "$10")
        XCTAssertEqual(campaign.details, ["Attribute 2", "Attribute 3"])
    }
    
    func testCampaignIsSelected() {
        var campaign = Campaign(attributes: ["$10"])
        
        XCTAssertFalse(campaign.isSelected)
        
        campaign.isSelected = true
        
        XCTAssertTrue(campaign.isSelected)
    }
    
    func testCampaignsRecordDecoding() {
        let jsonString = """
        {
            "record": [["$10", "Attribute 2"], ["$20", "Attribute 2", "Attribute 3"]]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let campaignsRecord = try JSONDecoder().decode(CampaignsRecord.self, from: jsonData)
            
            XCTAssertEqual(campaignsRecord.record.count, 2)
            
            XCTAssertEqual(campaignsRecord.record[0].price, "$10")
            XCTAssertEqual(campaignsRecord.record[0].details, ["Attribute 2"])
            
            XCTAssertEqual(campaignsRecord.record[1].price, "$20")
            XCTAssertEqual(campaignsRecord.record[1].details, ["Attribute 2", "Attribute 3"])
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
