//
//  Places.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation
import CoreData
import MapKit

class Places: NSManagedObject {

// Insert code here to add functionality to your managed object subclass

    func distanceFrom(place:Places) -> Double {
        let loc1:CLLocation = CLLocation(latitude: self.latitude as! Double, longitude: self.longitude as! Double)
        let loc2:CLLocation = CLLocation(latitude: place.latitude as! Double, longitude: place.longitude as! Double)
        let distance:Double = loc1.distanceFromLocation(loc2)
        return distance
    }
    
}
