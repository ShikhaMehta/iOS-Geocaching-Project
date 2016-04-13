//
//  SearchViewController.swift
//  Appa
//
//  Created by tam le on 3/25/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class SearchViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    let locationManager = CLLocationManager()

    var withinRadius:[Geocache] = []
    
    @IBOutlet weak var searchName: UITextField!
    
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var radius: UITextField!
    
    @IBAction func presentLocation(sender: UIButton) {
        latitude.text = String(format:"%.3f", locationManager.location!.coordinate.latitude)
        longitude.text = String(format:"%.3f", locationManager.location!.coordinate.longitude)
    }
    
    
    
    // Initialize variables
    // Places - initialize core data entity
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    var dataViewController: NSFetchedResultsController = NSFetchedResultsController()
    
    //let conText = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    //var nItem:Places? = nil

    @IBAction func searchBegin(sender: UIButton) {
        let fetchRequest = NSFetchRequest(entityName: "Geocache")
        
        // Create Entity Description
        //let entityDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: context)
        let entityDescription = NSEntityDescription.entityForName("Geocache", inManagedObjectContext: self.context)
        
        
        // Configure Fetch Request
        //fetchRequest.entity = entityDescription
        
        withinRadius = []
        
        var location:CLLocation = CLLocation(latitude: Double(latitude.text!)!, longitude: Double(longitude.text!)!)
        
        do {
            let result = try self.context.executeFetchRequest(fetchRequest)
            let maxDist = radius
            for(var i = 0;i < result.count; i++){
                let geocache = result[i] as! Geocache
                let geoLocation:CLLocation = CLLocation(latitude: Double(geocache.latitude!), longitude: Double(geocache.longitude!))
                let distance:Double = geoLocation.distanceFromLocation(location) / 1609.34
                NSLog("Distance: \(distance)")
                if distance <= Double(radius.text!){
                    withinRadius.append(geocache)
                }
            }
            performSegueWithIdentifier("searchTable", sender: nil)
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
        
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
    
    // viewDidLoad() - loads view into the memory and does view initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.radius.text = "5"
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()

        
        dataViewController = getFetchResultsController()
        
        dataViewController.delegate = self
        do {
            try dataViewController.performFetch()
        } catch _ {
        }
        
        // show the keyboard
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);
        
        //hide the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);
        
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        self.locationManager.stopUpdatingLocation()
        
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error:NSError) {
        print("Errors" + error.localizedDescription)
    }
    
    
    // didReceiveMemoryWarning() - handles low memory conditions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // move the view upwards as keyboard appears
    func keyboardWillShow(sender: NSNotification) {
        if(self.view.frame.origin.y >= 0) {
            self.view.frame.origin.y -= 100
        }
    }
    
    // move the keyboard back as keyboard disapears
    func keyboardWillHide(sender: NSNotification) {
        if(self.view.frame.origin.y < 0) {
            self.view.frame.origin.y += 100
        }
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        view.endEditing(true)
        self.searchName.resignFirstResponder()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchTable"){
            if let viewController: SearchTableViewController = segue.destinationViewController as? SearchTableViewController {
                viewController.geocache = withinRadius
                viewController.baseLocation = CLLocation(latitude: Double(self.latitude.text!)!, longitude: Double(self.longitude.text!)!)
            }
        }
    }

    
}

