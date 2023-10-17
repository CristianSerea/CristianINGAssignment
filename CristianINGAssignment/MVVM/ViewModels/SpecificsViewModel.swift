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
    
    private let disposeBag = DisposeBag()
    
    func fetchData() {
        guard let url = URL(string: GlobalConstants.domain + GlobalConstants.specifics) else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        session.rx.data(request: request)
            .map { data -> [Specific] in                
                if let specificsRecord = try? JSONDecoder().decode(SpecificsRecord.self, from: data) {
                    return specificsRecord.record.compactMap({ Specific(name: $0) })
                } else {
                    throw NSError(domain: url.absoluteString,
                                  code: 1000,
                                  userInfo: ["message": "Decoding error"])
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
