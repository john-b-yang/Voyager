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
    dynamic var start: GMSPlace!
    dynamic var initialList: [GMSPlace]!
    dynamic var modificationDate = NSDate()
}