//
//  InfoDayView.swift
//  kzWeather
//
//  Created by BACKUP-PC on 10/21/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import Foundation
import Cartography
import WeatherIconsKit


class InfoDayView: UIView {
    private var didSetupConstraints = false
    private let iconLabel = UILabel()
    private let dayLabel = UILabel()
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
private extension InfoDayView{
    func setup(){
        addSubview(dayLabel)
        addSubview(iconLabel)
        addSubview(tempsLabel)
    }
}

// MARK: Layout
private extension InfoDayView{
    func layoutView() {
        constrain(self) { view in
            view.height == 50
        }
        
        constrain(iconLabel) { view in
            view.centerY == view.superview!.centerY
            view.left == view.superview!.left + 20
            view.width == view.height
            view.height == 50
        }
        
        constrain(dayLabel, iconLabel) { view, view2 in
            view.centerY == view.superview!.centerY
            view.left == view2.right + 20
        }
        
        constrain(tempsLabel) { view in
            view.centerY == view.superview!.centerY
            view.right == view.superview!.right - 20
        }
    }
}

// MARK: Style
private extension InfoDayView{
    func style(){
        iconLabel.textColor = UIColor.whiteColor()
        dayLabel.font = UIFont.latoFontOfSize(20)
        dayLabel.textColor = UIColor.whiteColor()
        tempsLabel.font = UIFont.latoFontOfSize(20)
        tempsLabel.textColor = UIColor.whiteColor()
    }
}


// MARK: Render
extension InfoDayView{
    func render(weatherCondition: WeatherCondition){
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "EEEE"
        dayLabel.text = dateFormatter.stringFromDate(weatherCondition.time)
        iconLabel.attributedText = iconStringFromIcon(weatherCondition.icon!, size: 30)
        
        //var usesMetric = false
        //if let localeSystem = NSLocale.currentLocale().objectForKey(NSLocaleUsesMetricSystem) as? Bool {
        //    usesMetric = localeSystem
        //}
        
        //if usesMetric {
            tempsLabel.text = "\(weatherCondition.minTempCelsius.roundToInt())°     \(weatherCondition.maxTempCelsius.roundToInt())°"
        //} else {
        //    tempsLabel.text = "\(weatherCondition.minTempFahrenheit.roundToInt())°     \(weatherCondition.maxTempFahrenheit.roundToInt())°"
        //}
    }
}