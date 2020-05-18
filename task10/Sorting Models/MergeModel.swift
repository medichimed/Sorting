//
//  MergeModel.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/16/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import Foundation

class Merge: BasicModel {
    
    var flag = false
    var mergeStage = false
    var storedTail = [[Int]]()
    var storedHead = [[Int]]()
    var start = 0
    var maxCapacity = 0
    
    @discardableResult func sort() -> ( [Int] , [Int], Bool){
        
        if !flag{
            maxCapacity = source[0].count
            flag = true
        }
        
        var initialNumberOfSubarrays = source.count
        var workingIndex = start
        
        if !mergeStage{
            
            if start == maxCapacity{
                mergeStage = true
                return sort()
            }
            
            var storedTail = [[Int]]()
            
            if source[start].count == 1{
                storedHead.append([source[start][0]])
                start += 1
                return sort()
            }else{
                if source.count - (start + 1) >= 1{
                    for i in start + 1 ..< source.count{
                        storedTail.append(source[i])
                    }
                }
                
                let middleIndex = source[start].count / 2
                
                var firstPart: [Int]{
                    var container = [Int]()
                    for i in 0..<middleIndex{
                        container.append(source[start][i])
                    }
                    return container
                }
                
                var secondPart: [Int]{
                    var container = [Int]()
                    for i in middleIndex..<source[start].count{
                        container.append(source[start][i])
                    }
                    return container
                }
                
                source = storedHead + [firstPart] + [secondPart] + storedTail
            }
            
            let indexArray = getIndexesSetForTableView(initialNumberOfSubarrays: initialNumberOfSubarrays, workingIndex: &workingIndex)
            return (indexArray,[0], mergeStage)
            
        }else{
            let sourceCount = source.count
            var mergedArray = [[Int]]()
            var limit = 0
            var oneLeft: Bool{
                return source.count % 2 != 0
            }
            var container = [[Int]]()
            
            if source.count % 2 == 0{
                limit = source.count
            }else{
                limit = source.count - 1
            }
            
            for i in stride(from: 0, to: limit, by: 2){
                mergedArray.append(mergeEntities(firstItem: source[i], secondItem: source[i+1]))
            }
            
            if oneLeft{
                container = [source[source.count - 1]]
                source = mergedArray + container
            }else{
                source = mergedArray
            }
            
            var result = [Int]()
            for i in 0..<sourceCount{
                result.append(i)
            }
            
            var indexesAfterMerge = [Int]()
            for i in 0..<source.count{
                indexesAfterMerge.append(i)
            }
            
            return (result, indexesAfterMerge, mergeStage)
        }
    }
    
    @discardableResult override func machineSort() -> [Int] {
        
        func mergeSort(_ array: [Int]) -> [Int] {
          guard array.count > 1 else { return array }

          let middleIndex = array.count / 2

          let leftArray = mergeSort(Array(array[0..<middleIndex]))
          let rightArray = mergeSort(Array(array[middleIndex..<array.count]))

          return merge(leftArray, rightArray)
        }

        func merge(_ left: [Int], _ right: [Int]) -> [Int] {
          var leftIndex = 0
          var rightIndex = 0

          var orderedArray: [Int] = []

          while leftIndex < left.count && rightIndex < right.count {
            let leftElement = left[leftIndex]
            let rightElement = right[rightIndex]

            if leftElement < rightElement {
              orderedArray.append(leftElement)
              leftIndex += 1
            } else if leftElement > rightElement {
              orderedArray.append(rightElement)
              rightIndex += 1
            } else {
              orderedArray.append(leftElement)
              leftIndex += 1
              orderedArray.append(rightElement)
              rightIndex += 1
            }
          }

          while leftIndex < left.count {
            orderedArray.append(left[leftIndex])
            leftIndex += 1
          }

          while rightIndex < right.count {
            orderedArray.append(right[rightIndex])
            rightIndex += 1
          }

          return orderedArray
        }

        return mergeSort(arrayForTesting)
    }
}



extension Merge{
    
    func mergeEntities(firstItem: [Int], secondItem: [Int]) -> [Int]{
        var emptyArray = [Int]()
        var i = 0
        var j = 0
        
        while i < firstItem.count && j < secondItem.count{
            if firstItem[i] > secondItem[j]{
                emptyArray.append(secondItem[j])
                j += 1
            }else{
                emptyArray.append(firstItem[i])
                i += 1
            }
        }
        
        if i != firstItem.count{
            emptyArray.append(contentsOf: firstItem[i..<firstItem.count])
        }
        
        if j != secondItem.count{
            emptyArray.append(contentsOf: secondItem[j..<secondItem.count])
        }
        
        return emptyArray
    }
    
    func getIndexesSetForTableView(initialNumberOfSubarrays: Int, workingIndex: inout Int) -> [Int]{
        var result = [Int]()
        
        let differenceInSubArrayQuantity = source.count - initialNumberOfSubarrays
        
        for _ in 0...differenceInSubArrayQuantity{
            result.append(workingIndex)
            workingIndex += 1
        }
        return result
    }
}
