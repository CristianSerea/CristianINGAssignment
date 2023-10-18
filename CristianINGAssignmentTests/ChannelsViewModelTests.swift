//
//  ChannelsViewModelTests.swift
//  CristianINGAssignmentTests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import CristianINGAssignment

class ChannelsViewModelTests: XCTestCase {
    private var mockSession: MockURLSession?
    private var channelsViewModel: ChannelsViewModel?
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession()
        channelsViewModel = ChannelsViewModel(session: mockSession)
    }

    func testFetchDataSuccess() {
        let mockData = """
        {
            "record": [{
                "id": "1",
                "name": "Channel 1",
                "specifics": ["Specific 1", "Specific 2"]
            }, {
                "id": "2",
                "name": "Channel 2",
                "specifics": ["Specific 3"]
            }]
        }
        """.data(using: .utf8)
        
        mockSession?.mockData = mockData
        
        let expectation = XCTestExpectation(description: LocalizableConstants.fetchedSpecificsDataTitle)
        
        let testSpecifics = [Specific(name: "Specific 1"), Specific(name: "Specific 2")]
        
        channelsViewModel?.channels.asObservable()
            .skip(1)
            .subscribe(onNext: { channels in
                XCTAssertEqual(channels.count, 1)
                XCTAssertEqual(channels[0].name, "Channel 1")
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        channelsViewModel?.fetchData(specifics: testSpecifics)
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchDataFailure() {
        mockSession?.mockError = NSError(domain: "mockError", code: 1000, userInfo: nil)
        
        let expectation = XCTestExpectation(description: LocalizableConstants.errorLabelTitle)
        
        channelsViewModel?.error.subscribe(onNext: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        channelsViewModel?.fetchData(specifics: [])
        wait(for: [expectation], timeout: 2.0)
    }
}
