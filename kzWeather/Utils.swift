//
//  Utils.swift
//  kzWeather
//
//  Created by BACKUP-PC on 10/22/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit

extension Double {
    func roundToInt() -> Int{
        return Int(round(self))
    }
}

func alertMessage(inTitle: String, inMessage: String){
    let alert = UIAlertView()
    alert.title = inTitle
    alert.message = inMessage
    alert.addButtonWithTitle("OK")
    alert.show()
}
