//
//  CalendarViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/28/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {

    private weak var calendar : FSCalendar!
    private weak var eventsTableController : EventsTableViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        
        self.calendar = FSCalendar(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        self.calendar.dataSource = self
        self.calendar.delegate = self
        self.calendar.clipsToBounds = true
        self.view.addSubview(self.calendar)
        
        let cEvent = CalendarEvent(text: "2000/2000", isCalorieEvent: true)
        var cEvents = [CalendarEvent]()
        cEvents.append(cEvent)
        let eventsTableController = EventsTableViewController(events: cEvents, nibName: nil, bundle: nil)
        self.eventsTableController = eventsTableController
        
        self.addChildViewController(self.eventsTableController)
        self.view.addSubview(self.eventsTableController.tableView)
        
        self.setupConstraints()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    private func updateEvents() {
        let cEvent = CalendarEvent(text: "1000/2000", isCalorieEvent: true)
        var cEvents = [CalendarEvent]()
        cEvents.append(cEvent)
        
        self.eventsTableController.events = cEvents
        self.eventsTableController.tableView.reloadData()
    }
    
    private func setupConstraints() {
        self.calendar.translatesAutoresizingMaskIntoConstraints = false
        self.eventsTableController.tableView.translatesAutoresizingMaskIntoConstraints = false
        
        let calendarWidthConstraint = NSLayoutConstraint(item: self.calendar, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let calendarHeightConstraint = NSLayoutConstraint(item: self.calendar, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.5, constant: 0)
        let calendarXConstraint = NSLayoutConstraint(item: self.calendar, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let calendarYConstraint = NSLayoutConstraint(item: self.calendar, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1, constant: 48)
        
        let eventsTableViewWidthConstraint = NSLayoutConstraint(item: self.eventsTableController.tableView, attribute: .width, relatedBy: .equal, toItem: self.view, attribute: .width, multiplier: 1.0, constant: 0)
        let eventsTableViewHeightConstraint = NSLayoutConstraint(item: self.eventsTableController.tableView, attribute: .height, relatedBy: .equal, toItem: self.view, attribute: .height, multiplier: 0.5, constant: 0)
        let eventsTableViewXConstraint = NSLayoutConstraint(item: self.eventsTableController.tableView, attribute: .centerX, relatedBy: .equal, toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)
        let eventsTableViewYConstraint = NSLayoutConstraint(item: self.eventsTableController.tableView, attribute: .top, relatedBy: .equal, toItem: self.calendar, attribute: .bottom, multiplier: 1, constant: 0)
        
        NSLayoutConstraint.activate([calendarWidthConstraint, calendarHeightConstraint, calendarXConstraint, calendarYConstraint, eventsTableViewWidthConstraint, eventsTableViewHeightConstraint, eventsTableViewXConstraint, eventsTableViewYConstraint])
    }
    
    //MARK: - FSCalendar Delegate
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date) {
        self.updateEvents()
    }
}
