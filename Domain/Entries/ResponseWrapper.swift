//
//  ResponseWrapper.swift
//  Domain
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//
import RealmSwift

public class ResponseWrapper: Decodable {
    
    typealias TicketsDictionary = Dictionary<String, Quote>
    
    public var tickers: [Ticker] = []
    
    required public convenience init(from decoder: Decoder) throws {
        
        self.init()
        
        let container = try decoder.singleValueContainer()
        if let items = try container.decode(TicketsDictionary?.self) {
            do {
                let realm = try Realm()
                try realm.write {
                    for item in items {
                        let currentTicker:[String : Any] = ["title": item.key, "quote": item.value]
                        tickers.append(realm.create(Ticker.self, value: currentTicker, update: true))
                    }
                }
            }
            catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
}
