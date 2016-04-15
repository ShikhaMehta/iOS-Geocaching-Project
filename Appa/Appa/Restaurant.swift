/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              Restaurant.swift
 * @class-description       Helper class to store information about a specific restaurant
 */

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
