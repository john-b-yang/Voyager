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
    dynamic var totalDistance: Double = 0
    dynamic var totalTime: Int = 0
    
    dynamic var units: String!
    
    //To reset algorithm / take it out, uncomment the lines
    func createPath() {
        var tempList = [Location]()
        //tempList.append(start)
        for var i = 0; i < initialList.count; i++ {
            tempList.append(initialList[i])
        }
        //tempList.append(start)
        
        var pathFinder = Algorithm()
        var (finalPath, finalDistance) = pathFinder.algo(start, initialList: tempList)
        units = pathFinder.getDistanceUnits()
        //var finalPath = tempList
        
        totalDistance = finalDistance
        for var i = 0; i < finalPath.count; i++ {
            locationList.append(finalPath[i])
        }
    }
}