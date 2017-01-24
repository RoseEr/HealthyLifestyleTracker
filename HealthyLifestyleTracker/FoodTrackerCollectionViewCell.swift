//
//  FoodTrackerCollectionViewCell.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/2/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class FoodTrackerCollectionViewCell: UICollectionViewCell {
    
    private var label : UILabel!
    
    var labelText : String {
        get {
            guard let returnString = self.label.text else {
                return ""
            }
            
            return returnString
        }
        set {
            self.label.text = newValue
        }
    }
    
    var isCheckedOff : Bool = false
    
    private var _isFirstItem : Bool = false
    var isFirstItem : Bool {
        get {
            return self._isFirstItem
        }
        set {
            if newValue {
                self.leftSideView.backgroundColor = UIColor.clear
            }
            
            self._isFirstItem = newValue
        }
    }
    
    private var _isLastItem : Bool = false
    var isLastItem : Bool {
        get {
            return self._isLastItem
        }
        set {
            if newValue {
                self.rightSideView.backgroundColor = UIColor.clear
            }
            
            self._isLastItem = newValue
        }
    }
    
    private var leftSideView : UIView!
    private var rightSideView : UIView!
    
    override init(frame: CGRect) {
        super.init(frame:frame)
        
        self.backgroundColor = UIColor.lightGray
        
        self.label = UILabel()
        self.label.textAlignment = .center
        self.label.textColor = UIColor.white
        
        self.leftSideView = UIView(frame: CGRect(x: 0, y: 0, width: 1, height: self.contentView.frame.size.height))
        self.leftSideView.backgroundColor = UIColor.clear
        
        self.rightSideView = UIView(frame: CGRect(x: self.contentView.frame.size.width - 1, y: 0, width: 1, height: self.contentView.frame.size.height))
        self.rightSideView.backgroundColor = UIColor.clear
        
        self.contentView.addSubview(self.label)
        self.contentView.addSubview(self.rightSideView)
        self.contentView.addSubview(self.leftSideView)
        
        self.setupConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.leftSideView.translatesAutoresizingMaskIntoConstraints = false
        self.rightSideView.translatesAutoresizingMaskIntoConstraints = false
        
        let labelWidthConstraint = NSLayoutConstraint(item: self.label, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        let labelHeightConstraint = NSLayoutConstraint(item: self.label, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 20)
        let labelXConstraint = NSLayoutConstraint(item: self.label, attribute: .centerX, relatedBy: .equal, toItem: self.contentView, attribute: .centerX, multiplier: 1, constant: 0)
        let labelYConstraint = NSLayoutConstraint(item: self.label, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        let leftSideViewWidthConstraint = NSLayoutConstraint(item: self.leftSideView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)
        let leftSideViewHeightConstraint = NSLayoutConstraint(item: self.leftSideView, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1.0, constant: 0)
        let leftSideViewXConstraint = NSLayoutConstraint(item: self.leftSideView, attribute: .leading, relatedBy: .equal, toItem: self.contentView, attribute: .leading, multiplier: 1, constant: 0)
        let leftSideViewYConstraint = NSLayoutConstraint(item: self.leftSideView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        let rightSideViewWidthConstraint = NSLayoutConstraint(item: self.rightSideView, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1.0, constant: 1)
        let rightSideViewHeightConstraint = NSLayoutConstraint(item: self.rightSideView, attribute: .height, relatedBy: .equal, toItem: self.contentView, attribute: .height, multiplier: 1.0, constant: 0)
        let rightSideViewXConstraint = NSLayoutConstraint(item: self.rightSideView, attribute: .trailing, relatedBy: .equal, toItem: self.contentView, attribute: .trailing, multiplier: 1, constant: 0)
        let rightSideViewYConstraint = NSLayoutConstraint(item: self.rightSideView, attribute: .centerY, relatedBy: .equal, toItem: self.contentView, attribute: .centerY, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([labelWidthConstraint, labelHeightConstraint, labelXConstraint, labelYConstraint, leftSideViewWidthConstraint, leftSideViewHeightConstraint, leftSideViewXConstraint, leftSideViewYConstraint, rightSideViewWidthConstraint, rightSideViewHeightConstraint, rightSideViewXConstraint, rightSideViewYConstraint])
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
