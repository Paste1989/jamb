//
//  RankingHelper.swift
//  Jamb
//
//  Created by Saša Brezovac on 24.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import Foundation

class RankingHelper {
    
    class func saveData(cards: [CardRanking]){
        let cardsData = NSKeyedArchiver.archivedData(withRootObject: cards)
        UserDefaults.standard.set(cardsData, forKey: "cardsArray")
        UserDefaults.standard.synchronize()
    }
    
    class func getData() -> [CardRanking]? {
        let cardData = UserDefaults.standard.data(forKey: "cardsArray")
        if cardData != nil {
            if let cards = NSKeyedUnarchiver.unarchiveObject(with: cardData!) as? [CardRanking]{
                return cards
            }
        }
        return [CardRanking]()
    }
    
    
    
    class func saveArrayData(data: [[String]]) {
        let scoreData = NSKeyedArchiver.archivedData(withRootObject: data)
        UserDefaults.standard.set(scoreData, forKey: "scoresArray")
        UserDefaults.standard.synchronize()
    }
    
    class func getArrayData() -> [[String]]? {
        let scoresData = UserDefaults.standard.data(forKey: "scoresArray")
        if scoresData != nil {
            if let data = NSKeyedUnarchiver.unarchiveObject(with: scoresData!) as? [[String]]{
                return data
            }
        }
        return [[String]]()
    }
    
    class func deleteArrayData() {
        UserDefaults.standard.set(nil, forKey: "scoresArray")
        UserDefaults.standard.synchronize()
    }
}
