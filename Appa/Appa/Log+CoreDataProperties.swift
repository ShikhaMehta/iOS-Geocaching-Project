/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              Log+CoreDataProperties.swift
 * @class-description       Generated file for Core Data, implementation of the Core Data schema for Log Entity
 */

import Foundation
import CoreData

extension Log {

    @NSManaged var itemLeft: String?
    @NSManaged var itemTaken: String?
    @NSManaged var name: String?
    @NSManaged var notes: String?
    @NSManaged var timestamp: NSDate?

}
