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
    
    private let session: URLSessionProtocol
    private let disposeBag = DisposeBag()
    
    init(session: URLSessionProtocol? = nil) {
        self.session = session ?? URLSession(configuration: .default)
    }
    
    func fetchData(channel: Channel) {
        guard let url = URL(string: GlobalConstants.Server.domain + channel.id) else {
            return
        }
        
        let request = URLRequest(url: url)
        session.rxData(request: request)
            .map { data -> [Campaign] in
                do {
                    let campaignsRecord = try JSONDecoder().decode(CampaignsRecord.self, from: data)                    
                    return campaignsRecord.record
                } catch {
                    throw error
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
