//
//  WeatherDaysForecastView.swift
//  kzWeather
//
//  Created by BACKUP-PC on 10/21/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import Foundation
import Cartography

class WeatherDaysForecastView: UIView {
    private var didSetupConstraints = false
    private var forecastCells = Array<InfoDayView>()
    
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
private extension WeatherDaysForecastView{
    func setup(){
        for _ in 0..<7 {
            let cell = InfoDayView(frame: CGRectZero)
            forecastCells.append(cell)
            addSubview(cell)
        }
    }
}

// MARK: Layout
private extension WeatherDaysForecastView{
    func layoutView(){
        
        constrain(forecastCells.first!) { view in
            view.top == view.superview!.top
        }
        
        for idx in 1..<forecastCells.count {
            let previousCell = forecastCells[idx-1]
            let cell = forecastCells[idx]
            constrain(cell, previousCell) { view, view2 in
                view.top == view2.bottom
            }
        }
        for cell in forecastCells {
            constrain(cell) { view in
                view.left == view.superview!.left
                view.right == view.superview!.right
            }
        }
        constrain(forecastCells.last!) { view in
            view.bottom == view.superview!.bottom
        }
    }
}


// MARK: Style
private extension WeatherDaysForecastView{
    func style(){
    }
}


// MARK: Render
extension WeatherDaysForecastView{
    func render(weatherConditions: Array<WeatherCondition>){
        for (idx, view) in forecastCells.enumerate() {
            view.render(weatherConditions[idx])
        }
    }
}
