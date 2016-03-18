//
//  Pin.swift
//  Appa
//
//  Created by Shikha Mehta on 3/9/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation
import MapKit

class Pin: NSObject, MKAnnotation {
    
    let coordinate: CLLocationCoordinate2D
    
    init(coordinate: CLLocationCoordinate2D) {
        self.coordinate = coordinate
    }
    
}