//
//  Geocache.swift
//  Appa
//
//  Created by Tyler Brockett on 4/7/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Geocache: NSManagedObject {

// Insert code here to add functionality to your managed object subclass
    
    func distanceTo(geocache:Geocache) -> Double {
        let g1:CLLocation = CLLocation(latitude: Double(self.latitude!), longitude: Double(self.longitude!))
        let g2:CLLocation = CLLocation(latitude: Double(geocache.latitude!), longitude: Double(geocache.longitude!))
        let distance:Double = g1.distanceFromLocation(g2)
        return distance
    }
    
}
