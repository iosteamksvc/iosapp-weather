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

