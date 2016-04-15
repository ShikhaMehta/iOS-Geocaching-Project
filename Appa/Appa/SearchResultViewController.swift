/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              SearchResultViewController.swift
 * @class-description       Displays details about single Geocache. Allows user to view weather data, logs, or nearby restaurants
 */

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
            
            // Get weather data
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
            self.currentTemp.text = forecast!.getTemp() + "\u{00B0}F" // \u{00B0} is the degree symbol
            self.lowTemp.text = forecast!.getLow() + "\u{00B0}F"
            self.highTemp.text = forecast!.getHigh() + "\u{00B0}F"
            self.weatherDescription.text = forecast!.getDescription()
        } else {
            self.currentTemp.text = "N/A"
            self.lowTemp.text = "N/A"
            self.highTemp.text = "N/A"
            self.weatherDescription.text = "N/A"
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
                    let alert = UIAlertController(title: "No Results", message: "There were no food locations found near this area. Sorry!", preferredStyle: UIAlertControllerStyle.Alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.Default, handler: nil))
                    self.presentViewController(alert, animated: true, completion: nil)
                    NSLog(error!)
                }
            })
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
        if(segue.identifier == "logs"){
            if let viewController:LogViewController = segue.destinationViewController as? LogViewController {
                viewController.geocache = self.geocache!
            }
        }
    }
    
}
