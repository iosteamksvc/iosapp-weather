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

class ViewController: UIViewController {
    
    private let currentWeatherView = CurrentWeatherView(frame: CGRectZero)
    private let hourlyForecastView = WeatherHourlyForecastView(frame: CGRectZero)
    private let daysForecastView = WeatherDaysForecastView(frame: CGRectZero)
    
    private var locationService: LocationService?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(currentWeatherView)
        self.view.addSubview(hourlyForecastView)
        self.view.addSubview(daysForecastView)
        
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
    }
}

// MARK: Render
private extension ViewController {
    func renderCurrent(currentWeatherConditions: WeatherCondition){
        currentWeatherView.render(currentWeatherConditions)
    }
    
    func renderHourly(weatherConditions: Array<WeatherCondition>){
        hourlyForecastView.render(weatherConditions)
    }
    
    func renderDaily(weatherConditions: Array<WeatherCondition>){
        daysForecastView.render(weatherConditions)
    }
}

