/*
 * @authors                 Tyler Brockett, Shikha Mehta, Tam Le
 * @course                  ASU CSE 394
 * @project                 Group Project
 * @version                 April 15, 2016
 * @project-description     Allows users to track Geocaches
 * @class-name              WeatherForecast.swift
 * @class-description       Helper class to store information about the weather for a specific location
 */

import Foundation

class WeatherForecast {
    
    var current:String = ""
    var low:String = ""
    var high:String = ""
    var desc:String = ""
    var error:Bool = true
    
    init(result:String) {
        if let data: NSData = result.dataUsingEncoding(NSUTF8StringEncoding){
            do{
                print(result)
                let dict = try NSJSONSerialization.JSONObjectWithData(data, options: .MutableContainers) as? [String:AnyObject]
                let main:NSDictionary = dict!["main"]! as! NSDictionary
                let weather:NSArray = dict!["weather"] as! NSArray
                
                let c:Double = main["temp"] as! Double
                let l:Double = main["temp_min"] as! Double
                let h:Double = main["temp_max"] as! Double
                let d:String = weather[0]["main"] as! String
                
                self.current = String(format:"%.1f", c)
                self.low = String(format:"%.1f", l)
                self.high = String(format:"%.1f", h)
                self.desc = d
                self.error = false
            } catch let error as NSError {
                NSLog(error.localizedDescription)
            }
        } else {
            NSLog("Error parsing Weather Forecast data")
        }
    }
    
    func getTemp() -> String {
        return self.current
    }
    
    func getLow() -> String {
        return self.low
    }
    
    func getHigh() -> String {
        return self.high
    }
    
    func getDescription() -> String {
        return self.desc
    }
    
    func hasError() -> Bool {
        return self.error
    }
    
}

/* SAMPLE RESPONSE:

{
"coord":
    {
        "lon":-111.91,
        "lat":33.41},
        "weather":
            [
                {
                    "id":800,
                    "main":"Clear",
                    "description":"clear sky",
                    "icon":"01n"
                }
            ],
        "base":"cmc stations",
        "main":
            {
                "temp":72.54,
                "pressure":1015,
                "humidity":14,
                "temp_min":68,
                "temp_max":75.2
            },
        "wind":
            {
                "speed":3.36,
                "deg":250
            },
        "clouds":
            {
                "all":1
            },
        "dt":1460015468,
        "sys":
            {
                "type":1,
                "id":325,
                "message":0.0035,
                "country":"US",
                "sunrise":1460034375,
                "sunset":1460080391
            },
        "id":5317058,
        "name":"Tempe",
        "cod":200
    }
}

*/
