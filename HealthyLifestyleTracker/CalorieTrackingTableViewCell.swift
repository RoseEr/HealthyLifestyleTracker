//
//  CalorieTrackingTableViewCell.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/30/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class CalorieTrackingTableViewCell: EventsTableViewCell {

    override func layoutSubviews() {
        if (self.leftImageView == nil) {
            self.leftImageView = UIImageView(image: UIImage(named: "calorieIconOrange.png"))
        } else {
            self.leftImageView.image = UIImage(named: "calorieIconOrange.png")
        }
        
        super.layoutSubviews()
    }
}
