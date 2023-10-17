//
//  CampaignsViewModel.swift
//  CristianINGAssignment
//
//  Created by Cristian Serea on 17.10.2023.
//

import Foundation
import RxCocoa
import RxSwift

class CampaignsViewModel {
    var campaigns: BehaviorRelay<[Campaign]> = BehaviorRelay(value: [])
    var error: PublishSubject<Error> = PublishSubject()
    
    private let disposeBag = DisposeBag()
    
    func fetchData(channel: Channel) {
        guard let url = URL(string: GlobalConstants.domain + channel.id) else {
            return
        }
        
        let request = URLRequest(url: url)
        let session = URLSession(configuration: .default)
        
        session.rx.data(request: request)
            .map { data -> [Campaign] in
                if let campaignsRecord = try? JSONDecoder().decode(CampaignsRecord.self, from: data) {
                    return campaignsRecord.record
                } else {
                    throw NSError(domain: url.absoluteString,
                                  code: 1000,
                                  userInfo: ["message": "Decoding error"])
                }
            }
            .subscribe(
                onNext: { [weak self] campaigns in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                        self?.campaigns.accept(campaigns)
                    })
                },
                onError: { [weak self] error in
                    self?.error.onNext(error)
                }
            )
            .disposed(by: disposeBag)
    }
}
