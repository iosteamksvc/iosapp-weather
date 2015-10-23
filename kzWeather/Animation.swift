//
//  Animation.swift
//  kzWeather
//
//  Created by BACKUP-PC on 10/23/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import Foundation

import UIKit

var duration = 0.7
var delay = 0.0
var damping = 0.7
var velocity = 0.7

func springWithDelay(duration: NSTimeInterval, delay: NSTimeInterval, animations: (() -> Void)!) {
    
    UIView.animateWithDuration(duration, delay: delay, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.8, options: [], animations: {
        
        animations()
        
        }, completion: { finished in
            
    })
}

