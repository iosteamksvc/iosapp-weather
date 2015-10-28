//
//  InfoHourController.swift
//  kzWeather
//
//  Created by Vinh Hua on 10/14/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import Cartography
import WeatherIconsKit

class InfoHourView : UIView {
    private var didSetupConstraints = false
    private let iconLabel = UILabel()
    private let hourLabel = UILabel()
    private let tempsLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
        style()
    }
    
    required init(coder aDecoder: NSCoder) {
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
private extension InfoHourView {
    func setup(){
        addSubview(iconLabel)
        addSubview(hourLabel)
        addSubview(tempsLabel)
    }
}

// MARK: Layout
private extension InfoHourView {
    func layoutView() {
        constrain(iconLabel) { view in
            view.center == view.superview!.center
            view.height == 50
        }
        constrain(hourLabel) { view in
            view.centerX == view.superview!.centerX
            view.top == view.superview!.top
        }
        constrain(tempsLabel) { view in
            view.centerX == view.superview!.centerX
            view.bottom == view.superview!.bottom
        }
    }
}

// MARK: Style
private extension InfoHourView {
    func style(){
        iconLabel.textColor = UIColor.whiteColor()
        iconLabel.attributedText = WIKFontIcon.wiDaySunnyIconWithSize(20).attributedString()
        hourLabel.text = "00:00"
        hourLabel.font = UIFont.latoFontOfSize(18)
        hourLabel.textColor = UIColor.whiteColor()
        tempsLabel.text = "0°"
        tempsLabel.font = UIFont.latoFontOfSize(18)
        tempsLabel.textColor = UIColor.whiteColor()
        
    }
}


// MARK: Render
/*extension InfoHourView {
    func render(){
        var dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        hourLabel.text = dateFormatter.stringFromDate(NSDate())
        iconLabel.attributedText = WIKFontIcon.wiDaySunnyIconWithSize(30).attributedString()
        
        tempsLabel.text = "5° 8°"
    }
}*/

// MARK: Render
extension InfoHourView {
    func render(weatherCondition: WeatherCondition) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        hourLabel.text = dateFormatter.stringFromDate(weatherCondition.time)
        iconLabel.attributedText = iconStringFromIcon(weatherCondition.icon!, size: 30)
        
        //var usesMetric = false
        //if let localeSystem = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool {
        //   usesMetric = localeSystem
        //}
        
        //if usesMetric {
            tempsLabel.text = "\(weatherCondition.minTempCelsius.roundToInt())° \(weatherCondition.maxTempCelsius.roundToInt())°"
        //} else {
        //    tempsLabel.text = "\(weatherCondition.minTempFahrenheit.roundToInt())° \(weatherCondition.maxTempFahrenheit.roundToInt())°"
        //}
    }
}

