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
    
    @IBOutlet weak var mapView: MKMapView!
    
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var desc: UITextField!
    @IBOutlet weak var longitude: UITextField!
    @IBOutlet weak var latitude: UITextField!
    
    @IBOutlet weak var currentTemp: UILabel!
    @IBOutlet weak var lowTemp: UILabel!
    @IBOutlet weak var highTemp: UILabel!
    @IBOutlet weak var weatherDescription: UILabel!
    
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
            self.currentTemp.text = forecast!.getTemp()
            self.lowTemp.text = forecast!.getLow()
            self.highTemp.text = forecast!.getHigh()
            self.weatherDescription.text = forecast!.getDescription()
        } else {
            self.currentTemp.text = "Error"
            self.lowTemp.text = "Error"
            self.highTemp.text = "Error"
            self.weatherDescription.text = "Error"
        }
    }
    
}