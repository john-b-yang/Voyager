
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
        urlRequest = "https://maps.googleapis.com/maps/api/directions/json?" + "origin=place_id:"
        urlRequest += start
        urlRequest += "&destination=place_id:"
        urlRequest += end
        
        /*
        Add if statements to append various commands that adjust the route given
        For example, adding the segment "&avoid=highways" will adjust the returned
        json so that the route will not include highways.
        
        Check dis: https://developers.google.com/maps/documentation/directions/intro
        */
        
        urlRequest += "&key="
        urlRequest += APIKey
        return urlRequest
    }
    
    func getDistance() -> Double {
        if let urlJson = JSONParser.synchronousRequest(urlRequest) {
            let dataFromNetwork = urlJson.dataUsingEncoding(NSUTF8StringEncoding)
            var parser = JSONParser(jsonString: dataFromNetwork!)
            return parser.getDistance()
        }
        return 0
    }
    
    func getTime() -> Int {
        if let urlJson = JSONParser.synchronousRequest(urlRequest) {
            let dataFromNetwork = urlJson.dataUsingEncoding(NSUTF8StringEncoding)
            var parser = JSONParser(jsonString: dataFromNetwork!)
            return parser.getTime()
        }
        return 0
    }
}