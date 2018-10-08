//
//  Network.swift
//  NetworkPlatform
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import Moya
import RxMoya
import RxSwift
import RxCocoa
import Domain

final class Network {
    
    var disposeBag: DisposeBag?
    
    private let scheduler: ConcurrentDispatchQueueScheduler
    private let provider: MoyaProvider<APIManager>
    
    private var pollingIsEnable: Bool
    
    init(provider: MoyaProvider<APIManager>) {
        self.scheduler = ConcurrentDispatchQueueScheduler(qos: DispatchQoS(qosClass: DispatchQoS.QoSClass.background, relativePriority: 1))
        self.provider = provider
        self.pollingIsEnable = false
    }
    
    func getItems() -> Observable<[Ticker]> {
        return provider.rx.request(.tickers)
            .map(Domain.ResponseWrapper.self)
            .observeOn(scheduler)
            .flatMap({ wrapper -> Single<[Ticker]> in
                return Single.just(wrapper.tickers)
            }).asObservable()
    }
    
}
