//
//  CampaignsViewModelTests.swift
//  CristianINGAssignmentTests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import CristianINGAssignment

class CampaignsViewModelTests: XCTestCase {
    private var mockSession: MockURLSession?
    private var campaignsViewModel: CampaignsViewModel?
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession()
        campaignsViewModel = CampaignsViewModel(session: mockSession)
    }

    func testFetchDataSuccess() {
        let mockData = """
        {
            "record": [["$10", "Attribute 2", "Attribute 3"], ["$20", "Attribute 2"]]
        }
        """.data(using: .utf8)
        
        mockSession?.mockData = mockData
        
        let expectation = XCTestExpectation(description: LocalizableConstants.fetchedCampaignsDataTitle)
        
        campaignsViewModel?.campaigns.asObservable()
            .skip(1)
            .subscribe(onNext: { campaigns in
                XCTAssertEqual(campaigns.count, 2)
                XCTAssertEqual(campaigns[0].price, "$10")
                XCTAssertEqual(campaigns[0].details, ["Attribute 2", "Attribute 3"])
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        if let channel = getChannel() {
            campaignsViewModel?.fetchData(channel: channel)
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchDataFailure() {
        mockSession?.mockError = NSError(domain: "mockError", code: 1000, userInfo: nil)
        
        let expectation = XCTestExpectation(description: LocalizableConstants.errorLabelTitle)
        
        campaignsViewModel?.error.subscribe(onNext: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        if let channel = getChannel() {
            campaignsViewModel?.fetchData(channel: channel)
        }
        
        wait(for: [expectation], timeout: 2.0)
    }
    
    func getChannel() -> Channel? {
        let jsonString = """
        {
            "id": "1",
            "name": "Channel name",
            "specifics": ["Specific 1", "Specific 2"]
        }
        """
        
        let jsonData = jsonString.data(using: .utf8)!
        let channel = try? JSONDecoder().decode(Channel.self, from: jsonData)
        
        return channel
    }
}
