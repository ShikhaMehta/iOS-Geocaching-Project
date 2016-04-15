/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              NearbyFoodViewController.swift
 * @class-description       Displays distance and name of restaurants near the Geocache
 */

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
                viewController.restaurant = restaurants[selectedIndex.row] 
                viewController.geocacheLocation = self.geocacheLocation
            }
        }
    }
    
}
