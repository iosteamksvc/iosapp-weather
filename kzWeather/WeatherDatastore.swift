//
//  WeatherDatastore.swift
//  kzWeather
//
//  Created by BACKUP-PC on 10/16/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import Foundation
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherDatastore {
    private let OPEN_WEATHER_API = "ec4276a6ee848207438a318a949056cb"
    
    func retrieveCurrentWeatherAtLat(lat: CLLocationDegrees, lon: CLLocationDegrees,
        block: (weatherCondition: WeatherCondition) -> Void) {
            let url = "http://api.openweathermap.org/data/2.5/weather"
            let params = ["lat":lat, "lon":lon, "appid":OPEN_WEATHER_API]
            
            Alamofire.request(.GET, url, parameters: params as? [String : AnyObject])
                .responseJSON{ response in
                    if response.result.isSuccess {
                        let jsonData = response.result.value as! NSDictionary
                        let json = JSON(jsonData)
                        block(weatherCondition: self.createWeatherConditionFromJson(json))
                    } else {
                        print("FUCKKKK")
                    }
            }
    }
    
}

private extension WeatherDatastore {
    func createWeatherConditionFromJson(json: JSON) -> WeatherCondition{
        let name = json["name"].string
        let weather = json["weather"][0]["main"].stringValue
        let icon = json["weather"][0]["icon"].stringValue
        let dt = json["dt"].doubleValue
        let time = NSDate(timeIntervalSince1970: dt)
        let tempKelvin = json["main"]["temp"].doubleValue
        let maxTempKelvin = json["main"]["temp_max"].doubleValue
        let minTempKelvin = json["main"]["temp_min"].doubleValue
        
        return WeatherCondition(
            cityName: name,
            weather: weather,
            icon: IconType(rawValue: icon),
            time: time,
            tempKelvin: tempKelvin,
            maxTempKelvin: maxTempKelvin,
            minTempKelvin: minTempKelvin)
    }
}
