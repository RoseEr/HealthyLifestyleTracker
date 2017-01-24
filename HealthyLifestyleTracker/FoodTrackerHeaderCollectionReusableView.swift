//
//  FoodTrackerHeaderCollectionReusableView.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/20/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class FoodTrackerHeaderCollectionReusableView: UICollectionReusableView {

    @IBOutlet private weak var leftLabel: UILabel!
    @IBOutlet private weak var rightLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setLeftLabel(text: String) {
        self.leftLabel.text = text
        self.leftLabel.sizeToFit()
    }
    
    func setRightLabel(text: String) {
        self.rightLabel.text = text
        self.rightLabel.sizeToFit()
    }
}
