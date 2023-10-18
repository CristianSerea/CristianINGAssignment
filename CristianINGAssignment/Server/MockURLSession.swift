//
//  MockURLSession.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import Foundation
import RxSwift

class MockURLSession: URLSessionProtocol {
    var mockData: Data?
    var mockError: Error?
    
    func rxData(request: URLRequest) -> Observable<Data> {
        if let error = mockError {
            return Observable.error(error)
        }
        
        return Observable.of(mockData ?? Data())
    }
}
