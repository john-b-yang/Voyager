//
//  Location.swift
//  Voyager
//
//  Created by John Yang on 7/20/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import Foundation

//All variables correspond with GMSPlace object
class Location : Object {
    dynamic var name: String! //name
    dynamic var placeID: String! //placeID
    dynamic var latitude: double! //GMSPlace => coordinate => (CLLocation) Coordinate2D => Degrees* => double
    dynamic var longitude: double! //Same as latitude except other number
    dynamic var address: String! //formattedAddress
}