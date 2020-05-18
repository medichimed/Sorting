//
//  OperationItemClass.swift
//  task10
//
//  Created by Oksana Kotilevska on 1/15/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import Foundation

class MyOperation: Operation {
    private var sort: VisualisationViewController.SortType
    private var order: StatisticsPageViewController.TestingArrayType
    
    private var target = BasicModel()
    private var dataHolder = DataHolder()
    private var efficiencyArray = [TimeInterval]()
    private let numberOfStatisticsChecks = 50
    
    private var completionHandler: (_ averageTime: [Double]) -> ()
    
    init(sort: VisualisationViewController.SortType, order: StatisticsPageViewController.TestingArrayType, dataHolder: DataHolder, completionHandler: @escaping (_ averageTime: [Double]) -> ()) {
        self.sort = sort
        self.order = order
        self.dataHolder = dataHolder
        self.completionHandler = completionHandler
    }
    
    override func main() {
        
        if isCancelled{
            return
        }
        
        let capacity = [100, 400, 800]
        var result = [Double]()
        
        switch sort{
        case .bubble: target = Bubble()
        case .quick: target = Quick()
        case .insertion: target = Insertion()
        case .merge: target = Merge()
        default: break
        }
        
        for i in capacity{
            
            for j in 0..<numberOfStatisticsChecks{
                
                switch i {
                case 100:
                    switch order{
                    case .random: target.arrayForTesting = dataHolder.randomlyGeneratedDataSource.oneHundredArray[j]
                    case .ascendent: target.arrayForTesting = dataHolder.ascendentlyGeneratedDataSource.oneHundredArray[j]
                    case .descendent: target.arrayForTesting = dataHolder.descendentlyGeneratedDataSource.oneHundredArray[j]
                    case .partiallyOrdered: target.arrayForTesting = dataHolder.partiallyRandomlyGeneratedDataSource.oneHundredArray[j]
                        
                    }
                case 400:
                    switch order{
                    case .random: target.arrayForTesting = dataHolder.randomlyGeneratedDataSource.fourHundredsArray[j]
                    case .ascendent: target.arrayForTesting = dataHolder.ascendentlyGeneratedDataSource.fourHundredsArray[j]
                    case .descendent: target.arrayForTesting = dataHolder.descendentlyGeneratedDataSource.fourHundredsArray[j]
                    case .partiallyOrdered: target.arrayForTesting = dataHolder.partiallyRandomlyGeneratedDataSource.fourHundredsArray[j]
                        
                    }
                    
                case 800:
                    switch order{
                    case .random: target.arrayForTesting = dataHolder.randomlyGeneratedDataSource.eightHundredsArray[j]
                    case .ascendent: target.arrayForTesting = dataHolder.ascendentlyGeneratedDataSource.eightHundredsArray[j]
                    case .descendent: target.arrayForTesting = dataHolder.descendentlyGeneratedDataSource.eightHundredsArray[j]
                    case .partiallyOrdered: target.arrayForTesting = dataHolder.partiallyRandomlyGeneratedDataSource.eightHundredsArray[j]
                    }
                default: break
                }
                
                let start = Date()
                target.machineSort()
                let diff = start.distance(to: Date())
                
                efficiencyArray.append(diff)
            }
            
            let generalTime = efficiencyArray.reduce(0, +)
            let averageTime = generalTime/50
            
            if isCancelled{
                return
            }
            
            result.append(averageTime)
        }
        
        if isCancelled{
            return
        }
        
        completionHandler(result)
    }

}
