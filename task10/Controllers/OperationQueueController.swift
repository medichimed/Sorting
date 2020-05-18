//
//  OperationQueueStatisticsViewController.swift
//  task10
//
//  Created by Oksana Kotilevska on 1/15/20.
//  Copyright © 2020 Oksana Kotilevska. All rights reserved.
//

import UIKit

class OperationQueueController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var activityIndicatorView: UIActivityIndicatorView!
    
    
    //MARK: - Properties
    var target = BasicModel()
    var dataSource = [DataModel]()
    var dataHolder = DataHolder()
    let testCaseQuantity = 3
    
    let statisticsQueue = OperationQueue()
    
    //MARK: - viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundView = UIView()
        progressView.isHidden = true
        activityIndicatorView.isHidden = true
        
        statisticsQueue.maxConcurrentOperationCount = 4
        createDataForMeasurements()
    }

    deinit {
        for operation in statisticsQueue.operations{
            operation.cancel()
        }
    }
    
    //MARK: - Action
    @IBAction func start(_ sender: UIButton) {
        
        sender.isEnabled = false
        sender.setTitleColor(UIColor.systemGray, for: .normal)
        progressView.setProgress(0.0, animated: false)
        progressView.isHidden = false
        activityIndicatorView.isHidden = false
        activityIndicatorView.startAnimating()
        
        dataSource = []
        
        OperationQueue.main.addOperation {
            self.tableView.reloadData()
        }
        
        let sortType: [VisualisationViewController.SortType] = [.bubble, .quick, .insertion, .merge]
        let requiredDataArray: [StatisticsPageViewController.TestingArrayType] = [.random, .ascendent, .descendent, .partiallyOrdered]
        
        for sort in sortType{
            for array in requiredDataArray{
                mesureEffectiveness(sortingType: sort, requiredDataArray: array)
            }
        }
    }
    
    @IBAction func stop(_ sender: UIButton) {

        for operation in statisticsQueue.operations{
            operation.cancel()
        }
        
        sender.isEnabled = false
        sender.setTitleColor(UIColor.systemGray, for: .normal)
    }
    
    //MARK: - Functions
func mesureEffectiveness(sortingType: VisualisationViewController.SortType, requiredDataArray: StatisticsPageViewController.TestingArrayType){

    var result = [Double]()
    
    let operation = MyOperation(sort: sortingType, order: requiredDataArray, dataHolder: dataHolder) { [weak self]
    (averageTime) in
        
        result = averageTime
                
        let convertedString = self!.formatResult(result[0], result[1], result[2])
                
        let header = "\(sortingType.rawValue) sort on \(requiredDataArray.rawValue) array"
                
        let newDataStructure = DataModel(header: header, oneHundredResult: convertedString[0], fourHundredsResult: convertedString[1], eightHundredsResult: convertedString[2])
                
        let sectionIdentifier = self!.dataSource.count
        
        self!.dataSource.append(newDataStructure)
                
        OperationQueue.main.addOperation {
            self!.activityIndicatorView.isHidden = true
            self!.activityIndicatorView.stopAnimating()
            self!.tableView.performBatchUpdates({ [weak self] in
                self?.tableView.insertSections([sectionIdentifier], with: .fade)
                self?.tableView.insertRows(at: [IndexPath(row: 0, section: sectionIdentifier), IndexPath(row: 1, section: sectionIdentifier), IndexPath(row: 2, section: sectionIdentifier)], with: .fade)
                self?.progressView.setProgress(self!.progressView.progress + (1.0/16.0), animated: true)
                })
            }
        }
    
    statisticsQueue.addOperation(operation)
    
    }
    
   private func createDataForMeasurements(){
        let types: [StatisticsPageViewController.TestingArrayType] = [.random, .ascendent, .descendent, .partiallyOrdered]
        for i in types{
            generateRequiredData(typeOfRequiredArray: i)
        }

    }
    
    private func generateRequiredData(typeOfRequiredArray: StatisticsPageViewController.TestingArrayType){
        
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
    
  private func distributionDependingOnCapacity(capacity: Int, targetDataSourceItem: inout GeneratedData) {
        
        switch capacity{
        case 100: targetDataSourceItem.oneHundredArray.append(target.arrayForTesting)
        case 400: targetDataSourceItem.fourHundredsArray.append(target.arrayForTesting)
        case 800: targetDataSourceItem.eightHundredsArray.append(target.arrayForTesting)
        default: print("WTF?")
        }
        
    }
    
    private func formatResult(_ num1: Double, _ num2: Double, _ num3: Double) -> [String] {
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "operationCell", for: indexPath) as! OperationQueueCell
        
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
    
}




