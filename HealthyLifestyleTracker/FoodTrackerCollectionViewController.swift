//
//  FoodTrackerCollectionViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/2/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit
import CoreData

private let reuseIdentifier = "FoodTrackerCollectionViewCell"

class FoodTrackerCollectionViewController: UICollectionViewController {
    
    let HEADER_VIEW: String = "HeaderView"
    let FOOD_TRACKER_CATEGORY: String = "FoodTrackerCategory"
    let FOOD_TRACKER_ENTRY: String = "FoodTrackerEntry"

    var foodTrackerData : [NSManagedObject]
    
    init(collectionViewLayout: UICollectionViewLayout, foodTrackerData: [NSManagedObject]) {
        self.foodTrackerData = foodTrackerData
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        foodTrackerData = [NSManagedObject]() 
        
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView!.register(FoodTrackerCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        self.collectionView!.backgroundColor = UIColor.clear
        
        let foodTrackerHeaderNib = UINib(nibName: "FoodTrackerHeaderCollectionReusableView", bundle: nil)
        self.collectionView!.register(foodTrackerHeaderNib, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: HEADER_VIEW)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return self.foodTrackerData.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if(foodTrackerData.count > indexPath.section) {
            let foodTrackerCategory = foodTrackerData[indexPath.section]
            
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_VIEW, for: indexPath) as! FoodTrackerHeaderCollectionReusableView
                headerView.setLeftLabel(text: foodTrackerCategory.value(forKey: "name") as! String)
                headerView.setRightLabel(text: foodTrackerCategory.value(forKey: "helpText") as! String)
                return headerView
            default:
                assert(false, "Unexpected Element")
            }
        }
        
        assert(false, "Unexpected Element")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (foodTrackerData.count > section) {
            let foodTrackerCategory = foodTrackerData[section]
            return foodTrackerCategory.value(forKey: "maxValue") as! Int
        }
        
        return 10
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FoodTrackerCollectionViewCell
        
        cell.labelText = String(indexPath.row + 1)
        
        if indexPath.item == 0 {
            cell.isFirstItem = true
        }
        
        if indexPath.item == 9 {
            cell.isLastItem = true
        }
        
        if(foodTrackerData.count > indexPath.section) {
            let foodTrackerCategory = foodTrackerData[indexPath.section]
            
            if (indexPath.item == foodTrackerCategory.value(forKey: "dailyGoal") as! Int) {
                cell.backgroundColor = UIColor.green
            }
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return cell
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            let entry = self.fetchCurrentEntryForCategory(named: foodTrackerCategory.value(forKey: "name") as! String, fromContext: managedContext)
            let entryValue: Int = (entry.value(forKey: "value") as! NSNumber).intValue
            
            if (entryValue > indexPath.item) {
                cell.backgroundColor = UIColor.darkGray
            } else {
                cell.backgroundColor = UIColor.lightGray
            }
            
            if (indexPath.item == (foodTrackerCategory.value(forKey: "dailyGoal") as! Int) - 1) {
                cell.backgroundColor = UIColor.green
            }
        }
        
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(foodTrackerData.count > indexPath.section) {
            let foodTrackerCategory = foodTrackerData[indexPath.section]
            
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            
            let managedContext = appDelegate.persistentContainer.viewContext
            
            var entry: NSManagedObject = self.fetchCurrentEntryForCategory(named: foodTrackerCategory.value(forKey: "name") as! String, fromContext: managedContext)
            let entryValue: Int = (entry.value(forKey: "value") as! NSNumber).intValue
            
            var newValue: Int = 0
            
            if (entryValue <= indexPath.item) {
                newValue = entryValue + 1
            } else {
                newValue = entryValue - 1
            }
            
            entry.setValue(NSNumber(integerLiteral: newValue), forKey: "value")
            
            do {
                try managedContext.save()
            } catch _ as NSError {
                sendAlert(message: "There was an error creating an entry for today.")
            }
        }
        
        self.collectionView?.reloadData()
        
    }
    
    private func fetchCurrentEntryForCategory(named categoryName: String, fromContext context:NSManagedObjectContext) -> NSManagedObject {
        
        let categoryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FOOD_TRACKER_CATEGORY)
        categoryFetchRequest.predicate = NSPredicate(format: "name == %@", categoryName)
        
        var currentEntry: NSManagedObject = NSManagedObject()
        
        do {
            let results = try context.fetch(categoryFetchRequest)
            if (results.count > 0) {
                let category = results[0] as! NSManagedObject
                let currentEntryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:FOOD_TRACKER_ENTRY)
                
                let today = Date()
                let formatter = DateFormatter()
                formatter.dateFormat = "dd.mm.yyyy"
                let resultDate = formatter.string(from: today)
                
                currentEntryFetchRequest.predicate = NSPredicate(format: "date == %@ AND category == %@", resultDate, category)
                
                let entryResults = try context.fetch(currentEntryFetchRequest)
                if (entryResults.count > 0) {
                    currentEntry = entryResults[0] as! NSManagedObject
                } else {
                    currentEntry = createNewEntryFor(category: category, inContext: context)
                }
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return currentEntry
    }

    private func createNewEntryFor(category: NSManagedObject, inContext context: NSManagedObjectContext) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: FOOD_TRACKER_ENTRY, in: context)
        
        let entry = NSManagedObject(entity: entity!, insertInto: context)
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.mm.yyyy"
        let resultDate = formatter.string(from: today)
        
        entry.setValue(resultDate, forKey: "date")
        entry.setValue(NSNumber(integerLiteral: 0), forKey: "value")
        entry.setValue(category, forKey: "category")
        
        do {
            try context.save()
        } catch _ as NSError {
            sendAlert(message: "There was an error creating an entry for today.")
        }
        
        return entry
    }
    
    private func sendAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
