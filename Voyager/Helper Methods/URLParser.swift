
//
//  URLParser.swift
//  Voyager
//
//  Created by John Yang on 7/24/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import Foundation

class URLParser {
    var urlRequest = "https://maps.googleapis.com/maps/api/directions/json?"
    var APIKey = "AIzaSyDogaZ1qJ4T7UVMqJKWKBXepNhlAbsMZyk"
    
    func createURL (start: String, end: String) -> String {
        urlRequest = urlRequest + "origin="
        urlRequest = urlRequest + start
        urlRequest = urlRequest + "&destination="
        urlRequest = urlRequest + end
        
        /*
        Add if statements to append various commands that adjust the route given
        For example, adding the segment "&avoid=highways" will adjust the returned
        json so that the route will not include highways.
        
        Check dis: https://developers.google.com/maps/documentation/directions/intro
        */
        
        urlRequest = urlRequest + "&key="
        urlRequest = urlRequest + APIKey
        return urlRequest
    }
}