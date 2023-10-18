//
//  SpecificViewModel.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import Foundation
import RxCocoa
import RxSwift

class SpecificsViewModel {    
    var specifics: BehaviorRelay<[Specific]> = BehaviorRelay(value: [])
    var error: PublishSubject<Error> = PublishSubject()
    
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()
    
    init(session: URLSessionProtocol? = nil) {
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func fetchData() {
        guard let url = URL(string: GlobalConstants.Server.domain + GlobalConstants.Server.specifics) else {
            return
        }
        
        let request = URLRequest(url: url)
        session.rxData(request: request)
            .map { data -> [Specific] in
                do {
                    let specificsRecord = try JSONDecoder().decode(SpecificsRecord.self, from: data)
                    return specificsRecord.record.compactMap({ Specific(name: $0) })
                } catch {
                    throw error
                }
            }
            .subscribe(
                onNext: { [weak self] specifics in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self?.specifics.accept(specifics)
                    })
                },
                onError: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
