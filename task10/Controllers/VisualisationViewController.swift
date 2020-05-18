//
//  SecondPageViewController.swift
//  task10
//
//  Created by Oksana Kotilevska on 12/16/19.
//  Copyright © 2019 Oksana Kotilevska. All rights reserved.
//

import UIKit

class VisualisationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var nextButton: UIButton!
    
    //MARK: - Properties
    var sortingMethod = BasicModel(capacity: 10)
    private var sortType = SortType.none
    var dataSource = [[Int]]()
    
    //MARK: - ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        updateDataSource()
    }
    
    //MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource[section].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "myCell")!
        cell.textLabel?.text = "\(dataSource[indexPath.section][indexPath.row])"
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dataSource.count
    }
    
    //MARK: - Fuctions
    
    func updateDataSource(){
        dataSource = sortingMethod.source
    }
    
    //MARK: - Actions
    @IBAction func nextTapped(_ sender: Any) {
        var (a, b) = (0, 0)
        var indexSet = [Int]()
        var indexesAfterMerge = [Int]()
        var mergeStage = false
        
        switch sortType{
        case .bubble: (a, b) = (sortingMethod as! Bubble).sort()
        case .quick: (indexSet) = (sortingMethod as! Quick).sort()
        case .insertion: (a, b) = (sortingMethod as! Insertion).sort()
        case .merge: (indexSet ,indexesAfterMerge , mergeStage) = (sortingMethod as! Merge).sort()
        case .none: print("Nothing has been chosen")
        }
        
        switch sortType{
        case .bubble, .insertion:
            updateDataSource()
            
            let firstIndexPath = IndexPath(item: a, section: 0)
            let secondIndexPath = IndexPath(item: b, section: 0)
            
            tableView.beginUpdates()
            tableView.moveRow(at: firstIndexPath, to: secondIndexPath)
            tableView.endUpdates()
            
        case .quick:
            updateDataSource()
            
            if indexSet[0] == -1{
                let updatedArray = dataSource.reduce([Int]()){$0 + $1}
                dataSource = [updatedArray]
                tableView.reloadData()
            }else{
                tableView.performBatchUpdates({
                    tableView.deleteSections([indexSet[0]], with: .fade)
                    tableView.insertSections(IndexSet(indexSet), with: .fade)
                }, completion: nil)
            }

        case .merge:
            updateDataSource()
            
            if mergeStage{
                tableView.performBatchUpdates({
                    tableView.deleteSections(IndexSet(indexSet), with: .fade)
                    tableView.insertSections(IndexSet(indexesAfterMerge), with: .fade)
                }, completion: nil)
            } else{

                tableView.performBatchUpdates({
                    tableView.deleteSections([indexSet[0]], with: .fade)
                    tableView.insertSections(IndexSet(indexSet), with: .fade)
                }, completion: nil)
            }

        case .none: print("Do nothing")
        }
    }
    
    @IBAction func segmentTapped(_ sender: UISegmentedControl) {
        nextButton.isHidden = false
        if sortType != .none{
            sortingMethod.fillInSourceArray(capacity: 10)
            updateDataSource()
            tableView.reloadData()
        }
        
        let source = sortingMethod.source
        switch sender.selectedSegmentIndex{
        case 0:
            sortingMethod = Bubble()
            sortType = .bubble
        case 1:
            sortingMethod = Quick()
            sortType = .quick
        case 2:
            sortingMethod = Insertion()
            sortType = .insertion
        case 3:
            sortingMethod = Merge()
            sortType = .merge
        default:
            print("shit happens")
        }
        sortingMethod.source = source
    }
    
    enum SortType: String{
        case none
        case bubble = "Bubble"
        case quick = "Quick"
        case insertion = "Insertion"
        case merge = "Merge"
    }
    
}


