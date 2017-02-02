//
//  FoodTrackerHeaderViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/27/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class FoodTrackerHeaderViewController: UIViewController {

    var calorieLabel: UILabel!
    var headerLabel: UILabel!
    var calorieImageView: UIImageView!
    var categoryDataAccessor: CategoryDataAccessor?
    var entryDataAccessor: EntryDataAccessor?
    
    convenience init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?, categoryDataAccessor: CategoryDataAccessor, entryDataAccessor: EntryDataAccessor) {
        self.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        
        self.categoryDataAccessor = categoryDataAccessor
        self.entryDataAccessor = entryDataAccessor
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.headerLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.headerLabel.backgroundColor = UIColor.clear
        self.headerLabel.textColor = UIColor.white
        self.headerLabel.text = "Food Tracker"
        self.headerLabel.textAlignment = .center
        self.headerLabel.font = UIFont.systemFont(ofSize: 22.0, weight: UIFontWeightMedium)
        
        self.view.addSubview(self.headerLabel)
        
        
        self.calorieLabel = UILabel(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        self.calorieLabel.backgroundColor = UIColor.clear
        self.calorieLabel.textColor = UIColor.white
        self.calorieLabel.textAlignment = .left
        self.calorieLabel.font = UIFont.systemFont(ofSize: 18, weight: UIFontWeightLight)
        
        if let categoryDA = self.categoryDataAccessor, let entryDA = self.entryDataAccessor {
            self.calorieLabel.text = "Calories: \(entryDA.currentCalorieValue) / \(categoryDA.totalCalorieGoal)"
        }
        
        self.view.addSubview(self.calorieLabel)
        
        self.calorieImageView = UIImageView(image: UIImage(named: "calorieIconOrange.png"))
        self.view.addSubview(self.calorieImageView)
        
        setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func updateCalorieCount() {
        if let categoryDA = self.categoryDataAccessor, let entryDA = self.entryDataAccessor {
            self.calorieLabel.text = "Calories: \(entryDA.currentCalorieValue) / \(categoryDA.totalCalorieGoal)"
        }
        
        self.view.setNeedsLayout()
    }
    
    private func setupConstraints() {
        self.headerLabel?.translatesAutoresizingMaskIntoConstraints = false
        self.calorieImageView?.translatesAutoresizingMaskIntoConstraints = false
        self.calorieLabel?.translatesAutoresizingMaskIntoConstraints = false
        
        let headerWidthConstraint = NSLayoutConstraint(item: self.headerLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let headerHeightConstraint = NSLayoutConstraint(item: self.headerLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 30)
        let headerXConstraint = NSLayoutConstraint(item: self.headerLabel, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let headerYConstraint = NSLayoutConstraint(item: self.headerLabel, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 10)
        
        let calorieImageWidthConstraint = NSLayoutConstraint(item: self.calorieImageView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        let calorieImageHeightConstraint = NSLayoutConstraint(item: self.calorieImageView, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        let calorieImageXConstraint = NSLayoutConstraint(item: self.calorieImageView, attribute: .trailing, relatedBy: .equal, toItem: self.calorieLabel, attribute: .leading, multiplier: 1, constant: -8)
        let calorieImageYConstraint = NSLayoutConstraint(item: self.calorieImageView, attribute: .centerY, relatedBy: .equal, toItem: self.calorieLabel!, attribute: .centerY, multiplier: 1, constant: 0)
        
        let calorieWidthConstraint = NSLayoutConstraint(item: self.calorieLabel, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 0.5, constant: -30)
        let calorieHeightConstraint = NSLayoutConstraint(item: self.calorieLabel, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 50)
        let calorieXConstraint = NSLayoutConstraint(item: self.calorieLabel, attribute: .trailing, relatedBy: .equal, toItem: self.view, attribute: .trailing, multiplier: 1, constant: 0)
        let calorieYConstraint = NSLayoutConstraint(item: self.calorieLabel, attribute: .top, relatedBy: .equal, toItem: self.headerLabel!, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([headerWidthConstraint, headerHeightConstraint, headerXConstraint, headerYConstraint, calorieImageWidthConstraint, calorieImageHeightConstraint, calorieImageXConstraint, calorieImageYConstraint, calorieWidthConstraint, calorieHeightConstraint, calorieXConstraint, calorieYConstraint])
    }
}
