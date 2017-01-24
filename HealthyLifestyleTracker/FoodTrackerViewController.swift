//
//  FoodTrackerViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 12/25/16.
//  Copyright © 2016 Eric Rose. All rights reserved.
//

import UIKit
import CoreData

class FoodTrackerViewController: UIViewController {
    
    let FOOD_TRACKER_CATEGORY: String = "FoodTrackerCategory"
    var collectionVC: FoodTrackerCollectionViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 50)
        flowLayout.itemSize = CGSize(width: (self.view.frame.size.width / 10) + 2.0, height: (self.view.frame.size.width / 10) + 2.0)
        flowLayout.minimumInteritemSpacing = 0.0
        
        let foodTrackerData = fetchFoodTrackerData()
        
        if (foodTrackerData.count == 0) {
            let setupVC = FoodTrackerSetupViewController(nibName: "FoodTrackerSetupViewController", bundle: nil)
            self.addChildViewController(setupVC)
            self.view.addSubview(setupVC.view)
        } else {
            self.collectionVC = FoodTrackerCollectionViewController(collectionViewLayout: flowLayout, foodTrackerData: foodTrackerData)
            self.addChildViewController(collectionVC!)
            self.view.addSubview((collectionVC?.collectionView!)!)
            setupConstraints()
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    private func setupConstraints() {
        self.collectionVC?.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        
        let widthConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let heightConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: 0)
        let xConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let yConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .centerY, relatedBy: .equal, toItem: self.view, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([widthConstraint, heightConstraint, xConstraint, yConstraint])
        
    }
    
    func fetchFoodTrackerData() -> [NSManagedObject] {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return [NSManagedObject]()
        }
        
        var returnData: [NSManagedObject] = [NSManagedObject]()
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: FOOD_TRACKER_CATEGORY)
        
        do {
            let results = try managedContext.fetch(fetchRequest)
            returnData = results as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return returnData
    }
}
