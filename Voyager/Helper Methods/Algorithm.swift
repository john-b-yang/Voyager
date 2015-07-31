//
//  Algorithm.swift
//  Voyager
//
//  Created by John Yang on 7/28/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import Foundation

class Algorithm {
    
    var units: String!
    
    //Puts all locations into one list, with start location at index 0
    func buildFullList(start: Location, initialList: [Location]) -> [Location] {
        var fullList = [Location]()
        fullList.append(start)
        for var i = 0; i < initialList.count; i++ {
            fullList.append(initialList[i])
        }
        return fullList
    }
    
    func buildDistanceMatrix(locationList: [Location]) -> [[Double]] {
        
        var distanceMatrix = [[Double]]()
        //var timeMatrix = [[Int]]()
        
        var fullList = locationList
        var parser = URLParser()
        
        var tempDistanceArray = [Double]()
        //var tempTimeArray = [Int]()
        //println("FULLLIST COUNT: \(fullList.count)")
        
        for column in 0...fullList.count - 1 {
            
            tempDistanceArray = []
            var start = fullList[column].placeID
            
            for row in 0...fullList.count - 1 {
                
                var end = fullList[row].placeID
                parser.createURL(start, end: end)
                //println("NEW: \(parser.urlRequest)")
                tempDistanceArray.append(parser.getDistance())
                //println(parser.getDistance())
                
                //tempTimeArray.append(parser.getTime())
            }
            distanceMatrix.append(tempDistanceArray)
            //timeMatrix.append(tempTimeArray)
        }
        units = parser.distanceUnits
        return distanceMatrix
    }
    
    func printMatrix(matrix: [[Double]]) {
        for var i = 0; i < matrix.count; i++ {
            println("Value: ")
            for var j = 0; j < matrix[0].count; j++ {
                print("\(matrix[i][j]) ")
            }
        }
    }
    
    //MARK: Algorithm
    func algo(start: Location, initialList: [Location]) -> ([Location], Double) {
        var locationList = buildFullList(start, initialList: initialList)
        var distanceMatrix = buildDistanceMatrix(locationList)
        
        //printMatrix(distanceMatrix)
        
        var totalDistance: Double = 0
        
        var count = 0
        var index = 0
        var finalOrder = [Int]()
        
        while count < distanceMatrix.count {
            var minimum: Double = 10000
            var nextIndex = index
            for var i = 0; i < distanceMatrix[0].count; i++ {
                if index != i {
                    if !contains(finalOrder, i) {
                        if minimum > distanceMatrix[index][i] {
                            minimum = distanceMatrix[index][i]
                            nextIndex = i
                        }
                    }
                }
            }
            totalDistance += minimum
            finalOrder.append(index)
            index = nextIndex
            count++
        }
        
        totalDistance += distanceMatrix[index][0]
        finalOrder.append(0)
        var fullList = [Location]()
        
        for var j = 0; j < finalOrder.count; j++ {
            fullList.append(locationList[finalOrder[j]])
        }
        
        //return totalDistance
        return (fullList, totalDistance)
    }
    
    func getDistanceUnits() -> String{
        if let unit = units {
            return unit
        }
        return " "
    }
}