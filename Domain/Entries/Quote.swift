//
//  Quote.swift
//  Domain
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import RealmSwift

public class Quote: RealmSwift.Object, Decodable {
    
    @objc public dynamic var id: Int = 0
    @objc public dynamic var highestBid: String = ""
    @objc public dynamic var percentChange: String = ""
    
    enum CodingKeys: String, CodingKey {
        case id
        case highestBid
        case percentChange
    }
    
    convenience init(id: Int, highestBid: String, percentChange: String) {
        self.init()
        
        self.id = id
        self.highestBid = highestBid
        self.percentChange = percentChange
    }
    
    override public static func primaryKey() -> String? {
        return "id"
    }
    
    override public static func indexedProperties() -> [String] {
        return ["id"]
    }
    
}
