//
//  QuickModel.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/16/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import Foundation

class Quick: BasicModel{

    var start = 0
    var onRightPlace = [[Int]]()
    
    @discardableResult func sort() -> ([Int]){

        if isSorted(){
            return ([-1])
        }
        
        if source.count <= start{
            return([-1])
        }
        
        var lengthDifference = source.count
        
        let pivot = source[start][0]
        var i = 0
        var workingIndex = start
        var storedTail = [[Int]]()
        var more = [Int]()
        var middle = [Int]()
        var less = [Int]()

        while i != source[start].count {
            if source[start][i] < pivot{
                less.append(source[start][i])
                i += 1
            }else if source[start][i] > pivot{
                more.append(source[start][i])
                i += 1
            }else{
                middle.append(source[start][i])
                i += 1
            }
        }

        if start <= source.count - 2 {
           for i in start + 1 ..< source.count{
               storedTail.append(source[i])
           }
        }

        let index = onRightPlace.count
        
        if less.count == 0{
            onRightPlace.insert(middle, at: index)
            source = onRightPlace
            if !more.isEmpty{
               storedTail.insert(more, at: 0)
            }

            if !storedTail.isEmpty{
                source += storedTail
            }
            start += 1
        }else if less.count == 1{
            
            onRightPlace.insert(less, at: index)
            onRightPlace.insert(middle, at: index + 1 )
            source = onRightPlace
            if !more.isEmpty{
                source += [more]
            }
            if !storedTail.isEmpty{
                source += storedTail
            }
            start += 2
        }else{

            source = onRightPlace + [less] + [middle]
            if !more.isEmpty{
                source += [more]
            }
            if !storedTail.isEmpty{
                source += storedTail
            }
        }
        lengthDifference = source.count - lengthDifference
        
        var result = [Int]()

        for _ in 0...lengthDifference{
            result.append(workingIndex)
            workingIndex += 1
        }
        
        return(result)
    }
    
    private func isSorted() -> Bool{
        let copyToCheck = source.reduce([Int]()) { $0 + $1  }
        
        for i in 0..<copyToCheck.count-1 {
            if copyToCheck[i] > copyToCheck[i + 1]{
                return false
            }
        }
        return true
    }
    
    @discardableResult override func machineSort() -> [Int] {
        func quicksortLomuto(_ a: inout [Int], low: Int, high: Int) {
            if low < high {
                let p = partitionLomuto(&a, low: low, high: high)
                quicksortLomuto(&a, low: low, high: p - 1)
                quicksortLomuto(&a, low: p + 1, high: high)
            }
        }

        func partitionLomuto(_ a: inout [Int], low: Int, high: Int) -> Int {
          let pivot = a[high]

          var i = low
          for j in low..<high {
            if a[j] <= pivot {
              a.swapAt(i, j)
              i += 1
            }
          }

          a.swapAt(i, high)
          return i
        }
        
       quicksortLomuto(&arrayForTesting, low: 0, high: arrayForTesting.count - 1)
       return arrayForTesting
    }
}

