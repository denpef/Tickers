//
//  TickersUseCaseNetwork.swift
//  NetworkPlatform
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RxSwift
import Domain

final class TickersUseCase: Domain.TickerUseCase {
    private let network: TickersNetwork
    
    init(network: TickersNetwork) {
        self.network = network
    }
    
    func tickers() -> Observable<[Ticker]> {
        return network.fetchTickers()
    }
    
}

struct MapFromNever: Error {}
extension ObservableType where E == Never {
    func map<T>(to: T.Type) -> Observable<T> {
        return self.flatMap { _ in
            return Observable<T>.error(MapFromNever())
        }
    }
}
