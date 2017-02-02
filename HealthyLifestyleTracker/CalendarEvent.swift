//
//  CalendarEvent.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/30/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class CalendarEvent: NSObject {

    var text: String
    var isCalorieEvent: Bool
    
    init(text: String, isCalorieEvent: Bool) {
        self.text = text
        self.isCalorieEvent = isCalorieEvent
    }
}
