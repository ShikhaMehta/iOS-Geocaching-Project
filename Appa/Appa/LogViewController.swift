/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              LogViewController.swift
 * @class-description       Shows TableView of all the logs for the given Geocache
 */

import CoreData
import UIKit
import Foundation

class LogViewController: UITableViewController {

    let formatter = NSDateFormatter()
    
    var geocache:Geocache?
    var logs:[Log] = []
    
    @IBOutlet var logTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        formatter.dateStyle = NSDateFormatterStyle.ShortStyle
        formatter.timeStyle = .MediumStyle
        
        if geocache != nil {
            logs = geocache!.getLogsAsArray()
            NSLog("Log Count: \(geocache!.logCount())")
        }
        logTable.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return logs.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = logTable.dequeueReusableCellWithIdentifier("logCell", forIndexPath: indexPath) as! LogTableCell
        let logEntry = logs[indexPath.row]
        cell.timestamp.text = formatter.stringFromDate(logEntry.timestamp!)
        cell.name.text = logEntry.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "logEntry"){
            let selectedIndex: NSIndexPath = self.logTable.indexPathForCell(sender as! LogTableCell)!
            if let viewController: LogEntryViewController = segue.destinationViewController as? LogEntryViewController {
                let log = logs[selectedIndex.row]
                viewController.log = log
            }
        }
    }
    
}
