//
//  InfoHourController.swift
//  kzWeather
//
//  Created by Vinh Hua on 10/14/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit

class InfoHourController: UIView {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func intrinsicContentSize() -> CGSize {
        let height = Int(frame.size.height)
        let width = Int(frame.size.width)
        return CGSize(width: width, height: height)
    }
}
