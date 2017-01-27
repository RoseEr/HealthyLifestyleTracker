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

protocol FoodTrackerCollectionViewControllerDelegate: class {
    func didRefreshData()
}

class FoodTrackerCollectionViewController: UICollectionViewController {
    
    let HEADER_VIEW: String = "HeaderView"

    var categories : [Category]
    var entryDataAccessor: EntryDataAccessor?
    weak var delegate: FoodTrackerCollectionViewControllerDelegate?
    
    init(collectionViewLayout: UICollectionViewLayout, categoryDataAccessor: CategoryDataAccessor, delegate: FoodTrackerCollectionViewControllerDelegate) {
        self.categories = categoryDataAccessor.retrieveCategories()
        self.entryDataAccessor = EntryDataAccessor(categoryDataAccessor: categoryDataAccessor)
        self.delegate = delegate
        
        super.init(collectionViewLayout: collectionViewLayout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.categories = [Category]()
        
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
        return self.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        if(self.categories.count > indexPath.section) {
            let category = self.categories[indexPath.section]
            
            switch kind {
            case UICollectionElementKindSectionHeader:
                let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HEADER_VIEW, for: indexPath) as! FoodTrackerHeaderCollectionReusableView
                headerView.setLeftLabel(text: category.name)
                headerView.setRightLabel(text: category.helpText)
                return headerView
            default:
                assert(false, "Unexpected Element")
            }
        }
        
        assert(false, "Unexpected Element")
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (self.categories.count > section) {
            let category = self.categories[section]
            return category.maxValue
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
        
        if(self.categories.count > indexPath.section) {
            let category = self.categories[indexPath.section]
            
            let entryForCurrentCategory = self.entryDataAccessor?.retrieveCurrentEntryForCategory(category: category)
            
            if ((entryForCurrentCategory?.value)! > indexPath.item) {
                cell.backgroundColor = UIColor.darkGray
            } else {
                cell.backgroundColor = UIColor.lightGray
            }
            
            if (indexPath.item == category.dailyGoal - 1) {
                cell.backgroundColor = UIColor.green
            }
        }
    
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.categories.count > indexPath.section) {
            let category = self.categories[indexPath.section]
            let entryForCurrentCategory = self.entryDataAccessor?.retrieveCurrentEntryForCategory(category: category)
            
            if (entryForCurrentCategory!.value == 1 && indexPath.item == 0) {
                self.entryDataAccessor?.updateValueForEntry(entry: entryForCurrentCategory!, newValue: 0)
            } else {
                self.entryDataAccessor?.updateValueForEntry(entry: entryForCurrentCategory!, newValue: indexPath.item + 1)
            }
        }
        
        if let delegate = self.delegate {
            delegate.didRefreshData()
        }
        
        self.collectionView?.reloadData()
        
    }
    
    private func sendAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
}
