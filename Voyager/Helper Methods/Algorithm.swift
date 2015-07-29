//
//  Algorithm.swift
//  Voyager
//
//  Created by John Yang on 7/28/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import Foundation

class Algorithm {
    var distanceMatrix = Array<Array<Double>>()
    var timeMatrix = Array<Array<Int>>()
    
    func executeOrder(start: Location, end: Location, initialList: [Location]) {
        var fullList = [Location]()
        fullList.append(start)
        println(start.placeID)
        for var i = 0; i < initialList.count; i++ {
            fullList.append(initialList[i])
            println(initialList[i].placeID)
        }
        fullList.append(end)
        println(end.placeID)
        
        var parser = URLParser()
        
        var tempDistanceArray = Array<Double>()
        var tempTimeArray = Array<Int>()
        
        for column in 0...fullList.count - 1 {
            
            var start = fullList[column].placeID
            
            for row in 0...fullList.count - 1 {
                
                var end = fullList[row].placeID
                parser.createURL(start, end: end)
                println("NEW: \(parser.urlRequest)")
                tempDistanceArray.append(parser.getDistance())
                println(parser.getDistance())
                //tempTimeArray.append(parser.getTime())
            }
            distanceMatrix.append(tempDistanceArray)
            //timeMatrix.append(tempTimeArray)
        }
    }
}