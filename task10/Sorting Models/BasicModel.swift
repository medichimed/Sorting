//
//  BasicModel.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/16/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import Foundation

class BasicModel{
    var source = [[Int]]()
    var arrayForTesting = [Int]()

    convenience init(capacity: Int){
        self.init()
        self.fillInSourceArray(capacity: capacity)
    }
    
    convenience init(testCapacity: Int){
        self.init()
        self.fillInArrayForTesting(capacity: testCapacity)
    }
    
    func fillInSourceArray(capacity: Int){
        source = [[Int]]()
        var content = [Int]()
        for i in 0..<capacity{
            content.insert(Int.random(in: 1...20), at: i)
        }
        source = [content]
    }
    
    func fillInArrayForTesting(capacity: Int){
        arrayForTesting = [Int]()
        for i in 0..<capacity{
            arrayForTesting.insert(Int.random(in: 1...1000), at: i)
        }
    }
    
    func ascendentFillInArrayForTesting(capacity: Int){
        arrayForTesting = [Int]()
        let start = Int.random(in: 1...1000)
        let step = Int.random(in: 2...50)
        let finish = step * capacity + start
        for i in stride(from: start, through: finish, by: step){
            arrayForTesting.append(i)
        }
    }
    
    func descendentFillInArrayForTesting(capacity: Int){
        arrayForTesting = [Int]()
        let start = Int.random(in: 1...1000)
        let step = Int.random(in: 2...50)
        let finish = start - (step * capacity)
        for i in stride(from: start, through: finish, by: -step){
            arrayForTesting.append(i)
        }
    }
    
    func partiallyOrderedFillInArrayForTesting(capacity: Int){
        let randomPart = capacity * 15 / 100
        let orderedPart = capacity * 85 / 100
        ascendentFillInArrayForTesting(capacity: orderedPart)
        var holder = [Int]()
        for _ in 0..<randomPart{
            holder.append(Int.random(in: 3500...5000))
        }
        arrayForTesting += holder
    }
    
    @discardableResult func machineSort() -> [Int]{
        return []
    }

}
