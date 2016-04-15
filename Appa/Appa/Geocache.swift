/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              Geocache.swift
 * @class-description       Generated file for Core Data, allows developer to add extra functionality to the Geocache object
 */

import Foundation
import CoreData
import MapKit

class Geocache: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func logCount() -> Int {
        return logs!.count
    }
    
    func addLogToSet(log:Log){
        let temp = self.mutableSetValueForKey("logs")
        temp.addObject(log)
    }
    
    func getLogsAsArray() -> [Log] {
        return logs!.allObjects as! [Log]
    }
    
}
