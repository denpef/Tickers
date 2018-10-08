//
//  TickerItemViewModel.swift
//  GithubTickersSurfing
//
//  Created by Денис Ефимов on 03.10.2018.
//  Copyright © 2018 Denis Efimov. All rights reserved.
//

import Domain

struct TickerItemViewModel   {
    
    let ticker: Ticker
    let title:String
    var percentChange: String?
    var highestBid: String?
    
    
    init (with ticker: Ticker) {
        self.ticker = ticker
        self.title = ticker.title ?? "--"
        if let quote = ticker.quote {
            self.percentChange = quote.percentChange
            self.highestBid = quote.highestBid
        }
        
    }
    
}
