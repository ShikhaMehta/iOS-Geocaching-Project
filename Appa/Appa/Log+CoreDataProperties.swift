//
//  Log+CoreDataProperties.swift
//  Appa
//
//  Created by Tyler Brockett on 3/26/16.
//  Copyright © 2016 ASU. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Log {

    @NSManaged var geocacheID: String?
    @NSManaged var name: String?
    @NSManaged var itemTaken: String?
    @NSManaged var itemLeft: String?
    @NSManaged var notes: String?

}
