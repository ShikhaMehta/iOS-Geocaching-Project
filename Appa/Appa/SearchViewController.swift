/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              SearchViewController.swift
 * @class-description       Allows user to view all Geocaches, or just the ones within specified radiuss
 */

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class SearchViewController: UIViewController, UINavigationControllerDelegate, CLLocationManagerDelegate, NSFetchedResultsControllerDelegate {
    
    var context: NSManagedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    
    let locationManager = CLLocationManager()

    var geocaches:[Geocache] = []
    
    @IBOutlet weak var searchName: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var radius: UITextField!
    
    @IBAction func presentLocation(sender: UIButton) {
        if locationManager.location != nil {
            latitude.text = String(format:"%.3f", locationManager.location!.coordinate.latitude)
            longitude.text = String(format:"%.3f", locationManager.location!.coordinate.longitude)
        } else {
            latitude.text = "0.0"
            longitude.text = "0.0"
        }
    }
    
    @IBAction func searchBegin(sender: UIButton) {
        geocaches = []
        let location:CLLocation = CLLocation(latitude: Double(latitude.text!)!, longitude: Double(longitude.text!)!)
        
        do {
            let result = try self.context.executeFetchRequest(getFetchRequest())
            for(var i = 0;i < result.count; i++){
                let geocache = result[i] as! Geocache
                let geoLocation:CLLocation = CLLocation(latitude: Double(geocache.latitude!), longitude: Double(geocache.longitude!))
                let distance:Double = geoLocation.distanceFromLocation(location) / 1609.34
                NSLog("Distance: \(distance)")
                if distance <= Double(radius.text!){
                    geocaches.append(geocache)
                }
            }
            performSegueWithIdentifier("searchTable", sender: nil)
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
    }
    
    func getFetchRequest() -> NSFetchRequest {
        let fetchRequest = NSFetchRequest(entityName: "Geocache")
        let sortDescripter = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescripter]
        return fetchRequest
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager.stopUpdatingLocation()
    }
    
    func locationManager(manager: CLLocationManager, didFailWithError error:NSError) {
        print("Errors" + error.localizedDescription)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "searchTable"){
            if let viewController: SearchTableViewController = segue.destinationViewController as? SearchTableViewController {
                viewController.geocaches = geocaches
                viewController.baseLocation = CLLocation(latitude: Double(self.latitude.text!)!, longitude: Double(self.longitude.text!)!)
            }
        }
        if(segue.identifier == "allGeocaches"){
            geocaches = []
            if let viewController:SearchTableViewController = segue.destinationViewController as? SearchTableViewController {
                do {
                    viewController.geocaches = try self.context.executeFetchRequest(getFetchRequest()) as! [Geocache]
                    viewController.baseLocation = CLLocation(latitude: Double(self.latitude.text!)!, longitude: Double(self.longitude.text!)!)
                } catch _ { NSLog("Error") }
            }
        }
    }
    
}
