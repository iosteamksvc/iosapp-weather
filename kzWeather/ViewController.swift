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
    
    // 2015/10/23 Vinh Hua Quoc added start
    @IBAction func addToFavorite(sender: AnyObject) {
        currentPlace = FavoritePlace(name: (currentWeatherItem?.cityName)!, latitude: userLatitude, longtitude: userLongtitude)!
        saveFavoritePlaces()
    }
    
    @IBOutlet weak var btnAddFavorite: UIBarButtonItem!
    
    var favoritePlaces = [FavoritePlace]()
    
    var currentPlace: FavoritePlace?
    
    var currentWeatherItem: WeatherCondition?
    
    var userLatitude: Double!
    
    var userLongtitude: Double!
    
    var isLoadFavoritePlace: Bool!
    
    // MARK: NSCoding
    func saveFavoritePlaces() {
        
        let placeItem  = favoritePlaces.filter{ $0.name == self.currentPlace!.name  }.first
        //if (favoritePlaces.findMatchingValue( { $0.name == self.currentPlace!.name } ) == nil) {
        if (placeItem == nil) {
            favoritePlaces.append(currentPlace!)
        }
        //}
        
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoritePlaces, toFile: FavoritePlace.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            print("Failed to save favorite place...")
        }
    }
    
    func loadFavoritePlaces() -> [FavoritePlace]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(FavoritePlace.ArchiveURL.path!) as? [FavoritePlace]
    }
    
    // 2015/10/23 Vinh Hua Quoc added end
    
    override func viewDidLoad() {
        print("View Did Load")
        
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
        // MARK: 2015/10/23 Vinh Hua Quoc added start
        
        // Load saved the data.
        if let savedFavoritePlaces = loadFavoritePlaces() {
            favoritePlaces += savedFavoritePlaces
            btnAddFavorite.enabled = false
        }
        
        isLoadFavoritePlace = false;
        if let currentPlace = currentPlace
        //if !currentPlace!.name.isEmpty
        {
            print("Load_Name:" + currentPlace.name)
            print("Load_Latitide:\(currentPlace.latitude)")
            print("Load_Longtitude:\(currentPlace.longtitude)")
            isLoadFavoritePlace = true
        }
        // 2015/10/23 Vinh Hua Quoc added end
        
        layoutView()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        print("View Will Appear")

        super.viewWillAppear(animated)
        
        let weatherDatastore = WeatherDatastore()
        
        if isLoadFavoritePlace == false {
            print("isLoadFavoritePlace: false")
            locationService = LocationService() { [weak self] location in
            
            
                // 2015/10/26 Vinh Hua Quoc added start
                self!.userLatitude = location.lat
                self!.userLongtitude = location.lon
                //self!.currentPlace!.latitude = location.lat ?? 0
                //self!.currentPlace!.longtitude = location.lon ?? 0
                // 2015/10/26 Vinh Hua Quoc added end
            
            
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
        } else {
            print("isLoadFavoritePlace: true")
            locationService = LocationService() { [weak self] location in
                
                
                // 2015/10/26 Vinh Hua Quoc added start
                self!.userLatitude = location.lat
                self!.userLongtitude = location.lon
                //self!.currentPlace!.latitude = location.lat ?? 0
                //self!.currentPlace!.longtitude = location.lon ?? 0
                // 2015/10/26 Vinh Hua Quoc added end
                
                
                weatherDatastore.retrieveCurrentWeatherAtLat(self!.currentPlace!.latitude, lon: self!.currentPlace!.longtitude) {
                    currentWeatherConditions in
                    self?.renderCurrent(currentWeatherConditions)
                    return
                }
                
                weatherDatastore.retrieveHourlyForecastAtLat(self!.currentPlace!.latitude, lon: self!.currentPlace!.longtitude) {
                    hourlyWeatherConditions in
                    self?.renderHourly(hourlyWeatherConditions)
                    return
                }
                weatherDatastore.retrieveDailyForecastAtLat(self!.currentPlace!.latitude, lon: self!.currentPlace!.longtitude, dayCnt: 7) {
                    hourlyWeatherConditions in
                    self?.renderDaily(hourlyWeatherConditions)
                    return
                }
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
        
        //let currentWeatherInsect: CGFloat = view.frame.height - 10
        constrain(currentWeatherView) { view in
        view.top == view.superview!.top + 65
            return
        }
        
        
    }
}

// MARK: Render
private extension ViewController {
    
    func renderCurrent(currentWeatherConditions: WeatherCondition){
        
        // 2015/10/23 Vinh Hua Quoc added start
        
        print("Run render")
        
        currentWeatherItem = currentWeatherConditions
        
        let placeItem  = favoritePlaces.filter{ $0.name == currentWeatherItem?.cityName  }.first
        //if (favoritePlaces.findMatchingValue( { $0.name == self.currentPlace!.name } ) == nil) {
        if (placeItem == nil) {
            btnAddFavorite.enabled = true
        } else {
            btnAddFavorite.enabled = false
        }
        
        // 2015/10/23 Vinh Hua Quoc added end
        
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
        print("Run render 1")
        hourlyForecastView.render(weatherConditions)
    }
    
    func renderDaily(weatherConditions: Array<WeatherCondition>){
        print("Run render 2")
        daysForecastView.render(weatherConditions)
    }
}