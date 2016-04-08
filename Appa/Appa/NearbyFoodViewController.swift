//
//  NearbyFoodViewController.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import MapKit
import UIKit
import Foundation

class NearbyFoodViewController: UITableViewController {
    var restaurants:NSArray = NSArray()
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    var geocacheLocation:CLLocation = CLLocation()
    
    @IBOutlet var restaurantsTable: UITableView!
    
    override func viewDidLoad() {
        self.restaurantsTable.reloadData()
        geocacheLocation = CLLocation(latitude: latitude, longitude: longitude)
    }
    
    // TableView functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! NearbyFoodTableCell
        let restaurant:Restaurant = restaurants[indexPath.row] as! Restaurant
        cell.restaurantName.text = restaurant.name
        let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        cell.distance.text = String(geocacheLocation.distanceFromLocation(restaurantLocation) / 1609.34) + " mi"
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "nearbyFoodEntry"){
            let selectedIndex: NSIndexPath = self.restaurantsTable.indexPathForCell(sender as! UITableViewCell)!
            if let viewController: NearbyFoodEntryViewController = segue.destinationViewController as? NearbyFoodEntryViewController {
                viewController.restaurant = restaurants[selectedIndex.row] as! Restaurant
                viewController.geocacheLocation = self.geocacheLocation
            }
        }
    }
    
}