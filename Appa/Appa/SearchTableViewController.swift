//
//  SearchTableViewController.swift
//  Appa
//
//  Created by tam le on 4/12/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import MapKit
import UIKit
import Foundation
import CoreData
import CoreLocation

class SearchTableViewController: UITableViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
   
    
    var geocache:[Geocache] = []
    var baseLocation:CLLocation = CLLocation(latitude: 0.0, longitude: 0.0)
    
    // Initialize variables
    // Places - initialize core data entity
    //var geocache:Geocache? = nil
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dataViewController: NSFetchedResultsController = NSFetchedResultsController()

    
    @IBOutlet var searchTable: UITableView!

    
    override func viewDidLoad() {
        self.searchTable.reloadData()
                
        dataViewController = getFetchResultsController()
        
        dataViewController.delegate = self
        do {
            try dataViewController.performFetch()
        } catch _ {
        }
        
        let fetchRequest = NSFetchRequest()
        let entityDescription = NSEntityDescription.entityForName("Geocache", inManagedObjectContext: self.context)
        
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription

    }
    
    // getFetchResultsController() - get results returned from a Core Data fetch request
    func getFetchResultsController() -> NSFetchedResultsController {
        
        dataViewController = NSFetchedResultsController(fetchRequest: listFetchRequest(), managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        
        return dataViewController
        
    }
    
    // listFetchRequest() - list results returned from a Core Data fetch request
    func listFetchRequest() -> NSFetchRequest {
        
        let fetchRequest = NSFetchRequest(entityName: "Geocache")
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        return fetchRequest
    }
    
    // TableView functions
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return geocache.count
    }
    
    override func tableView(tableView: UITableView,cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("searchCell", forIndexPath: indexPath) as! SearchTableCell
        let tempGeocache:Geocache = geocache[indexPath.row]
        
        let geoLocation = CLLocation(latitude: Double(tempGeocache.latitude!), longitude: Double(tempGeocache.longitude!))
        let distance:Double = geoLocation.distanceFromLocation(self.baseLocation) / 1609.34
        cell.distance.text = "\(String(format:"%.1f", distance)) mi"
        cell.geoName.text = tempGeocache.name!
        
        //let geocacheLocation = CLLocation(latitude: Double(tempGeocache.latitude!), longitude: Double(tempGeocache.longitude!))
        
        return cell;
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchResult"){
            let selectedIndex: NSIndexPath = self.searchTable.indexPathForCell(sender as! UITableViewCell)!
            if let viewController: SearchResultViewController = segue.destinationViewController as? SearchResultViewController {
                viewController.geocache = geocache[selectedIndex.row]
                viewController.baseLocation = self.baseLocation
            }
        }
    }
    
}