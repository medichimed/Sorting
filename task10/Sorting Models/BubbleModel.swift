//
//  BubbleModel.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/16/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import Foundation

class Bubble: BasicModel {

     func sort() -> (Int, Int){
        for _ in 0..<source[0].count {
          for j in 1..<source[0].count {
            if source[0][j] < source[0][j-1] {
              let tmp = source[0][j-1]
              source[0][j-1] = source[0][j]
              source[0][j] = tmp
              return (j - 1, j)
            }
          }
        }
        return (0,0)
    }
    
    @discardableResult override func machineSort() -> [Int]{
        for i in 0..<arrayForTesting.count {
          for j in 1..<arrayForTesting.count - i {
            if arrayForTesting[j] < arrayForTesting[j-1] {
              let tmp = arrayForTesting[j-1]
              arrayForTesting[j-1] = arrayForTesting[j]
              arrayForTesting[j] = tmp
            }
          }
        }
        return arrayForTesting
    }

}

