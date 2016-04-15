/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              SearchTableViewController.swift
 * @class-description       Displays all the resulting Geocaches from the SearchViewController specifications
 */

import MapKit
import UIKit
import Foundation
import CoreData
import CoreLocation

class SearchTableViewController: UITableViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
   
    var geocaches:[Geocache] = []
    
    var baseLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    @IBOutlet var searchTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        geocaches.sortInPlace() {
            (g1, g2) in
            let g1Loc:CLLocation = CLLocation(latitude: Double(g1.latitude!), longitude: Double(g1.longitude!))
            let g2Loc:CLLocation = CLLocation(latitude: Double(g2.latitude!), longitude: Double(g2.longitude!))
            return g1Loc.distanceFromLocation(self.baseLocation) < g2Loc.distanceFromLocation(self.baseLocation)
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geocaches.count
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableCell
        let tempGeocache:Geocache = geocaches[indexPath.row]
        
        let geoLocation = CLLocation(latitude: Double(tempGeocache.latitude!), longitude: Double(tempGeocache.longitude!))
        let distance:Double = geoLocation.distanceFromLocation(self.baseLocation) / 1609.34
        cell.distance.text = "\(String(format:"%.1f", distance)) mi"
        cell.geoName.text = tempGeocache.name!
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchResult"){
            let selectedIndex: NSIndexPath = self.searchTable.indexPathForCell(sender as! UITableViewCell)!
            if let viewController: SearchResultViewController = segue.destinationViewController as? SearchResultViewController {
                viewController.geocache = geocaches[selectedIndex.row]
                viewController.baseLocation = self.baseLocation
            }
        }
    }
    
}