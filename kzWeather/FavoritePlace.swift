//
//  FavoritePlace.swift
//  kzWeather
//
//  Created by Vinh Hua on 10/22/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit

class FavoritePlace {
    
    // MARK: Properties
    var name: String
    
    // MARK: Initialization
    init?(name: String){
        // Initialize stored properties.
        self.name = name
        
        // Initialization should fail if there is no name or if the rating is negative
        if name.isEmpty {
            return nil
        }
    }
}
