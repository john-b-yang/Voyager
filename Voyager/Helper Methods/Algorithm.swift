//
//  Algorithm.swift
//  Voyager
//
//  Created by John Yang on 7/28/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import Foundation

class Algorithm {
    var distanceMatrix: [[Double]]!
    var timeMatrix: [[Int]]!
    
    func buildFullList(start: Location, initialList: [Location]) -> [Location] {
        var fullList = [Location]()
        fullList.append(start)
        println(start.placeID)
        for var i = 0; i < initialList.count; i++ {
            fullList.append(initialList[i])
            println(initialList[i].placeID)
        }
        
        return fullList
    }
    
    func buildDistanceMatrix(start: Location, initialList: [Location]) -> [[Double]] {
        var fullList = buildFullList(start, initialList: initialList)
        
        var parser = URLParser()
        
        var tempDistanceArray: [Double]!
        var tempTimeArray: [Int]!
        
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
        
        return distanceMatrix
        
//        var locationList: [[Double]] = []
//        var tempList: [Double]
//        for var i = 0; i < distanceMatrix.count; i++ {
//            for var j = 0; j < distanceMatrix[0].count; j++ {
//                locationList.append(distanceMatrix)
//            }
//        }
//        
//        return locationList
    }
    
    //MARK: Algorithm
    func algo(start: Location, initialList: [Location]) -> [Location] {
        var fullList = buildFullList(start, initialList: initialList)
        return fullList
    }
}