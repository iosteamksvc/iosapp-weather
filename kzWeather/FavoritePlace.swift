//
//  FavoritePlace.swift
//  kzWeather
//
//  Created by Vinh Hua on 10/22/15.
//  Copyright © 2015 iosteamksvc. All rights reserved.
//

import UIKit


class FavoritePlace: NSObject, NSCoding {
    // MARK: Archiving Paths
    static let DocumentsDirectory = NSFileManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.URLByAppendingPathComponent("favoriteplaces")
    
    // MARK: Properties
    var name: String
    var latitude: Double
    var longtitude: Double
    
    // MARK: Types
    struct PropertyKey {
        static let nameKey = "name"
        static let latitudeKey = "latitude"
        static let longtitudeKey = "longtitude"
    }
    
    // MARK: Initialization
    init?(name: String, latitude: Double, longtitude: Double){
        // Initialize stored properties.
        self.name = name
        self.latitude = latitude
        self.longtitude = longtitude
        
        super.init()
        
        // Initialization should fail if there is no name or if the rating is negative
        if name.isEmpty {
            return nil
        }
    }
    
    // MARK: NSCoding
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeDouble(latitude, forKey: PropertyKey.latitudeKey)
        aCoder.encodeDouble(longtitude, forKey: PropertyKey.longtitudeKey)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let latitude = aDecoder.decodeDoubleForKey(PropertyKey.latitudeKey)
        let longtitude = aDecoder.decodeDoubleForKey(PropertyKey.longtitudeKey)
        // Must call designated initilizer.
        self.init(name: name, latitude: latitude, longtitude: longtitude)
    }
}
