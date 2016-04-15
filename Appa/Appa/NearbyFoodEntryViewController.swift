/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              NearbyFoodEntryViewController.swift
 * @class-description       Displays MapView with annotations for the Geocache and the restaurant
 */

import MapKit
import UIKit
import Foundation

class NearbyFoodEntryViewController: UIViewController {
    var restaurant:Restaurant = Restaurant()
    var geocacheLocation:CLLocation = CLLocation()
    
    @IBOutlet weak var restaurantName: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        restaurantName.text = restaurant.name
        
        let restLat:Double = restaurant.latitude
        let restLon:Double = restaurant.longitude
        let geoLat:Double = geocacheLocation.coordinate.latitude
        let geoLon:Double = geocacheLocation.coordinate.longitude
        
        let distance:Double = geocacheLocation.distanceFromLocation(CLLocation(latitude: restaurant.latitude, longitude: restaurant.longitude))
        
        let middlePoint = CLLocationCoordinate2D(latitude: ((restLat + geoLat)/2.0), longitude: ((restLon + geoLon)/2.0))
        let region: MKCoordinateRegion = MKCoordinateRegionMakeWithDistance(middlePoint, 0.5 * distance, 0.5 * distance)
        
        mapView.setRegion(region, animated: true)
        
        
        // Set annotations
        let restCoord = CLLocationCoordinate2D(latitude: restLat, longitude: restLon)
        let geoCoord = CLLocationCoordinate2D(latitude: geoLat, longitude: geoLon)
        
        // Add Restaurant Annotation
        let restAnnotation = MKPointAnnotation()
        restAnnotation.coordinate = restCoord
        restAnnotation.title = restaurant.name
        self.mapView.addAnnotation(restAnnotation)
        
        // Add Geocache Annotation
        let geoAnnotation = MKPointAnnotation()
        geoAnnotation.coordinate = geoCoord
        geoAnnotation.title = "Geocache"
        self.mapView.addAnnotation(geoAnnotation)
    }

}
