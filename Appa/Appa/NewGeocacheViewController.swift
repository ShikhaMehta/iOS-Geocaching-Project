//
//  DetailViewController.swift
//  Appa - This class adds a new geo cache name, description, and location.
//
//  Created by Shikha Mehta on 3/9/16 at 8:59PM
//  Copyright © 2016 ASU. All rights reserved.
//

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class NewGeocacheViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    // IBOutlets
    @IBOutlet weak var nam: UITextField!

    @IBOutlet weak var descriptio: UITextField!

    @IBOutlet weak var longitude: UITextField!

    @IBOutlet weak var latitude: UITextField!

    @IBOutlet weak var mapView: MKMapView!

    // Initialize variables
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    var nItem:Geocache? = nil

    let locationManager = CLLocationManager()

    var locValue:CLLocationCoordinate2D!

    // viewDidLoad() - Initialize the view and setup
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.delegate = self

        locationManager.desiredAccuracy = kCLLocationAccuracyBest

        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()

        mapView.setUserTrackingMode(.Follow, animated: true)

        locationManager.startUpdatingLocation()

        if nItem != nil {
            nam.text = nItem?.name
            descriptio.text = nItem?.desc
            longitude.text = "\(nItem?.longitude)"
            latitude.text = "\(nItem?.latitude)"
        }

        // show the keyboard

        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name:UIKeyboardWillShowNotification, object: nil);

        //hide the keyboard
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name:UIKeyboardWillHideNotification, object: nil);

    }

    // didReceiveMemoryWarning() - handles low memory conditions
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        let center = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude,
            longitude: userLocation.coordinate.longitude)
        let width = 1000.0 // meters
        let height = 1000.0
        let region = MKCoordinateRegionMakeWithDistance(center, width, height)
        mapView.setRegion(region, animated: true)
    }


    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {

        self.locationManager.stopUpdatingLocation()

    }

    func locationManager(manager: CLLocationManager, didFailWithError error:NSError) {
        print("Errors" + error.localizedDescription)
    }


    // presentLocation() - fill the coordinates for current location
    @IBAction func presentLocation(sender: UIButton) {

        let pin = Pin(coordinate: mapView.userLocation.coordinate)
        mapView.addAnnotation(pin)

        latitude.text = String(mapView.userLocation.coordinate.latitude)
        longitude.text = String(mapView.userLocation.coordinate.longitude)


/*
        
        // begin debug to look at core data in case it is needed
        
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest()
        
        // Create Entity Description
        //let entityDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: context)
        let entityDescription = NSEntityDescription.entityForName("Places", inManagedObjectContext: self.context)
        
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        
        do {
            let result = try self.context.executeFetchRequest(fetchRequest)
            //print(result)
            
            if (result.count > 0) {
                let person = result[2] as! NSManagedObject
                
                print("1 - \(person)")
                
                if let placenameStr = person.valueForKey("placeName"), placedescriptionStr = person.valueForKey("placeDescription") {
                    print("\(placenameStr) \(placedescriptionStr)")
                }
                
                print("2 - \(person)")
            }
            
            
        } catch {
            let fetchError = error as NSError
            print(fetchError)
        }
        
*/

    }

    // saveData() - save the data from the text field into core data
    @IBAction func saveData(sender: UIButton) {
         if nItem == nil
        {
            let context = self.context
            let ent = NSEntityDescription.entityForName("Geocache", inManagedObjectContext: context)

            let nItem = Geocache(entity: ent!, insertIntoManagedObjectContext: context)
            nItem.name = nam.text!
            nItem.desc = descriptio.text!
            nItem.latitude = Double(latitude.text!)
            nItem.longitude = Double(longitude.text!)

            do {
                //try context.save()
                try nItem.managedObjectContext?.save()
            } catch _ {
            }
        } else {

            nItem!.name = nam.text!
            nItem!.desc = descriptio.text!
            nItem!.latitude = Double(latitude.text!)
            nItem!.longitude = Double(longitude.text!)
            do {
                //try context.save()
                try nItem!.managedObjectContext?.save()
            } catch _ {
            }
        }

        navigationController!.popViewControllerAnimated(true)


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
        self.nam.resignFirstResponder()
        self.descriptio.resignFirstResponder()
        self.latitude.resignFirstResponder()
        self.longitude.resignFirstResponder()

    }



}