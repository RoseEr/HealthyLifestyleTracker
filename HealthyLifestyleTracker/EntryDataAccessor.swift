//
//  EntryDataAccessor.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/25/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit
import CoreData

class EntryDataAccessor: NSObject {
    
    private var categoryNameToCurrentEntryMap: [String: Entry] = [String: Entry]()
    private var categoryDataAccessor: CategoryDataAccessor?
    
    var currentCalorieValue: Int {
        get {
            var totalCalories = 0
            guard let categoryDA = self.categoryDataAccessor else {
                return totalCalories
            }
            
            self.updateCurrentEntriesMap()
            
            for category in categoryDA.retrieveCategories() {
                if let entry = categoryNameToCurrentEntryMap[category.name] {
                    totalCalories += (category.calorieValue * entry.value)
                }
            }
            
            return totalCalories
        }
    }
    
    convenience init(categoryDataAccessor: CategoryDataAccessor) {
        self.init()
        self.categoryDataAccessor = categoryDataAccessor
    }
    
    override init() {
        super.init()
    }
    
    func retrieveCurrentEntryForCategory(category: Category) -> Entry {
        let returnEntry = Entry(managedObject: fetchCurrentEntryOrCreateEntryForCategory(category: category))
        self.categoryNameToCurrentEntryMap[category.name] = returnEntry
        return returnEntry
    }
    
    func updateValueForEntry(entry: Entry, newValue: Int) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        if newValue < 0 {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entryAsManagedObject = self.fetchCurrentEntryOrCreateEntryForCategory(category: entry.category)
        
        entryAsManagedObject.setValue(NSNumber(integerLiteral: newValue), forKey: "value")
        
        do {
            try managedContext.save()
        } catch _ as NSError {
            return
        }
    }
    
    private func updateCurrentEntriesMap() {
        if let categoryDA = self.categoryDataAccessor {
            let categories = categoryDA.retrieveCategories()
        
            for category in categories {
                _ = self.retrieveCurrentEntryForCategory(category: category)
            }
        }
    }

    private func fetchCurrentEntryOrCreateEntryForCategory(category: Category) -> NSManagedObject {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObject()
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        var currentEntry: NSManagedObject = NSManagedObject()
        
        let categoryAccessor = CategoryDataAccessor()
        
        let categoryAsManagedObject = categoryAccessor.retrieveCategoryAsManagedObject(category: category)
        
        let today = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        let resultDate = formatter.string(from: today)
        
        let currentEntryFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:Entry.FOOD_TRACKER_ENTRY)
        currentEntryFetchRequest.predicate = NSPredicate(format: "date == %@ AND category == %@", resultDate, categoryAsManagedObject)
        
        do {
            let entryResults = try managedContext.fetch(currentEntryFetchRequest)
            if (entryResults.count > 0) {
                currentEntry = entryResults[0] as! NSManagedObject
            } else {
                currentEntry = self.createNewEntryFor(category: categoryAsManagedObject, inContext: managedContext)
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return currentEntry
    }
    
    private func createNewEntryFor(category: NSManagedObject, inContext context: NSManagedObjectContext) -> NSManagedObject {
        let entity = NSEntityDescription.entity(forEntityName: Entry.FOOD_TRACKER_ENTRY, in: context)
        
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
            return NSManagedObject()
        }
        
        return entry
    }
}


class Entry: NSObject {
    
    static let FOOD_TRACKER_ENTRY: String = "FoodTrackerEntry"
    
    var date: String = ""
    var value: Int = 0
    var category: Category = Category()
    
    convenience init(managedObject: NSManagedObject) {
        self.init()
        
        if let managedObjectDate = managedObject.value(forKey: "date") as? String {
            self.date = managedObjectDate
        }
        
        if let managedObjectValue = managedObject.value(forKey: "value") as? Int {
            self.value = managedObjectValue
        }
        
        if let managedObjectCategory = managedObject.value(forKey: "category") as? NSManagedObject {
            self.category = Category(managedObject: managedObjectCategory)
        }
    }
}
