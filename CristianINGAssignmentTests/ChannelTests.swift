//
//  ChannelTests.swift
//  CristianINGAssignmentTests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest
@testable import CristianINGAssignment

class ChannelTests: XCTestCase {
    func testChannelDecoding() {
        let jsonString = """
        {
            "id": "1",
            "name": "Channel name",
            "specifics": ["Specific 1", "Specific 2"]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let channel = try JSONDecoder().decode(Channel.self, from: jsonData)
            
            XCTAssertEqual(channel.id, "1")
            XCTAssertEqual(channel.name, "Channel name")
            XCTAssertEqual(channel.specifics.count, 2)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testChannelsRecordDecoding() {
        let jsonString = """
        {
            "record": [{
                "id": "1",
                "name": "Channel name",
                "specifics": ["Specific 1", "Specific 2", "Specific 3"]
            }]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let channelsRecord = try JSONDecoder().decode(ChannelsRecord.self, from: jsonData)
            
            XCTAssertEqual(channelsRecord.record.count, 1)
            XCTAssertEqual(channelsRecord.record[0].id, "1")
            XCTAssertEqual(channelsRecord.record[0].name, "Channel name")
            XCTAssertEqual(channelsRecord.record[0].specifics.count, 3)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testChannelProperties() {
        let jsonString = """
        {
            "id": "1",
            "name": "Channel name",
            "specifics": ["Specific 1", "Specific 2"]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            var channel = try JSONDecoder().decode(Channel.self, from: jsonData)
            let campaign1 = Campaign(attributes: ["$10", "Attribute 2"])
            let campaign2 = Campaign(attributes: ["$20", "Attribute 2", "Attribute 3"])
            channel.campaigns = [campaign1, campaign2]
            
            XCTAssertEqual(channel.id, "1")
            XCTAssertEqual(channel.name, "Channel name")
            XCTAssertEqual(channel.specifics.count, 2)
            XCTAssertEqual(channel.campaigns?.count, 2)
            XCTAssertEqual(channel.campaigns?.first?.attributes.count, 2)
            XCTAssertEqual(channel.campaigns?.last?.attributes.count, 3)
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
    
    func testSelectedCampaignProperty() {
        let jsonString = """
        {
            "id": "1",
            "name": "Channel name",
            "specifics": ["Specific 1", "Specific 2"]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            var channel = try JSONDecoder().decode(Channel.self, from: jsonData)
            var campaign1 = Campaign(attributes: ["$10", "Attribute 2"])
            let campaign2 = Campaign(attributes: ["$20", "Attribute 2", "Attribute 3"])
            campaign1.isSelected = true
            channel.campaigns = [campaign1, campaign2]
            
            
            XCTAssertEqual(channel.id, "1")
            XCTAssertEqual(channel.name, "Channel name")
            XCTAssertEqual(channel.specifics.count, 2)
            XCTAssertEqual(channel.campaigns?.count, 2)
            XCTAssertEqual(channel.campaigns?.first?.attributes.count, 2)
            XCTAssertEqual(channel.campaigns?.last?.attributes.count, 3)
            XCTAssertEqual(channel.selectedCampaign?.price, "$10")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
