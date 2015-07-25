//
//  JSONParser.swift
//  Voyager
//
//  Created by John Yang on 7/24/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import SwiftyJSON
import Foundation

class JSONParser {
    
    var json: JSON
    
   static func synchronousRequest (urlStr: String) -> NSString?{
        var nsurlstr = urlStr.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        if let url: NSURL! = NSURL(string: nsurlstr){
            var request = NSMutableURLRequest(URL: url!)
            request.HTTPMethod = "GET"
            var response: NSURLResponse?
            var error: NSError?
            let urlData = NSURLConnection.sendSynchronousRequest(request, returningResponse: &response, error: &error)
            var dataString =  NSString(data: urlData!, encoding: NSUTF8StringEncoding)
            println(dataString)
            
            return dataString!
        }
        return nil
    }
    
    init(jsonString: NSData) {
            json = JSON(data: jsonString)
    }
    
    func getDistance() -> Int {
        let routes = json["routes"].arrayValue
        let legs = routes[0]["legs"].arrayValue
        let distance = legs[0]["distance"].dictionaryValue
        let distanceText = distance["text"]!.stringValue
        let distanceArray = split(distanceText) {$0 == " "}
        let stringReturn = distanceArray[0].stringByReplacingOccurrencesOfString(",", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        let returnValue = stringReturn.toInt()!
        println(returnValue)
        return returnValue
    }
    
    func getTime() -> Int {
        let routes = json["routes"].arrayValue
        let legs = routes[0]["legs"].arrayValue
        let time = legs[0]["duration"].dictionaryValue
        let timeText = time["text"]!.stringValue
        
        let daysArray = timeText.componentsSeparatedByString(" days")
        let hoursArray = daysArray[daysArray.count - 1].componentsSeparatedByString(" hours")
        let minutesArray = hoursArray[hoursArray.count - 1].componentsSeparatedByString(" mins")
        println("\(daysArray) + \(hoursArray) + \(minutesArray)")
        
        var dayString = daysArray[0]
        var hoursString = hoursArray[0]
        var minutesString = minutesArray[0]
        
        //Check if the strings are valid (in case actual time only has hours, minutes, not days
        //If ok, then convert to int. If not, just return 0
        
        return 0
    }
}