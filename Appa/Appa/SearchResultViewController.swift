//
//  SearchResultViewController.swift
//  Appa
//
//  Created by Tyler Brockett on 4/6/16.
//  Copyright © 2016 ASU. All rights reserved.
//

import MapKit
import UIKit
import Foundation

class SearchResultViewController: UIViewController {
    
    var geocache:Geocache?
    var baseLocation:CLLocation = CLLocation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    var restaurants:[Restaurant] = []
    
    // viewDidLoad() - loads view into the memory and does view initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if geocache != nil {
            self.name.text = geocache!.name!
            self.desc.text = geocache!.desc!
            NSLog("Lat \(geocache!.latitude!) Lon \(geocache!.longitude!)")
            self.latitude.text = String(format:"%.3f", Double(geocache!.latitude!))
            self.longitude.text = String(format:"%.3f", Double(geocache!.longitude!))
            
            let center:CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: Double(geocache!.latitude!), longitude: Double(geocache!.longitude!))
            let width = 1000.0 // meters
            let height = 1000.0
            let region = MKCoordinateRegionMakeWithDistance(center, width, height)
            mapView.setRegion(region, animated: true)
            
            // Add Geocache Annotation
            let geoAnnotation = MKPointAnnotation()
            geoAnnotation.coordinate = center
            geoAnnotation.title = "Geocache"
            self.mapView.addAnnotation(geoAnnotation)
            
            let task:NetworkAsyncTask = NetworkAsyncTask()
            task.getForecast(Double(geocache!.latitude!), lon: Double(geocache!.longitude!), callback: { (res:WeatherForecast?, error:String?) -> Void in
                if error != nil {
                    NSLog(error!.localizedCapitalizedString)
                } else {
                    self.setForecastData(res)
                }
            })
        } else {
            NSLog("Geocache object should never be nil")
        }
        
    }
    
    
    func setForecastData(forecast:WeatherForecast?) {
        if forecast != nil {
            self.currentTemp.text = forecast!.getTemp() + " F"
            self.lowTemp.text = forecast!.getLow() + " F"
            self.highTemp.text = forecast!.getHigh() + " F"
            self.weatherDescription.text = forecast!.getDescription()
        } else {
            self.currentTemp.text = "Error"
            self.lowTemp.text = "Error"
            self.highTemp.text = "Error"
            self.weatherDescription.text = "Error"
        }
    }
    
    @IBAction func foodNearby(sender: UIButton) {
        if let lat:Double = (latitude.text! as NSString).doubleValue, lon:Double = (longitude.text! as NSString).doubleValue {
            let task = NetworkAsyncTask()
            task.getFoodNearby(lat, lon: lon, radius: 5.0, callback: { (res:[Restaurant]?, error: String?) -> Void in
                if error == nil && res != nil {
                    self.restaurants = res!
                    self.performSegueWithIdentifier("nearbyFood", sender: nil)
                } else {
                    NSLog(error!)
                }
            })
        } else {
        
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "nearbyFood"){
            if let viewController: NearbyFoodViewController = segue.destinationViewController as? NearbyFoodViewController {
                viewController.restaurants = self.restaurants
                if let lat:Double = (latitude.text! as NSString).doubleValue, lon:Double = (longitude.text! as NSString).doubleValue {
                    viewController.geocacheLocation = CLLocation(latitude: lat, longitude: lon)
                }
            }
        }
        if(segue.identifier == "newLogEntry"){
            if let viewController:NewLogEntryViewController = segue.destinationViewController as? NewLogEntryViewController {
                viewController.geocache = self.geocache!
            }
        }
    }
    
    
}