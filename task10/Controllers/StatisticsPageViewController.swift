//
//  SecondPageViewController.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/23/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import UIKit

class StatisticsPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressOutlet: UIProgressView!
    @IBOutlet weak var startButton: UIButton!
    
    
    //MARK: - Properties
    var target = BasicModel()
    var dataSource = [DataModel]()
    var dataHolder = DataHolder()
    let testCaseQuantity = 3
    let numberOfStatisticsChecks = 50
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createDataForMeasurements()
    }
    //MARK: - Action
    @IBAction func start(_ sender: UIButton) {
        progressOutlet.setProgress(0.0, animated: false)
        progressOutlet.isHidden = false
        sender.isHidden = true
        
        dataSource = []
        tableView.reloadData()
        
        DispatchQueue.global(qos: .background).async{ [weak self] in
            self?.prepareDataSource(targetArrayType: .random, sectionsSet: [0,1,2,3])
            self?.prepareDataSource(targetArrayType: .ascendent, sectionsSet: [4,5,6,7])
            self?.prepareDataSource(targetArrayType: .descendent, sectionsSet: [8,9,10,11])
            self?.prepareDataSource(targetArrayType: .partiallyOrdered, sectionsSet: [12,13,14,15])
        }
        
    }
    
    //MARK: - Functions
    @discardableResult func mesureEffectiveness(sortingType: VisualisationViewController.SortType, requiredDataArray: TestingArrayType) -> (first: Double, second: Double, third: Double){
        let capacity = [100, 400, 800]
        var result = [Double]()
        var efficiencyArray = [TimeInterval]()

        switch sortingType{
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
                    switch requiredDataArray{
                    case .random: target.arrayForTesting = dataHolder.randomlyGeneratedDataSource.oneHundredArray[j]
                        
                    case .ascendent: target.arrayForTesting = dataHolder.ascendentlyGeneratedDataSource.oneHundredArray[j]
                        
                    case .descendent: target.arrayForTesting = dataHolder.descendentlyGeneratedDataSource.oneHundredArray[j]
                        
                    case .partiallyOrdered: target.arrayForTesting = dataHolder.partiallyRandomlyGeneratedDataSource.oneHundredArray[j]
                        
                    }
                case 400:
                    switch requiredDataArray{
                    case .random: target.arrayForTesting = dataHolder.randomlyGeneratedDataSource.fourHundredsArray[j]
                        
                    case .ascendent: target.arrayForTesting = dataHolder.ascendentlyGeneratedDataSource.fourHundredsArray[j]
                        
                    case .descendent: target.arrayForTesting = dataHolder.descendentlyGeneratedDataSource.fourHundredsArray[j]
                        
                    case .partiallyOrdered: target.arrayForTesting = dataHolder.partiallyRandomlyGeneratedDataSource.fourHundredsArray[j]
                        
                    }
                    
                case 800:
                    switch requiredDataArray{
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
            result.append(generalTime/50)
        }
        
        return(result[0], result[1], result[2])
    }
    
    func prepareDataSource(targetArrayType: TestingArrayType, sectionsSet: [Int]){
        let sortingtypeSource: [VisualisationViewController.SortType] = [.bubble, .insertion, .quick, .merge]
        
        for i in 0..<sectionsSet.count{
            prepareSpecificSection(sectionIndex: sectionsSet[i], sortingType: sortingtypeSource[i], targetArrayType: targetArrayType)
            DispatchQueue.main.async { [weak self] in
                self?.progressOutlet.setProgress(self!.progressOutlet.progress + (1.0/16.0), animated: true)
            }
        }
    }
    
    func prepareSpecificSection(sectionIndex: Int, sortingType: VisualisationViewController.SortType, targetArrayType: TestingArrayType){
        let (first, second, third) = mesureEffectiveness(sortingType: sortingType, requiredDataArray: targetArrayType)
        let convertedString = formatResult(first, second, third)
        
        let header = "\(sortingType.rawValue) sort on \(targetArrayType.rawValue) array"
        let newDataStructure = DataModel(header: header, oneHundredResult: convertedString[0], fourHundredsResult: convertedString[1], eightHundredsResult: convertedString[2])
        dataSource.append(newDataStructure)
        
        DispatchQueue.main.async { [weak self] in
            self?.tableView.performBatchUpdates({
                self?.tableView.insertSections([sectionIndex], with: .fade)
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: sectionIndex), IndexPath(row: 1, section: sectionIndex), IndexPath(row: 2, section: sectionIndex)], with: .fade)
            }, completion: nil)
        }
    }
    
    func createDataForMeasurements(){
        let types: [TestingArrayType] = [.random, .ascendent, .descendent, .partiallyOrdered]
        for i in types{
            generateRequiredData(typeOfRequiredArray: i)
        }
        
        startButton.isHidden = false
    }
    
    func generateRequiredData(typeOfRequiredArray: TestingArrayType){
        
        let capacity = [100, 400, 800]
        for i in capacity{
            for _ in 0..<50{
                switch typeOfRequiredArray{
                case .random:
                    target.fillInArrayForTesting(capacity: i)
                    distributionDependingOnCapacity(capacity: i, targetDataSourceItem: &dataHolder.randomlyGeneratedDataSource)
                case .ascendent:
                    target.ascendentFillInArrayForTesting(capacity: i)
                    distributionDependingOnCapacity(capacity: i, targetDataSourceItem: &dataHolder.ascendentlyGeneratedDataSource)
                case .descendent:
                    target.descendentFillInArrayForTesting(capacity: i)
                    distributionDependingOnCapacity(capacity: i, targetDataSourceItem: &dataHolder.descendentlyGeneratedDataSource)
                case .partiallyOrdered:
                    target.partiallyOrderedFillInArrayForTesting(capacity: i)
                    distributionDependingOnCapacity(capacity: i, targetDataSourceItem: &dataHolder.partiallyRandomlyGeneratedDataSource)
                }
            }
        }
    }
    
    func distributionDependingOnCapacity(capacity: Int, targetDataSourceItem: inout GeneratedData){
        
        switch capacity{
        case 100: targetDataSourceItem.oneHundredArray.append(target.arrayForTesting)
        case 400: targetDataSourceItem.fourHundredsArray.append(target.arrayForTesting)
        case 800: targetDataSourceItem.eightHundredsArray.append(target.arrayForTesting)
        default: break
        }
        
    }
    
    func formatResult(_ num1: Double, _ num2: Double, _ num3: Double)->[String]{
        var result = [String]()
        let formatter = NumberFormatter()
        formatter.usesSignificantDigits = true
        formatter.minimumSignificantDigits = 2
        formatter.maximumSignificantDigits = 5
        
        result.append(formatter.string(from: NSNumber(value: num1))!)
        result.append(formatter.string(from: NSNumber(value: num2))!)
        result.append(formatter.string(from: NSNumber(value: num3))!)
        return result
    }
    
    //MARK: - UITableViewDataSource stuff
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return testCaseQuantity
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "secondCell", for: indexPath) as! StatisticsCell
        
        switch indexPath.row{
        case 0:
            cell.capacityLabel.text = "-> 100 el.:"
            cell.efficiencyLabel.text = dataSource[indexPath.section].oneHundredResult + " sec."
        case 1:
            cell.capacityLabel.text = "-> 400 el.:"
            cell.efficiencyLabel.text = dataSource[indexPath.section].fourHundredsResult + " sec."
        case 2:
            cell.capacityLabel.text = "-> 800 el.:"
            cell.efficiencyLabel.text = dataSource[indexPath.section].eightHundredsResult + " sec."
        default: break
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return dataSource[section].header
    }
    
    //MARK: - Another stuff
    enum TestingArrayType: String{
        case random = "Random"
        case descendent = "Descendent"
        case ascendent = "Ascendent"
        case partiallyOrdered = "Partially Ordered"
    }
    
}
