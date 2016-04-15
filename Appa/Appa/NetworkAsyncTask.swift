/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              NetworkAsyncTask.swift
 * @class-description       Sends HTTP GET request to servers to gather data, passes the closure/callback around where necessary, and eventualy calls the callback
 */

import Foundation
import MapKit

class NetworkAsyncTask {
    
    // Open Weather Map API
    let OWM_API_KEY:String = "9586fe3af38f8380394b49cf1668a804"
    // Google GeoLocation API
    let GOOGLE_API_KEY:String = "AIzaSyBYrFWP2pX9TmFm-mNQk2YRRk5j0vEC9EE"
    
    init(){ } // Nothing needed for now
    
    func httpGet(url: String,
        callback: (String, String?) -> Void) {
            let request = NSMutableURLRequest(URL: NSURL(string: url)!)
            request.HTTPMethod = "GET"
            sendHttpRequest(request, callback: callback)
    }
    
    func sendHttpRequest(request: NSMutableURLRequest,
        callback: (String, String?) -> Void) {
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
                (data, response, error) -> Void in
                if (error != nil) {
                    callback("", error!.localizedDescription)
                } else {
                    dispatch_async(dispatch_get_main_queue(),
                        {callback(NSString(data: data!,
                            encoding: NSUTF8StringEncoding)! as String, nil)})
                }
            }
            task.resume()
    }
    
    func getForecast(lat:Double, lon:Double, callback: (WeatherForecast?, String?) -> Void) -> Bool {
        let url:String = "http://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=\(OWM_API_KEY)&units=imperial"
        
        httpGet(url, callback: { (res:String, error: String?) -> Void in
            if error != nil {
                NSLog(error!)
                callback(nil, error)
            } else {
                let forecast:WeatherForecast = WeatherForecast(result: res)
                if forecast.hasError() {
                    callback(nil, "Error parsing forecast data")
                } else {
                    callback(forecast, nil)
                }
            }
        })
            
        return true
    }
    
    func getFoodNearby(lat:Double, lon:Double, radius:Double, callback: ([Restaurant]?, String?) -> Void) -> Bool {
        let rad:Double = 1609.34 * radius // 1609 meters in a mile
        let url:String = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(lat),\(lon)&radius=\(rad)&types=food&key=\(GOOGLE_API_KEY)"
        httpGet(url, callback: { (res:String, error: String?) -> Void in
            if error != nil {
                callback(nil, "Error occurred")
            } else {
                if let data: NSData = res.dataUsingEncoding(NSUTF8StringEncoding){
                    do{
                        NSLog("Restaurant Result: \n\n\(res)")
                        let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                        if ((dict!["status"] as! String) == "OK") {
                            let results:NSArray = dict!["results"] as! NSArray
                            var returnArray:[Restaurant] = []
                            for var i = 0; i < results.count; i++ {
                                let restaurant:Restaurant = Restaurant(dict: results[i] as! NSDictionary)
                                returnArray.append(restaurant)
                            }
                            callback(returnArray, nil)
                        } else {
                            callback(nil, "Error")
                        }
                    } catch let error as NSError {
                        NSLog(error.localizedDescription)
                        callback(nil, error.localizedDescription)
                    }
                } else {
                    callback(nil, "Error")
                }
            }
        })
        return true
    }
    
}
