//
//  SpecificsTests.swift
//  CristianINGAssignmentTests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest
@testable import CristianINGAssignment

class SpecificTests: XCTestCase {
    func testSpecificProperties() {
        var specific = Specific(name: "Specific")
        
        XCTAssertEqual(specific.name, "Specific")
        XCTAssertFalse(specific.isSelected)
        
        specific.isSelected = true
        
        XCTAssertTrue(specific.isSelected)
    }
    
    func testSpecificsRecordDecoding() {
        let jsonString = """
        {
            "record": ["Specific 1", "Specific 2", "Specific 3"]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        
        do {
            let specificsRecord = try JSONDecoder().decode(SpecificsRecord.self, from: jsonData)
            
            XCTAssertEqual(specificsRecord.record.count, 3)
            XCTAssertEqual(specificsRecord.record[0], "Specific 1")
            XCTAssertEqual(specificsRecord.record[1], "Specific 2")
            XCTAssertEqual(specificsRecord.record[2], "Specific 3")
        } catch {
            XCTFail("Decoding failed with error: \(error)")
        }
    }
}
