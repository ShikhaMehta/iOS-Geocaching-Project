/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              NewLogEntryViewController.swift
 * @class-description       Allows user to create new log entry to the specified Geocache
 */

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class NewLogEntryViewController: UIViewController {
    
    var geocache: Geocache?
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var itemTaken: UITextField!
    @IBOutlet weak var itemLeft: UITextField!
    @IBOutlet weak var notes: UITextView!
    
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func save(sender: UIButton) {
        NSLog("Saving new Log Entry")
        let ent = NSEntityDescription.entityForName("Log", inManagedObjectContext: context)
        let log = Log(entity: ent!, insertIntoManagedObjectContext: context)
        
        log.name = name.text!
        log.itemTaken = itemTaken.text!
        log.itemLeft = itemLeft.text!
        log.notes = notes.text!
        log.timestamp = NSDate()
        
        do {
            geocache!.addLogToSet(log)
            try context.save()
            navigationController!.popViewControllerAnimated(true)
        } catch _ {
            NSLog("Error saving new log")
        }
    }
    
}
