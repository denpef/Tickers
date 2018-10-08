//
//  NetworkProvider.swift
//  NetworkPlatform
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import Moya

final class NetworkProvider {
    
    public func makeTickersUseCase() -> TickersNetwork {
        let provider = MoyaProvider<APIManager>()
        let network = Network(provider: provider)
        return TickersNetwork(network: network)
    }
    
}

enum APIManager {
    case tickers
}

extension APIManager: TargetType {
    var task: Task {
        switch self {
        case .tickers:
            return .requestParameters(parameters: ["command": "returnTicker"], encoding: URLEncoding())
        }
    }
    
    var baseURL: URL { return URL(string: "https://poloniex.com/public")! }
    
    var path: String {
        switch self {
        case .tickers:
            return ""
        }
        
    }
    var method: Moya.Method {
        return .get
    }
    
    var sampleData: Data {
        switch self {
        case .tickers:
            return Data.stubResponse(("testTickers"))
        }
    }
    
    var headers: [String: String]? {
        return nil
    }
}


fileprivate extension Data {
    
    /**
     Loads the sample response file from the bundle.
     **/
    static func stubResponse(_ filename: String) -> Data {
        @objc class TestClass: NSObject { }
        
        let bundle = Bundle(for: TestClass.self)
        
        guard let path = bundle.path(forResource: filename, ofType: "json") else {
            return Data()
        }
        
        do {
            return try Data(contentsOf: URL(fileURLWithPath: path))
        } catch {
            #if DEBUG
            fatalError("Failed to load stubbed response: \(error.localizedDescription)")
            #else
            return Data()
            #endif
        }
    }
}
