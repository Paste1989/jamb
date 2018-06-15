//
//  RankingCard.swift
//  Jamb
//
//  Created by Saša Brezovac on 24.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//



import Foundation


class CardRanking: NSObject {
    
    var name: String!
    var finalScore: Int!
    
    init(name: String, finalScore: Int) {
        self.name = name
        self.finalScore = finalScore
    }
    
    
    @objc required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "name") as? String
        finalScore = aDecoder.decodeObject(forKey: "finalScore") as? Int
    }
    
    
    @objc func encodeWithCoder(_ aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(finalScore, forKey: "finalScore")
    }      
}

