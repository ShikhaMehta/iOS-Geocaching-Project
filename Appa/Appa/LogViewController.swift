//
//  LogViewController.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import CoreData
import UIKit
import Foundation

class LogViewController: UITableViewController, NSFetchedResultsControllerDelegate {
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dataController: NSFetchedResultsController = NSFetchedResultsController()
    
    let formatter = NSDateFormatter()
    
    @IBOutlet var logTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        formatter.dateStyle = NSDateFormatterStyle.LongStyle
        formatter.timeStyle = .MediumStyle
        
        dataController = getFetchResultsController()
        dataController.delegate = self
        do {
            try dataController.performFetch()
        } catch _ {
        }
    }
    
    // CoreData Stuff!
    func getFetchResultsController() -> NSFetchedResultsController {
        dataController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        return dataController
    }
    
    // TODO Figure out ListFetchRequest for entity relationships!
    func listFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Log")
        let sortDescripter = NSSortDescriptor(key: "timestamp", ascending: false)
        fetchRequest.sortDescriptors = [sortDescripter]
        return fetchRequest
    }
    
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.logTable.reloadData()
    }
    
    // TableView Stuff!
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let numberOfSections  = dataController.sections?.count
        return numberOfSections!
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let numberOfRowsInSection = dataController.sections?[section].numberOfObjects
        return numberOfRowsInSection!
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = logTable.dequeueReusableCellWithIdentifier("logCell", forIndexPath: indexPath) as! LogTableCell
        let logEntry = dataController.objectAtIndexPath(indexPath) as! Log
        cell.timestamp.text = formatter.stringFromDate(logEntry.timestamp!)
        cell.name.text = logEntry.name
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "logEntry"){
            let selectedIndex: NSIndexPath = self.logTable.indexPathForCell(sender as! LogTableCell)!
            if let viewController: LogEntryViewController = segue.destinationViewController as? LogEntryViewController {
                let log = dataController.objectAtIndexPath(selectedIndex) as! Log
                viewController.log = log
            }
        }
    }
    
}