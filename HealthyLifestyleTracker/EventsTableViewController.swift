//
//  EventsTableViewController.swift
//  HealthyLifestyleTracker
//
//  Created by Eric Rose on 1/30/17.
//  Copyright © 2017 Eric Rose. All rights reserved.
//

import UIKit

class EventsTableViewController: UITableViewController {
    
    private let CALORIE_TRACKING_CELL = "CalorieTrackingCell"
    private let WORKOUT_TRACKING_CELL = "WorkoutTrackingCell"
    
    var events : [CalendarEvent]?
    
    convenience init(events: [CalendarEvent], nibName nibNameOrNil: String?, bundle bundleOrNil: Bundle?) {
        self.init(nibName: nibNameOrNil, bundle: bundleOrNil)
        self.events = events
    }
    
    override init(nibName nibNameOrNil: String?, bundle bundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: bundleOrNil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.register(CalorieTrackingTableViewCell.self, forCellReuseIdentifier: CALORIE_TRACKING_CELL)
        self.tableView.register(WorkoutTrackingTableViewCell.self, forCellReuseIdentifier: WORKOUT_TRACKING_CELL)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let events = self.events {
            return events.count
        }
        
        return 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: EventsTableViewCell
        
        guard let currentEvent = self.events?[indexPath.row] else {
            return EventsTableViewCell(frame: CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0))
        }
        
        if (currentEvent.isCalorieEvent) {
            cell = tableView.dequeueReusableCell(withIdentifier: CALORIE_TRACKING_CELL) as! CalorieTrackingTableViewCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: WORKOUT_TRACKING_CELL) as! WorkoutTrackingTableViewCell
        }
        
        cell.labelText = currentEvent.text
        cell.layoutSubviews()
        
        return cell
    }
}
