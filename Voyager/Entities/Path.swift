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
    dynamic var end: Location!
    dynamic var initialList = List<Location>()
    dynamic var modificationDate = NSDate()
    
    func executeOrder() {
        var fullList = List<Location>()
        fullList.append(start)
        for var i = 0; i < initialList.count; i++ {
            fullList.append(initialList[i])
        }
        fullList.append(end)
    }
}