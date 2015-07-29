//
//  PathDescriptionViewController.swift
//  Voyager
//
//  Created by John Yang on 7/9/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit
import GoogleMaps
import RealmSwift

class PathDescriptionViewController: UIViewController {
    
    @IBOutlet weak var dashboardTitle: UINavigationItem!

    @IBOutlet weak var deleteButton: UIBarButtonItem!
    
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    //Description View Labels:
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var navigationText: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    @IBOutlet weak var navigationTableView: UITableView!
    
    var shouldUseGoogleMaps: Bool!
    
    var path: Path? {
        didSet {
            displayPath(path)
            dashboardTitle.title = path?.pathName
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.toolbarHidden = true
    }
    
    override func viewDidLoad() {
        self.navigationController?.toolbarHidden = true
        segmentedControl.setTitle("Map View", forSegmentAtIndex: 1)
        segmentedControl.setTitle("Description", forSegmentAtIndex: 0)
        segmentedControl.tintColor = UIColor.purpleColor()
        
        distanceLabel.text = "Total Distance: \(path!.totalDistance)"
        timeLabel.text = "Total Time: \(path!.totalTime)"
        
        instantiateMap()
        
        self.navigationTableView.reloadData()
        navigationTableView.dataSource = self
        
        shouldUseGoogleMaps = (UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayPath(path: Path?) {
        if let aPath = path {
            println("Clear")
        }
    }
    
    func instantiateMap() {
        mapView.hidden = true
        var latitude = path?.locationList[0].latitude
        var longitude = path?.locationList[0].longitude
        
        var latitudeDegrees: CLLocationDegrees = latitude!
        var longitudeDegrees: CLLocationDegrees = longitude!
        
        var camera = GMSCameraPosition.cameraWithLatitude(latitudeDegrees, longitude: longitudeDegrees, zoom: 8)
        self.mapView.animateToCameraPosition(camera)
        
        for var i = 0; i < path?.locationList.count; i++ {
            latitude = path?.locationList[i].latitude
            longitude = path?.locationList[i].longitude
            var marker = GMSMarker()
            marker.position = CLLocationCoordinate2DMake(latitude!, longitude!)
            marker.appearAnimation = kGMSMarkerAnimationPop
            marker.icon = UIImage(named: "flag_icon")
            marker.title = "\(i + 1): \(path!.locationList[i].name)"
            marker.map = self.mapView
        }
        
        // Available map types: kGMSTypeNormal, kGMSTypeSatellite, kGMSTypeHybrid,
        // kGMSTypeTerrain, kGMSTypeNone
        mapView.mapType = kGMSTypeNormal
        mapView.animateToCameraPosition(camera)
    }
    
    func displayMap(isMapView: Bool) {
        mapView.hidden = !isMapView
    }
}

//Segmented Control Portion
extension PathDescriptionViewController {
    @IBAction func segmentedControlClicked(sender: AnyObject) {
        //Description
        if segmentedControl.selectedSegmentIndex == 0 {
            distanceLabel.hidden = false
            timeLabel.hidden = false
            navigationText.hidden = false
            navigationTableView.hidden = false
            displayMap(false)
        }
        //Map View
        if segmentedControl.selectedSegmentIndex == 1 {
            distanceLabel.hidden = true
            timeLabel.hidden = true
            navigationText.hidden = true
            navigationTableView.hidden = true
            displayMap(true)
        }
    }
}

//Navigation Table View
extension PathDescriptionViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var num = path?.locationList.count
        return Int(num! - 1 ?? 0)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.navigationTableView.dequeueReusableCellWithIdentifier("NavigationEntry", forIndexPath: indexPath) as! NavigationTableViewCell
        
        let part1 = self.path?.locationList[indexPath.row]
        let part2 = self.path?.locationList[indexPath.row + 1]
        
        cell.startLabel.text = "From: \(part1!.name)"
        cell.endLabel.text = "To: \(part2!.name)"
        
        return cell
    }
}

//Open Google Maps + NAVIGATION
extension PathDescriptionViewController {
    
}
