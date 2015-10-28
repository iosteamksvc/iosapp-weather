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
    
    // child view current weather
    private let currentWeatherView = CurrentWeatherView(frame: CGRectZero)
    // child view hourly weather
    private let hourlyForecastView = WeatherHourlyForecastView(frame: CGRectZero)
    // child view days forecast
    private let daysForecastView = WeatherDaysForecastView(frame: CGRectZero)
    // parent scroll view
    private let scrollView = UIScrollView()
    // location service
    private var locationService: LocationService?
    
    // 2015/10/23 Vinh Hua Quoc added start
    
    // Action when click Favorite button
    @IBAction func addToFavorite(sender: AnyObject) {
        currentPlace = FavoritePlace(name: (currentWeatherItem?.cityName)!, latitude: userLatitude, longtitude: userLongtitude)!
        saveFavoritePlaces()
    }
    
    // Action when click Refresh button
    @IBAction func refreshLocation(sender: AnyObject) {
        print("Reload location")
        locationService = LocationService() {
            [weak self] location in
            
            self!.userLatitude = location.lat
            self!.userLongtitude = location.lon
            self!.callWeatherWebServer(location.lat, inLongtitude: location.lon)
        }
        scrollView.setNeedsDisplay()
    }
    
    // Label of favarite button
    @IBOutlet weak var btnAddFavorite: UIBarButtonItem!
    
    // Array content favorite places
    var favoritePlaces = [FavoritePlace]()
    
    // Current favorite place
    var currentPlace: FavoritePlace?
    
    // Current Weather Item
    var currentWeatherItem: WeatherCondition?
    
    // Current user Latitude
    var userLatitude: Double!
    // Current user longtitude
    var userLongtitude: Double!
    // Check if lacation from favorite array
    var isLoadFavoritePlace: Bool!
    
    // MARK: NSCoding
    
    // save favorite places
    func saveFavoritePlaces() {
        
        // Check current place is contains in favorite array
        let placeItem  = favoritePlaces.filter{ $0.name == self.currentPlace!.name  }.first
        
        if (placeItem == nil) {
            // add new location to favorite places
            favoritePlaces.append(currentPlace!)
            // disable btn favorite
            btnAddFavorite.enabled = false
        }
        
        // check is save success
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(favoritePlaces, toFile: FavoritePlace.ArchiveURL.path!)
        
        if !isSuccessfulSave {
            alertMessage(Constant.DIALOG_ERROR_TITLE, inMessage: Constant.MSG_ERROR_SAVE_FAVORITEPLACE)
        }
    }
    
    // load favorite places
    func loadFavoritePlaces() -> [FavoritePlace]? {
        return NSKeyedUnarchiver.unarchiveObjectWithFile(FavoritePlace.ArchiveURL.path!) as? [FavoritePlace]
    }
    
    // get Weather from Web Service
    func callWeatherWebServer(inLatitude: Double, inLongtitude: Double) {
        let weatherDatastore = WeatherDatastore()
        
        weatherDatastore.retrieveCurrentWeatherAtLat(inLatitude, lon: inLongtitude) {
            currentWeatherConditions in
            self.renderCurrent(currentWeatherConditions)
            return
        }
        
        weatherDatastore.retrieveHourlyForecastAtLat(inLatitude, lon: inLongtitude) {
            hourlyWeatherConditions in
            self.renderHourly(hourlyWeatherConditions)
            return
        }
        weatherDatastore.retrieveDailyForecastAtLat(inLatitude, lon: inLongtitude, dayCnt: 7) {
            hourlyWeatherConditions in
            self.renderDaily(hourlyWeatherConditions)
            return
        }

    }
    
    // 2015/10/23 Vinh Hua Quoc added end
    
    override func viewDidLoad() {
        print("View Did Load")
        
        super.viewDidLoad()
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.addSubview(currentWeatherView)
        scrollView.addSubview(hourlyForecastView)
        scrollView.addSubview(daysForecastView)
        scrollView.delegate = self
        view.addSubview(scrollView)
        
        // Load saved the data.
        if let savedFavoritePlaces = loadFavoritePlaces() {
            favoritePlaces += savedFavoritePlaces
            btnAddFavorite.enabled = false
        }
        
        // Check current location or load location
        isLoadFavoritePlace = false;
        if currentPlace != nil
        {
            isLoadFavoritePlace = true
        }
        
        // Set navigation bar style
        navigationController!.navigationBar.barTintColor = Constant.NAVIGATION_BAR_COLOR
        navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : Constant.NAVIGATION_TITLE_TEXT_COLOR]
        
        // Show layout
        layoutView()

    }

    override func viewWillAppear(animated: Bool) {
        print("View Will Appear")

        super.viewWillAppear(animated)
        
        // 2015/10/26 Vinh Hua Quoc added start
        if isLoadFavoritePlace == false {
            print("isLoadFavoritePlace: false")
            
            locationService = LocationService() {
                [weak self] location in
            
                self!.userLatitude = location.lat
                self!.userLongtitude = location.lon
                self!.callWeatherWebServer(location.lat, inLongtitude: location.lon)
            }
        } else {
            print("isLoadFavoritePlace: true")
            
            callWeatherWebServer((currentPlace?.latitude)!, inLongtitude: (currentPlace?.longtitude)!)
        }
        // 2015/10/26 Vinh Hua Quoc added end
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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