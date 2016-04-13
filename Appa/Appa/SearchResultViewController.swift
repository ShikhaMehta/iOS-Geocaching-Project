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
    var geocacheLocation:CLLocation = CLLocation()
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
    var restaurants:NSArray = NSArray()
    
    // viewDidLoad() - loads view into the memory and does view initialization
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if geocache != nil {
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
            task.getFoodNearby(lat, lon: lon, radius: 5.0, callback: { (res:NSArray?, error: String?) -> Void in
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
                    viewController.latitude = lat
                    viewController.longitude = lon
                }
            }
        }
    }
    
    
}