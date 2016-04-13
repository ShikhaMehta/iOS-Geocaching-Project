//
//  Restaurant.swift
//  Appa
//
//  Created by Tyler Brockett on 4/7/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation

class Restaurant {
    var name:String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
    init() {
        self.name = "default"
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    init(data:String){
        
    }
    
    init(dict:NSDictionary){
        let geometry:NSDictionary = dict["geometry"] as! NSDictionary
        let location:NSDictionary = geometry["location"] as! NSDictionary
        self.latitude = location["lat"] as! Double
        self.longitude = location["lng"] as! Double
        self.name = dict["name"] as! String
    }
    
    init(name:String, latitude:Double, longitude:Double) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
    }
    
}