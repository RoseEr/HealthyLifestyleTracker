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
    
    let FOOD_TRACKER_CATEGORY : String = "FoodTrackerCategory"
    
    @IBOutlet weak var proteinTextField: UITextField!
    @IBOutlet weak var dairyTextField: UITextField!
    @IBOutlet weak var fruitsTextField: UITextField!
    @IBOutlet weak var vegetablesTextField: UITextField!
    @IBOutlet weak var fatsTextField: UITextField!
    
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
            saveFoodTrackerCategory(name: "Protein", goal: proteinTextField.text!, helpText: "~100 calories/serving")
            saveFoodTrackerCategory(name: "Dairy", goal: dairyTextField.text!, helpText: "~120 calories/serving")
            saveFoodTrackerCategory(name: "Fruits", goal: fruitsTextField.text!, helpText: "~100 calories/serving")
            saveFoodTrackerCategory(name: "Vegetables", goal: vegetablesTextField.text!, helpText: "~50 calories/serving")
            saveFoodTrackerCategory(name: "Fats", goal: fatsTextField.text!, helpText: "~120 calories/serving")
        }
    }
    
    private func saveFoodTrackerCategory(name: String, goal: String, helpText: String) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            sendAlert(message: "There was an error saving your values.")
            return
        }
        
        guard let goalIntValue = NumberFormatter().number(from: goal)?.intValue else {
            sendAlert(message: "There was an error saving your values.")
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: FOOD_TRACKER_CATEGORY, in: managedContext)
        
        let category = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        category.setValue(name, forKey: "name")
        category.setValue(goalIntValue, forKey: "dailyGoal")
        category.setValue(helpText, forKey: "helpText")
        category.setValue(10, forKey: "maxValue")
        
        do {
            try managedContext.save()
        } catch _ as NSError {
            sendAlert(message: "There was an error saving your values.")
        }
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
