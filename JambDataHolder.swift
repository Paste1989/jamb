//
//  JambDataHolder.swift
//  Jamb
//
//  Created by Saša Brezovac on 09.01.2018..
//  Copyright © 2018. Saša Brezovac. All rights reserved.
//

import UIKit

enum ModelType: Int {
    case down
    case upDown
    case up
    case najava
    case score
}


class JambDataHolder: NSObject {
    var dataHolder: [String] = [String]()	
    
    var sum1: Int = 0
    var sum2: Int = 0
    var sum3: Int = 0
    
    
    var type:ModelType = .down
    
    convenience init(withType:ModelType){
        self.init()
        self.type = withType
    }
    
    
    
    func insertElement(index:Int, value:String){
        self.dataHolder[index] = value
        sum1 = 0
        sum2 = 0
        sum3 = 0
        
        for num in dataHolder[0..<6] {
            sum1 += Int(num) ?? 0
        }
        if sum1 >= 60 {
            sum1 += 30
        }
        dataHolder[6] = "\(sum1)"
        //        print(sum1)
        
        
        let first = Int(dataHolder[7]) ?? 0
        let sec = Int(dataHolder[8]) ?? 0
        let oneValue = Int(dataHolder[0]) ?? 0
        sum2 = first - sec
        sum2 = sum2 * oneValue
        
        if first == 0 && sec != 0 {
            dataHolder[9] = "0"
        }
        else if first != 0 && sec == 0{
            dataHolder[9] = "0"
        }
        else{
            dataHolder[9] = "\(sum2)"
            //        print(sum2)
        }
        
        
        for num in dataHolder[10..<14] {
            sum3 += Int(num) ?? 0
        }
        dataHolder[14] = "\(sum3)"
        //       print(sum3)
    }
}



