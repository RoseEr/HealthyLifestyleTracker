//
//  CalendarViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/28/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    fileprivate weak var calendar : FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        let calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        calendar.dataSource = self
        calendar.delegate = self
        view.addSubview(calendar)
        self.calendar = calendar
        
        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func setupConstraints() {
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        
        let calendarWidthConstraint = NSLayoutConstraint(item: self.calendar, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let calendarHeightConstraint = NSLayoutConstraint(item: self.calendar, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 1.0, constant: -72)
        let calendarXConstraint = NSLayoutConstraint(item: self.calendar, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let calendarYConstraint = NSLayoutConstraint(item: self.calendar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 48)
        
        NSLayoutConstraint.activate([calendarWidthConstraint, calendarHeightConstraint, calendarXConstraint, calendarYConstraint])
    }
}
