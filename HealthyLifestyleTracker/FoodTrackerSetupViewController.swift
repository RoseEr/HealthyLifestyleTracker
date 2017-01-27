//
//  FoodTrackerSetupViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/19/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit
import CoreData

class FoodTrackerSetupViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var dairyTextField: UITextField!
    @IBOutlet weak var fruitsTextField: UITextField!
    @IBOutlet weak var vegetablesTextField: UITextField!
    @IBOutlet weak var fatsTextField: UITextField!
    
    let categoryDataAccessor = CategoryDataAccessor()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextFields()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setupTextFields() {
        proteinTextField.delegate = self
        dairyTextField.delegate = self
        fruitsTextField.delegate = self
        vegetablesTextField.delegate = self
        fatsTextField.delegate = self
    }
    
    
    
    @IBAction func Pressed(_ sender: UIButton) {
        if (!didUserEnterAllValues()) {
            sendAlert(message: "Please enter a value for all categories.")
        } else {
            saveFoodTrackerCategory(name: "Protein", goal: proteinTextField.text!, helpText: "~100 calories/serving", calorieValue: 100)
            saveFoodTrackerCategory(name: "Dairy", goal: dairyTextField.text!, helpText: "~120 calories/serving", calorieValue: 120)
            saveFoodTrackerCategory(name: "Fruits", goal: fruitsTextField.text!, helpText: "~100 calories/serving", calorieValue: 100)
            saveFoodTrackerCategory(name: "Vegetables", goal: vegetablesTextField.text!, helpText: "~50 calories/serving", calorieValue: 50)
            saveFoodTrackerCategory(name: "Fats", goal: fatsTextField.text!, helpText: "~120 calories/serving", calorieValue: 120)
        }
    }
    
    private func saveFoodTrackerCategory(name: String, goal: String, helpText: String, calorieValue: Int) {
        let category = Category()
        
        if let dailyGoalIntValue = (NumberFormatter().number(from: goal)?.intValue) {
            category.dailyGoal = dailyGoalIntValue
        } else {
            category.dailyGoal = 0
        }
        
        category.name = name
        category.helpText = helpText
        category.maxValue = 10
        category.calorieValue = calorieValue
        
        self.categoryDataAccessor.addCategory(category: category)
    }
    
    private func didUserEnterAllValues() -> Bool {
        return !proteinTextField.text!.isEmpty &&
         !dairyTextField.text!.isEmpty &&
         !fruitsTextField.text!.isEmpty &&
         !vegetablesTextField.text!.isEmpty &&
         !fatsTextField.text!.isEmpty
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        guard let enteredValue = NumberFormatter().number(from: textField.text!) else {
            return false;
        }
        
        if (enteredValue.intValue > 10) {
            sendAlert(message: "Maximum value is 10.");
            return false;
        } else {
            return true;
        }
    }
    
    func sendAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
