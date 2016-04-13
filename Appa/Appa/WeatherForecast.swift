//
//  WeatherForecast.swift
//  Appa
//
//  Created by Tyler Brockett on 4/7/16.
//  Copyright © 2016 ASU. All rights reserved.
//

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
                
                self.current = String(main["temp"]!)
                self.low = String(main["temp_min"]!)
                self.high = String(main["temp_max"]!)
                self.desc = String(weather[0]["main"]!!)
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
