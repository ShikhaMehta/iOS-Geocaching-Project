/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              NewGeocacheViewController.swift
 * @class-description       Allows user to create a new Geocache and add it to Core Data
 */

import Foundation
import UIKit
import CoreData
import MapKit
import CoreLocation

class NewGeocacheViewController: UIViewController, MKMapViewDelegate, UINavigationControllerDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var nam: UITextField!
    @IBOutlet weak var descriptio: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    @IBOutlet weak var mapView: MKMapView!

    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    let locationManager = CLLocationManager()

    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        mapView.setUserTrackingMode(.Follow, animated: true)
        locationManager.startUpdatingLocation()
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

    @IBAction func presentLocation(sender: UIButton) {
        let annotation = MKPointAnnotation()
        annotation.coordinate = mapView.userLocation.coordinate
        annotation.title = "Your Location"
        self.mapView.addAnnotation(annotation)
        latitude.text = String(format:"%.3f", mapView.userLocation.coordinate.latitude)
        longitude.text = String(format:"%.3f", mapView.userLocation.coordinate.longitude)
    }

    @IBAction func saveData(sender: UIButton) {
        let ent = NSEntityDescription.entityForName("Geocache", inManagedObjectContext: context)
        let nItem = Geocache(entity: ent!, insertIntoManagedObjectContext: context)
        nItem.name = nam.text!
        nItem.desc = descriptio.text!
        nItem.latitude = Double(latitude.text!)
        nItem.longitude = Double(longitude.text!)
        do {
            try context.save()
        } catch _ {
        }
        navigationController!.popViewControllerAnimated(true)
    }
    
}
