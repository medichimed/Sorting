//
//  InsertionModel.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/16/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import Foundation

class Insertion: BasicModel{

     func sort() -> (Int, Int){             
        for x in 1..<source[0].count {
            var y = x
            while y > 0 && source[0][y] < source[0][y - 1] { 
                let (a, b) = (y, y - 1)
                let tmp = source[0][y - 1]
                source[0][y - 1] = source[0][y]
                source[0][y] = tmp
                y -= 1
                return (a, b)
            }
        }
        return (0, 0)
    }
    
    @discardableResult override func machineSort() -> [Int]{
          for x in 1..<arrayForTesting.count {
            var y = x
            let temp = arrayForTesting[y]
            while y > 0 && temp < arrayForTesting[y - 1] {
              arrayForTesting[y] = arrayForTesting[y - 1]
              y -= 1
            }
            arrayForTesting[y] = temp
          }
          return arrayForTesting
    }
}

