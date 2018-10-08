//
//  Ticker.swift
//  Domain
//
//  Created by Денис Ефимов on 04.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Foundation
import RealmSwift

public class Ticker: RealmSwift.Object {
    
    @objc public dynamic var title: String?
    @objc public dynamic var quote: Quote?
    
    convenience init(title: String, quote: Quote) {
        self.init()

        self.title = title
        self.quote = quote

    }
    
    override public static func primaryKey() -> String? {
        return "title"
    }
    
    override public static func indexedProperties() -> [String] {
        return ["title"]
    }
    
}

