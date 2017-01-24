//
//  TabBarViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 12/25/16.
//  Copyright © 2016 Eric Rose. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let foodTrackerView = FoodTrackerViewController(nibName: "FoodTrackerViewController", bundle: nil)
        let workoutsView = WorkoutsViewController(nibName: "WorkoutsViewController", bundle: nil)
        
        var tabViewControllers = [UIViewController]()
        
        tabViewControllers.append(foodTrackerView)
        tabViewControllers.append(workoutsView)
        
        self.setViewControllers(tabViewControllers, animated: false)
        
        foodTrackerView.tabBarItem = UITabBarItem(title: "Food", image: UIImage(named: "Food.png"), selectedImage: UIImage(named: "FoodSelected.png"))
        workoutsView.tabBarItem = UITabBarItem(title: "Workouts", image: UIImage(named: "Dumbbell.png"), selectedImage: UIImage(named: "DumbbellSelected.png"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
