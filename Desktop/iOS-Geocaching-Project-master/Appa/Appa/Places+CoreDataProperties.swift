//
//  Places+CoreDataProperties.swift
//  Appa
//
//  Created by Shikha Mehta on 3/8/16.
//  Copyright © 2016 ASU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Places {

    @NSManaged var placeName: String?
    @NSManaged var placeDescription: String?
    @NSManaged var latitude: String?
    @NSManaged var longitude: String?

}
