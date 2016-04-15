/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              Geocache+CoreDataProperties.swift
 * @class-description       Generated file for Core Data, implementation of the Core Data schema for Geocache Entity
 */

import Foundation
import CoreData

extension Geocache {

    @NSManaged var desc: String?
    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var name: String?
    @NSManaged var logs: NSSet?

}
