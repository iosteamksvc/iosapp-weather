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
import Cartography

class ViewController: UIViewController, UIScrollViewDelegate {
    
    private let currentWeatherView = CurrentWeatherView(frame: CGRectZero)
    private let hourlyForecastView = WeatherHourlyForecastView(frame: CGRectZero)
    private let daysForecastView = WeatherDaysForecastView(frame: CGRectZero)
    private let scrollView = UIScrollView()
    private var locationService: LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //self.view.addSubview(currentWeatherView)
        //self.view.addSubview(hourlyForecastView)
        //self.view.addSubview(daysForecastView)
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(currentWeatherView)
        scrollView.addSubview(hourlyForecastView)
        scrollView.addSubview(daysForecastView)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        layoutView()

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
            
            weatherDatastore.retrieveHourlyForecastAtLat(location.lat, lon: location.lon) {
                hourlyWeatherConditions in
                    self?.renderHourly(hourlyWeatherConditions)
                    return
            }
            weatherDatastore.retrieveDailyForecastAtLat(location.lat, lon: location.lon, dayCnt: 7) {
                hourlyWeatherConditions in
                self?.renderDaily(hourlyWeatherConditions)
                return
            }
        }
    }
}

// MARK: Layout
private extension ViewController {
    func layoutView() {
        constrain(scrollView) { view in
            view.top == view.superview!.top
            view.bottom == view.superview!.bottom
            view.left == view.superview!.left
            view.right == view.superview!.right
        }
        
        constrain(currentWeatherView) { view in
            // view.top == view.superview!.top + 50
            view.width == view.superview!.width
            view.centerX == view.superview!.centerX
        }
        
        constrain(hourlyForecastView, currentWeatherView) { view, view2 in
            view.top == view2.bottom + 20
            view.width == view.superview!.width
            view.centerX == view.superview!.centerX
        }
        
        constrain(daysForecastView, hourlyForecastView) { view, view2 in
            view.top == view2.bottom
            view.width == view2.width
            view.bottom == view.superview!.bottom - 20
            view.centerX == view.superview!.centerX
        }
        
        let currentWeatherInsect: CGFloat = view.frame.height - 160 - 10
        constrain(currentWeatherView) { view in
            view.top == view.superview!.top + currentWeatherInsect
            return
        }
        
        
    }
}

// MARK: Render
private extension ViewController {
    func renderCurrent(currentWeatherConditions: WeatherCondition){
        
        if currentWeatherConditions.windSpeed > 38.0 {
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "kzWeather"
            localNotification.alertBody = "It's going to be windy today!"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 8)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
        if currentWeatherConditions.rain == 1.0 {
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "kzWeather"
            localNotification.alertBody = "Don't forget your umbrella today!"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 8)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
        
        if currentWeatherConditions.maxTempCelsius >= 35 {
            
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "kzWeather"
            localNotification.alertBody = "It's going to be Hot today!"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 8)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        }
        
        if currentWeatherConditions.minTempCelsius <= 20 {
            
            let localNotification:UILocalNotification = UILocalNotification()
            localNotification.alertAction = "kzWeather"
            localNotification.alertBody = "It's going to be Cold today!"
            localNotification.fireDate = NSDate(timeIntervalSinceNow: 8)
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
            
        }
        
        
        currentWeatherView.render(currentWeatherConditions)
    }
    
    func renderHourly(weatherConditions: Array<WeatherCondition>){
        hourlyForecastView.render(weatherConditions)
    }
    
    func renderDaily(weatherConditions: Array<WeatherCondition>){
        daysForecastView.render(weatherConditions)
    }
}


