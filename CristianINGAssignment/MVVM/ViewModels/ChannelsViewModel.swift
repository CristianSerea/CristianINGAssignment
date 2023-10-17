//
//  ChannelsViewModel.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 16.10.2023.
//

import Foundation
import RxCocoa
import RxSwift

class ChannelsViewModel {
    var channels: BehaviorRelay<[Channel]> = BehaviorRelay(value: [])
    var error: PublishSubject<Error> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    func fetchData(specifics: [Specific]) {
        guard let url = URL(string: GlobalConstants.domain + GlobalConstants.channels) else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        session.rx.data(request: request)
            .map { data -> [Channel] in                
                if let channelsRecord = try? JSONDecoder().decode(ChannelsRecord.self, from: data) {
                    return channelsRecord.record
                } else {
                    throw NSError(domain: url.absoluteString,
                                  code: 1000,
                                  userInfo: ["message": "Decoding error"])
                }
            }
            .subscribe(
                onNext: { [weak self] channels in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        let channels = channels.filter({ channel -> Bool in
                            return specifics.allSatisfy({ specific in
                                return channel.specifics.contains(where: { $0.name == specific.name })
                            })
                        })
                        self?.channels.accept(channels)
                    })
                },
                onError: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
