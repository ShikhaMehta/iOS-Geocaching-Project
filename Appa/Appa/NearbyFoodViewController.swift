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
    var restaurants:[Restaurant] = []
    var geocacheLocation:CLLocation = CLLocation()
    
    @IBOutlet var restaurantsTable: UITableView!
    
    override func viewDidLoad() {
        restaurants.sortInPlace() {
            (r1, r2) in
            let r1Loc:CLLocation = CLLocation(latitude: r1.latitude, longitude: r1.longitude)
            let r2Loc:CLLocation = CLLocation(latitude: r2.latitude, longitude: r2.longitude)
            return r1Loc.distanceFromLocation(self.geocacheLocation) < r2Loc.distanceFromLocation(self.geocacheLocation)
        }
        
        self.restaurantsTable.reloadData()
    }
    
    // TableView functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("foodCell", forIndexPath: indexPath) as! NearbyFoodTableCell
        let restaurant:Restaurant = restaurants[indexPath.row]
        cell.restaurantName.text = restaurant.name
        let restaurantLocation = CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude)
        cell.distance.text = String(format:"%.1f", geocacheLocation.distanceFromLocation(restaurantLocation) / 1609.34) + " mi"
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