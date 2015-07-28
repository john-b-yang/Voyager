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
            //println(dataString) <= Shows the json
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
        return returnValue
    }
    
    func getTime() -> Int {
        let routes = json["routes"].arrayValue
        let legs = routes[0]["legs"].arrayValue
        let time = legs[0]["duration"].dictionaryValue
        let timeText = time["text"]!.stringValue
        
        var days = 0
        var hours = 0
        var minutes = 0
        
        
        //Check if the strings are valid (in case actual time only has hours, minutes, not days
        //If ok, then convert to int. If not, just return 0
        
        //For Days
        let daysArray = timeText.componentsSeparatedByString(" days")
        var dayString = daysArray[0].stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if dayString.rangeOfString("hours") == nil {
            if !dayString.isEmpty {
                days = dayString.toInt()!
                //println("\(days)")
            }
        }

        //For Hours
        let hoursArray = daysArray[daysArray.count - 1].componentsSeparatedByString(" hours")
        var hoursString = hoursArray[0].stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if hoursString.rangeOfString("minutes") == nil && hoursString.rangeOfString("days") == nil {
            if !hoursString.isEmpty {
                hours = hoursString.toInt()!
                //println("\(hours)")
            }
        }
        
        let minutesArray = hoursArray[hoursArray.count - 1].componentsSeparatedByString(" mins")
        var minutesString = minutesArray[0].stringByReplacingOccurrencesOfString(" ", withString: "", options: NSStringCompareOptions.LiteralSearch, range: nil)
        if minutesString.rangeOfString("hours") == nil && minutesString.rangeOfString("days") == nil {
            if !minutesString.isEmpty {
                minutes = minutesString.toInt()!
                //println("\(minutes)")
            }
        }
        
        //println("\(dayString) days + \(hoursString) hours + \(minutesString) minutes")

        var returnValue = (days * 24 * 60) + (hours * 60) + minutes
        //Return value in form of minutes
        return returnValue
    }
}