//
//  SpecificsViewModelTests.swift
//  CristianINGAssignmentTests
//
//  Created by Cristian Serea on 18.10.2023.
//

import XCTest
import RxSwift
import RxCocoa
@testable import CristianINGAssignment

class SpecificsViewModelTests: XCTestCase {
    private var mockSession: MockURLSession?
    private var specificsViewModel: SpecificsViewModel?
    private let disposeBag = DisposeBag()

    override func setUp() {
        super.setUp()
        
        mockSession = MockURLSession()
        specificsViewModel = SpecificsViewModel(session: mockSession)
    }

    func testFetchDataSuccess() {
        let mockData = """
        {
            "record": ["Specific 1", "Specific 2", "Specific 3"]
        }
        """.data(using: .utf8)
        
        mockSession?.mockData = mockData
        
        let expectation = XCTestExpectation(description: LocalizableConstants.fetchedSpecificsDataTitle)
        
        specificsViewModel?.specifics.asObservable()
            .skip(1)
            .subscribe(onNext: { specifics in
                XCTAssertEqual(specifics.count, 3)
                expectation.fulfill()
            })
            .disposed(by: disposeBag)
        
        specificsViewModel?.fetchData()
        wait(for: [expectation], timeout: 2.0)
    }

    func testFetchDataFailure() {
        mockSession?.mockError = NSError(domain: "mockError", code: 1000)
        
        let expectation = XCTestExpectation(description: LocalizableConstants.errorLabelTitle)
        
        specificsViewModel?.error.subscribe(onNext: { error in
            XCTAssertNotNil(error)
            expectation.fulfill()
        })
        .disposed(by: disposeBag)
        
        specificsViewModel?.fetchData()
        wait(for: [expectation], timeout: 2.0)
    }
}
