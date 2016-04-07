//
//  Places+CoreDataProperties.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Places {

    @NSManaged var latitude: NSNumber?
    @NSManaged var longitude: NSNumber?
    @NSManaged var placeDescription: String?
    @NSManaged var placeName: String?

}