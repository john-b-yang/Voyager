//
//  Path.swift
//  Voyager
//
//  Created by John Yang on 7/9/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import Foundation
import GoogleMaps
import RealmSwift

class Path : Object {
    dynamic var pathName: String = "Placeholder"
    dynamic var start: Location!
    dynamic var initialList = List<Location>()
    dynamic var modificationDate = NSDate()
    
    dynamic var locationList = List<Location>()
    dynamic var totalDistance: Int = 0
    dynamic var totalTime: Int = 0
    
    func createPath() {
        var tempList = [Location]()
        tempList.append(start)
        for var i = 0; i < initialList.count; i++ {
            tempList.append(initialList[i])
        }
        
        for var i = 0; i < tempList.count; i++ {
            locationList.append(tempList[i])
        }
        
        println(locationList)
    }
}