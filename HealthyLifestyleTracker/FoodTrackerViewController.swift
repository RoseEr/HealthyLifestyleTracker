//
//  FoodTrackerViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 12/25/16.
//  Copyright © 2016 Eric Rose. All rights reserved.
//

import UIKit
import CoreData

class FoodTrackerViewController: UIViewController, FoodTrackerCollectionViewControllerDelegate {
    
    var collectionVC: FoodTrackerCollectionViewController?
    var headerVC: FoodTrackerHeaderViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical
        flowLayout.headerReferenceSize = CGSize(width: self.view.frame.size.width, height: 50)
        flowLayout.itemSize = CGSize(width: (self.view.frame.size.width / 10) + 2.0, height: (self.view.frame.size.width / 10) + 2.0)
        flowLayout.minimumInteritemSpacing = 0.0
        
        let categoryDataAccessor = CategoryDataAccessor()
        let categories = categoryDataAccessor.retrieveCategories()
        
        if (categories.count == 0) {
            let setupVC = FoodTrackerSetupViewController(nibName: "FoodTrackerSetupViewController", bundle: nil)
            self.addChildViewController(setupVC)
            self.view.addSubview(setupVC.view)
        } else {
            self.headerVC = FoodTrackerHeaderViewController(nibName: nil, bundle: nil, categoryDataAccessor: categoryDataAccessor, entryDataAccessor: EntryDataAccessor(categoryDataAccessor: categoryDataAccessor))
            self.addChildViewController(self.headerVC!)
            self.view.addSubview((self.headerVC?.view!)!)
            
            self.collectionVC = FoodTrackerCollectionViewController(collectionViewLayout: flowLayout, categoryDataAccessor: categoryDataAccessor, delegate: self)
            self.addChildViewController(collectionVC!)
            self.view.addSubview((collectionVC?.collectionView!)!)
            
            setupConstraints()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func didRefreshData() {
        self.headerVC?.updateCalorieCount()
    }
    
    private func setupConstraints() {
        self.collectionVC?.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.headerVC?.view?.translatesAutoresizingMaskIntoConstraints = false
        
        let collectionWidthConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let collectionHeightConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: -80)
        let collectionXConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let collectionYConstraint = NSLayoutConstraint(item: self.collectionVC!.collectionView!, attribute: .top, relatedBy: .equal, toItem: self.headerVC!.view!, attribute: .bottom, multiplier: 1, constant: 0)
        
        let headerWidthConstraint = NSLayoutConstraint(item: self.headerVC!.view!, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let headerHeightConstraint = NSLayoutConstraint(item: self.headerVC!.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 80)
        let headerXConstraint = NSLayoutConstraint(item: self.headerVC!.view!, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let headerYConstraint = NSLayoutConstraint(item: self.headerVC!.view!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([collectionWidthConstraint, collectionHeightConstraint, collectionXConstraint, collectionYConstraint, headerWidthConstraint, headerHeightConstraint, headerXConstraint, headerYConstraint])
        
    }
}
