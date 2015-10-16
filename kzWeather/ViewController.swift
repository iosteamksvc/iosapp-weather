//
//  ViewController.swift
//  kzWeather
//
//  Created by Vinh Hua on 10/14/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit
import LatoFont
import WeatherIconsKit

class ViewController: UIViewController {

    @IBOutlet weak var lblWeather: UILabel!
    
    @IBOutlet weak var lblIcon: UILabel!
    
    @IBOutlet weak var lblCurrentTemp: UILabel!
    
    @IBOutlet weak var lblMinTemp: UILabel!
    
    @IBOutlet weak var lblMaxTemp: UILabel!
    
    @IBOutlet weak var lblCity: UILabel!
    
    private var locationService: LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        styleCurrentWeatherView()
        renderCurrentWeatherView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        let weatherDatastore = WeatherDatastore()
        locationService = LocationService() { [weak self] location in
        
        weatherDatastore.retrieveCurrentWeatherAtLat(location.lat, lon: location.lon) {
            currentWeatherConditions in
            self?.renderCurrent(currentWeatherConditions)
            return
            }
        }
        
    }
    
    // MARK: Current Weather Area
    private func styleCurrentWeatherView() {
        lblIcon.textColor = UIColor.whiteColor()
        lblWeather.font = UIFont.latoLightFontOfSize(20)
        lblWeather.textColor = UIColor.whiteColor()
        
        lblCurrentTemp.font = UIFont.latoLightFontOfSize(96)
        lblCurrentTemp.textColor = UIColor.whiteColor()
        
        lblMaxTemp.font = UIFont.latoLightFontOfSize(18)
        lblMaxTemp.textColor = UIColor.whiteColor()
        
        lblMinTemp.font = UIFont.latoLightFontOfSize(18)
        lblMinTemp.textColor = UIColor.whiteColor()
        
        lblCity.font = UIFont.latoLightFontOfSize(18)
        lblCity.textColor = UIColor.whiteColor()
    }
    
    private func renderCurrentWeatherView() {
        lblIcon.attributedText = WIKFontIcon.wiDaySunnyIconWithSize(20).attributedString()
        lblWeather.text = "Sunny"
        lblMinTemp.text = "4°"
        lblMaxTemp.text = "10°"
        lblCurrentTemp.text = "6°"
        lblCity.text = "Ho Chi Minh City"
    }
    
}

private extension ViewController {
    func renderCurrent(weatherCondition: WeatherCondition){
        lblIcon.attributedText = iconStringFromIcon(weatherCondition.icon!, size: 20)
        lblWeather.text = weatherCondition.weather
        lblMinTemp.text = "\(weatherCondition.minTempCelsius.roundToInt())°"
        lblMaxTemp.text = "\(weatherCondition.maxTempCelsius.roundToInt())°"
        lblCurrentTemp.text = "\(weatherCondition.tempCelsius.roundToInt())°"
        lblCity.text = weatherCondition.cityName ?? ""
    }
}

private extension Double {
    func roundToInt() -> Int{
        return Int(round(self))
    }
}