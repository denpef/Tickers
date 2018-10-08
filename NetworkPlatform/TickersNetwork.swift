//
//  TickersNetwork.swift
//  NetworkPlatform
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import RxSwift
import Domain

public final class TickersNetwork {
    
    private let network: Network
    
    init(network: Network) {
        self.network = network
    }
    
    public func fetchTickers() -> Observable<[Ticker]> {
        return network.getItems()
    }
    
}
