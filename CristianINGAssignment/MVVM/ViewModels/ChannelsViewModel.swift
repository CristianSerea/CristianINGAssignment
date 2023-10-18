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
    
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()
    
    init(session: URLSessionProtocol? = nil) {
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func fetchData(specifics: [Specific]) {
        guard let url = URL(string: GlobalConstants.Server.domain + GlobalConstants.Server.channels) else {
            return
        }
        
        let request = URLRequest(url: url)
        session.rxData(request: request)
            .map { data -> [Channel] in
                do {
                    let channelsRecord = try JSONDecoder().decode(ChannelsRecord.self, from: data)
                    return channelsRecord.record
                } catch {
                    throw error
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
