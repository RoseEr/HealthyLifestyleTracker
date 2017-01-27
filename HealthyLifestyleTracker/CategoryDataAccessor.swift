//
//  CategoryDataAccessor.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/25/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit
import CoreData

class CategoryDataAccessor: NSObject {
    
    static let FOOD_TRACKER_CATEGORY: String = "FoodTrackerCategory"
    
    private var categories: [Category] = [Category]()
    private var categoriesAsManagedObjects: [String: NSManagedObject] = [String: NSManagedObject]()
    
    var totalCalorieGoal: Int {
        get {
            var calorieGoal = 0
            for category in categories {
                calorieGoal += (category.calorieValue * category.dailyGoal)
            }
            
            return calorieGoal
        }
    }
    
    override init() {
        super.init()
        self.categories = self.setupCategories()
    }
    
    func addCategory(category: Category) {
        self.insertCategory(category: category)
        
        var mutableCategories = self.categories
        mutableCategories.append(category)
        self.categories = mutableCategories
    }
    
    func retrieveCategories() -> [Category] {
        if self.categories.count == 0 {
            self.categories = setupCategories()
        }
        
        return self.categories
    }
    
    func retrieveCategoryAsManagedObject(category: Category) -> NSManagedObject {
        if (self.categoriesAsManagedObjects[category.name] != nil) {
            return self.categoriesAsManagedObjects[category.name]!
        }
        
        return fetchCategory(category: category)
    }
    
    private func insertCategory(category: Category) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: Category.FOOD_TRACKER_CATEGORY, in: managedContext)
        
        let categoryManagedObject = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        categoryManagedObject.setValue(category.name, forKey: "name")
        categoryManagedObject.setValue(category.dailyGoal, forKey: "dailyGoal")
        categoryManagedObject.setValue(category.helpText, forKey: "helpText")
        categoryManagedObject.setValue(category.maxValue, forKey: "maxValue")
        categoryManagedObject.setValue(category.calorieValue, forKey: "calorieValue")
        
        do {
            try managedContext.save()
        } catch _ as NSError {
            return
        }
    }
    
    private func setupCategories() -> [Category]{
        let categoryManagedObjects = fetchCategories()
        
        var mutableCategories = [Category]()
        
        for categoryManagedObject in categoryManagedObjects {
            let category = Category(managedObject: categoryManagedObject)
            mutableCategories.append(category)
            self.categoriesAsManagedObjects[category.name] = categoryManagedObject
        }
        
        return mutableCategories
    }
    
    private func fetchCategory(category: Category) -> NSManagedObject {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return NSManagedObject()
        }
        
        var returnData: NSManagedObject = NSManagedObject()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.FOOD_TRACKER_CATEGORY)
        fetchRequest.predicate = NSPredicate(format: "name == %@", category.name)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            if (results.count > 0) {
                returnData = results[0] as! NSManagedObject
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnData
    }
    
    private func fetchCategories() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [NSManagedObject]()
        }
        
        var returnData: [NSManagedObject] = [NSManagedObject]()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: Category.FOOD_TRACKER_CATEGORY)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            returnData = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnData
    }
}

class Category: NSObject {
    static let FOOD_TRACKER_CATEGORY: String = "FoodTrackerCategory"
    
    var name: String = ""
    var helpText: String = ""
    var dailyGoal: Int = 0
    var maxValue: Int = 10
    var calorieValue: Int = 0
    
    convenience init(managedObject: NSManagedObject) {
        self.init()
        
        if let managedObjectName = managedObject.value(forKey: "name") as? String {
            self.name = managedObjectName
        }
        
        if let managedObjectHelpText = managedObject.value(forKey: "helpText") as? String {
            self.helpText = managedObjectHelpText
        }
        
        if let managedObjectDailyGoal = managedObject.value(forKey: "dailyGoal") as? Int {
            self.dailyGoal = managedObjectDailyGoal
        }
        
        if let managedObjectMaxValue = managedObject.value(forKey: "maxValue") as? Int {
            self.maxValue = managedObjectMaxValue
        }
        
        if let managedObjectCalorieValue = managedObject.value(forKey: "calorieValue") as? Int {
            self.calorieValue = managedObjectCalorieValue
        }
    }
}
