//
//  UseCaseProviderNetwork.swift
//  NetworkPlatform
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import Domain

public final class NetworkUseCaseProvider: Domain.UseCaseProvider {    
    
    private let networkProvider: NetworkProvider
    
    public init() {
        networkProvider = NetworkProvider()
    }
    
    public func makeTickersUseCase() -> Domain.TickerUseCase {
        return TickersUseCase(network: networkProvider.makeTickersUseCase())
    }
    
}
