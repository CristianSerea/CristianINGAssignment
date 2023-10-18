//
//  URLSession+Extension.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 18.10.2023.
//

import Foundation
import RxSwift

protocol URLSessionProtocol {
    func rxData(request: URLRequest) -> Observable<Data>
}

extension URLSession: URLSessionProtocol {
    func rxData(request: URLRequest) -> Observable<Data> {
        return rx.data(request: request)
    }
}
