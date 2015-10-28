//
//  CurrentWeatherView.swift
//  kzWeather
//
//  Created by BACKUP-PC on 10/21/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit
import Cartography
import LatoFont
import WeatherIconsKit

class CurrentWeatherView: UIView {
    private var didSetupConstraints = false
    private let cityLbl = UILabel()
    private let maxTempLbl = UILabel()
    private let minTempLbl = UILabel()
    private let iconLbl = UILabel()
    private let weatherLbl = UILabel()
    private let currentTempLbl = UILabel()
    private var heatIndexIv = UIImageView()
    
    //-------- Wind Area Start -------------------
    private let windSpeedlbl = UILabel()
    private var windBagIv = UIImageView()
    private let windTextlbl = UILabel()
    //-------- Wind Area End ---------------------
    //-------- Rain Area Start -------------------
    private let rainLevellbl = UILabel()
    private var umbrellaIv = UIImageView()
    private let rainTextlbl = UILabel()
    //-------- Rain Area End ---------------------
    //-------- Humidity Area Start ---------------
    private let humidityLevellbl = UILabel()
    private var humidityIv = UIImageView()
    private let humidityTextlbl = UILabel()
    //-------- Humidity Area End -----------------
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
        currentForcastAnimation()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func updateConstraints() {
        if didSetupConstraints {
            super.updateConstraints()
            return
        }
        layoutView()
        super.updateConstraints()
        didSetupConstraints = true
    }
    
}

// MARK: Setup
private extension CurrentWeatherView{
    func setup(){
        addSubview(cityLbl)
        addSubview(currentTempLbl)
        addSubview(maxTempLbl)
        addSubview(minTempLbl)
        addSubview(iconLbl)
        addSubview(weatherLbl)
        
        let image = UIImage(named: "heatindex")
        heatIndexIv = UIImageView(image: image!)
        addSubview(heatIndexIv)
        
        //---------Wind Area Start ---------------
        let windBagImage = UIImage(named: "windbag")
        windBagIv = UIImageView(image: windBagImage!)
        addSubview(windBagIv)
        addSubview(windSpeedlbl)
        addSubview(windTextlbl)
        //---------Wind Area End ---------------
        
        //---------Rain Area Start ---------------
        let umbrellaImage = UIImage(named: "umbrella")
        umbrellaIv = UIImageView(image: umbrellaImage!)
        addSubview(umbrellaIv)
        addSubview(rainLevellbl)
        addSubview(rainTextlbl)
        //---------Rain Area End ---------------
        
        //---------Humidity Area Start ---------------
        let humidityImage = UIImage(named: "humidity")
        humidityIv = UIImageView(image: humidityImage!)
        addSubview(humidityIv)
        addSubview(humidityLevellbl)
        addSubview(humidityTextlbl)
        //---------Humidity Area End ---------------
        
    }
}

// MARK: Layout
private extension CurrentWeatherView{
    func layoutView(){
        constrain(self) { view in
           view.height == 200
        }
        constrain(iconLbl) { view in
            view.top == view.superview!.top
            view.left == view.superview!.left + 20
            view.width == 30
            view.width == view.height
        }
        constrain(weatherLbl, iconLbl) { view, view2 in
            view.top == view2.top
            view.left == view2.right + 10
            view.height == view2.height
            view.width == 200
        }
        
        constrain(currentTempLbl, iconLbl) { view, view2 in
            view.top == view2.bottom
            view.left == view2.left
        }
        
        //-----Wind Speed Area Start--------------
        constrain(windTextlbl, currentTempLbl) { view, view2 in
            view.top == view2.top + 35
            view.left == view2.right + 30
        }
        constrain(windBagIv, windTextlbl) { view, view2 in
            view.top == view2.bottom
            view.left == view2.left
            view.width == 10
            view.height == 10
        }
        constrain(windSpeedlbl, windBagIv) { view, view2 in
            view.top == view2.top
            view.left == view2.right + 5
        }
        //-----Wind Speed Area End--------------
        
        //-----Rain Area Start--------------
        constrain(rainTextlbl, windBagIv) { view, view2 in
            view.top == view2.bottom + 5
            view.left == view2.left
        }
        constrain(umbrellaIv, rainTextlbl) { view, view2 in
            view.top == view2.bottom
            view.left == view2.left
            view.width == 10
            view.height == 10
        }
        constrain(rainLevellbl, umbrellaIv) { view, view2 in
            view.top == view2.top
            view.left == view2.right + 5
        }
        //-----Rain Speed Area End--------------
        
        //-----Humidity Area Start--------------
        constrain(humidityTextlbl, umbrellaIv) { view, view2 in
            view.top == view2.bottom + 5
            view.left == view2.left
        }
        constrain(humidityIv, humidityTextlbl) { view, view2 in
            view.top == view2.bottom
            view.left == view2.left
            view.width == 10
            view.height == 10
        }
        constrain(humidityLevellbl, humidityIv) { view, view2 in
            view.top == view2.top
            view.left == view2.right + 5
        }
        //-----Humidity Area End--------------
        
        
        constrain(currentTempLbl, minTempLbl) { view, view2 in
            view.bottom == view2.top
            view.left == view2.left
        }
        
        constrain(minTempLbl) { view in
            view.bottom == view.superview!.bottom
            view.height == 30
        }
        
        constrain(heatIndexIv, minTempLbl) { view, view2 in
            view.top == view2.top + 11
            view.left == view2.right + 5
            view.width == 200
            view.height == 10
        }
        
        
        constrain(maxTempLbl, minTempLbl) { view, view2 in
            view.top == view2.top
            view.height == view2.height
            view.left == view2.right + 210
        }
        constrain(cityLbl) { view in
            view.top == view.superview!.top
            view.right == view.superview!.right - 10
            view.height == 30
            view.width == 200
        }
    }
}

// MARK: Style
private extension CurrentWeatherView{
    func style(){
        iconLbl.textColor = UIColor.whiteColor()
        weatherLbl.font = UIFont.latoLightFontOfSize(20)
        weatherLbl.textColor = UIColor.whiteColor()
        
        currentTempLbl.font = UIFont.latoLightFontOfSize(96)
        currentTempLbl.textColor = UIColor.whiteColor()
        
        maxTempLbl.font = UIFont.latoLightFontOfSize(18)
        maxTempLbl.textColor = UIColor(red: 245/255.0, green: 6/255.0, blue: 93/255.0, alpha: 1.0)
        
        minTempLbl.font = UIFont.latoLightFontOfSize(18)
        minTempLbl.textColor = UIColor(red: 0/255.0, green: 121/255.0, blue: 255/255.0, alpha: 1.0)
        
        cityLbl.font = UIFont.latoLightFontOfSize(18)
        cityLbl.textColor = UIColor.whiteColor()
        cityLbl.textAlignment = .Right
        
        windTextlbl.text = "WIND"
        windTextlbl.font = UIFont.latoLightFontOfSize(10)
        windTextlbl.textColor = UIColor.whiteColor()
        
        windSpeedlbl.text = "0.0"
        windSpeedlbl.font = UIFont.latoLightFontOfSize(8)
        windSpeedlbl.textColor = UIColor.whiteColor()
        
        rainTextlbl.text = "RAIN"
        rainTextlbl.font = UIFont.latoLightFontOfSize(10)
        rainTextlbl.textColor = UIColor.whiteColor()
        
        rainLevellbl.text = "0.0"
        rainLevellbl.font = UIFont.latoLightFontOfSize(8)
        rainLevellbl.textColor = UIColor.whiteColor()
        
        humidityTextlbl.text = "HUMIDITY"
        humidityTextlbl.font = UIFont.latoLightFontOfSize(10)
        humidityTextlbl.textColor = UIColor.whiteColor()
        
        humidityLevellbl.text = "0.0"
        humidityLevellbl.font = UIFont.latoLightFontOfSize(8)
        humidityLevellbl.textColor = UIColor.whiteColor()
        
        iconLbl.attributedText = WIKFontIcon.wiDaySunnyIconWithSize(20).attributedString()
        weatherLbl.text = "Sunny"
        minTempLbl.text = "4°"
        maxTempLbl.text = "10°"
        currentTempLbl.text = "6°"
        cityLbl.text = "Unknown"
        
    }
}

// MARK: Render
extension CurrentWeatherView{
    func render(weatherCondition: WeatherCondition){
        
        
        iconLbl.attributedText = iconStringFromIcon(weatherCondition.icon!, size: 20)
        weatherLbl.text = weatherCondition.weather
        minTempLbl.text = "\(weatherCondition.minTempCelsius.roundToInt())°"
        maxTempLbl.text = "\(weatherCondition.maxTempCelsius.roundToInt())°"
        currentTempLbl.text = "\(weatherCondition.tempCelsius.roundToInt())°"
        cityLbl.text = weatherCondition.cityName ?? ""
        rainLevellbl.text = "\(weatherCondition.rain)"
        windSpeedlbl.text = "\(weatherCondition.windSpeed)"
        humidityLevellbl.text = "\(weatherCondition.humidity)"
        
        
    }
}

// MARK: Animation

extension CurrentWeatherView {
    func currentForcastAnimation() {
        self.weatherLbl.transform = CGAffineTransformMakeTranslation(-300, 0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.weatherLbl.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.currentTempLbl.transform = CGAffineTransformMakeTranslation(300, 0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.currentTempLbl.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.cityLbl.transform = CGAffineTransformMakeTranslation(350, 0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.cityLbl.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.iconLbl.transform = CGAffineTransformMakeTranslation(-200,0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.iconLbl.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.windTextlbl.transform = CGAffineTransformMakeTranslation(-350,0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.windTextlbl.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.windBagIv.transform = CGAffineTransformMakeTranslation(0, -600)
        springWithDelay(0.9, delay: 0.25, animations: {
            self.windBagIv.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.umbrellaIv.transform = CGAffineTransformMakeTranslation(0, -600)
        springWithDelay(0.9, delay: 0.35, animations: {
            self.umbrellaIv.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.humidityTextlbl.transform = CGAffineTransformMakeTranslation(350,0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.humidityTextlbl.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.humidityIv.transform = CGAffineTransformMakeTranslation(0, -600)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.humidityIv.transform = CGAffineTransformMakeTranslation(0, 0)
        })
        
        self.heatIndexIv.transform = CGAffineTransformMakeTranslation(-350, 0)
        springWithDelay(0.9, delay: 0.45, animations: {
            self.heatIndexIv.transform = CGAffineTransformMakeTranslation(0, 0)
        })
    }
    
}