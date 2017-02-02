//
//  EventsTableViewCell.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/30/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class EventsTableViewCell: UITableViewCell {

    private var label : UILabel!
    var leftImageView : UIImageView!
    
    var labelText : String {
        get {
            guard let returnString = self.label.text else {
                return ""
            }
            
            return returnString
        }
        set {
            if self.label == nil {
                self.label = UILabel(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
            }
            self.label.text = newValue
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func layoutSubviews() {
        self.setupConstraints()
    }
    
    private func setupConstraints() {
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.leftImageView)
        
        self.leftImageView.translatesAutoresizingMaskIntoConstraints = false
        self.label.translatesAutoresizingMaskIntoConstraints = false
        
        let leftImageViewWidthConstraint = NSLayoutConstraint(item: self.leftImageView, attribute: .width, relatedBy: .equal, toItem: self.leftImageView, attribute: .height, multiplier: 1, constant: 0)
        let leftImageViewHeightConstraint = NSLayoutConstraint(item: self.leftImageView, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1.0, constant: 0)
        let leftImageViewXConstraint = NSLayoutConstraint(item: self.leftImageView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 12)
        let leftImageViewYConstraint = NSLayoutConstraint(item: self.leftImageView, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 12)
        
        let labelWidthConstraint = NSLayoutConstraint(item: self.label, attribute: .width, relatedBy: .equal, toItem: self.contentView, attribute: .width, multiplier: 0.66, constant: -12)
        let labelHeightConstraint = NSLayoutConstraint(item: self.label, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1.0, constant: 0)
        let labelXConstraint = NSLayoutConstraint(item: self.label, attribute: .leading, relatedBy: .equal, toItem: self.leftImageView, attribute: .trailing, multiplier: 1, constant: 12)
        let labelYConstraint = NSLayoutConstraint(item: self.label, attribute: .top, relatedBy: .equal, toItem: self.contentView, attribute: .top, multiplier: 1, constant: 12)
        
        NSLayoutConstraint.activate([leftImageViewWidthConstraint, leftImageViewHeightConstraint, leftImageViewXConstraint, leftImageViewYConstraint, labelWidthConstraint, labelHeightConstraint, labelXConstraint, labelYConstraint])
    }
}
