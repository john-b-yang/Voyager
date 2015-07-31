//
//  NewPathTableViewController.swift
//  Voyager
//
//  Created by John Yang on 7/9/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit
import GoogleMaps
import CoreLocation

class NewPathViewController: UIViewController {

    //To use for autocomplete query and look up place id
    var placesClient: GMSPlacesClient?
    
    var data: [GMSAutocompletePrediction]?
    let locationManager = CLLocationManager()
    var userLocation: CLLocationCoordinate2D?
    
    //Used to store all autocomplete values. Helps in retrieval of GMSPlace objects - location
    var locationDictionary = [String : GMSAutocompletePrediction]()
    //Used to store all autocomplete values. Helps in retrieval of GMSPlace objects - start
    var startDictionary = [String : GMSAutocompletePrediction]()
    
    //Final List of User Locations
    var locationList: [GMSPlace] = []
    //Final User inputted path name
    var pathName: String!
    //Final User Start Location
    var startLocation: GMSPlace!
    
    //Displayed list of final user locations. Not important, just aesthetics
    var destinationList = [String]()

    @IBOutlet weak var destinationEntry: AutoCompleteTextField!
    @IBOutlet weak var startPointEntry: AutoCompleteTextField!
    @IBOutlet weak var pathNameEntry: UITextField!
    @IBOutlet weak var destinationTableView: UITableView!
    
    let textFieldColorUI = UIColor(red: 154/225, green: 20/225, blue: 138/225, alpha: 1.0)
    let textFieldColor = (UIColor(red: 154/225, green: 20/225, blue: 138/225, alpha: 1.0)).CGColor
    let cellBorderWidth: CGFloat = 0.5
    
    let filter = GMSAutocompleteFilter()
    var bounds: GMSCoordinateBounds!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbarHidden = true
        
        placesClient = GMSPlacesClient()
        
        pathNameEntry.layer.borderColor = StyleConstants.defaultBlueColor?.CGColor
        pathNameEntry.layer.borderWidth = cellBorderWidth
        
        initializeAutocomplete(startPointEntry)
        startPointEntry.addTarget(self, action: "startFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        initializeAutocomplete(destinationEntry)
        destinationEntry.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        
        self.locationManager.delegate = self
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        checkExternalTaps()
        handleInput()
        handleStartInput()

        destinationTableView.dataSource = self
        self.destinationTableView.reloadData()
    }
    
    private func initializeAutocomplete(entry: AutoCompleteTextField) {
        entry.layer.borderColor = StyleConstants.defaultBlueColor?.CGColor
        entry.layer.borderWidth = cellBorderWidth
        entry.autoCompleteStrings = []
        entry.maximumAutoCompleteCount = 10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
}

extension NewPathViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.destinationList.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.destinationTableView.dequeueReusableCellWithIdentifier("DestinationEntry", forIndexPath: indexPath) as! NewDestinationTableViewCell
        
        let destination = self.destinationList[indexPath.row]
        
        cell.destinationLabel?.text = destination
        cell.destinationLabel?.textColor = textFieldColorUI
        
        return cell
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            let key = destinationList.removeAtIndex(indexPath.row)
            destinationTableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            let removed = locationList.removeAtIndex(indexPath.row)
            //Test
            /*println(key)
            println("Removed: \(removed.name)")*/
        }
    }
}

//MARK: Keyboard Settings + Listeners
extension NewPathViewController {
    func checkExternalTaps() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func removeGestureRecognizers() {
        if let recognizers = self.view.gestureRecognizers {
            for recognizer in recognizers {
                self.view.removeGestureRecognizer((recognizer as? UIGestureRecognizer)!)
            }
        }
    }
    
    func didTapView() {
        self.view.endEditing(true)
    }
    
    @IBAction func enterPathName(sender: AnyObject) {
        pathName = pathNameEntry.text
        self.view.endEditing(true)
    }
    
    @IBAction func enterStartLocation(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func displayAlert(alertTitle: String, alertMessage: String){
        var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
}

//MARK: Google Maps Autocomplete
/*
How it works:
1. First, the textFieldDidChange identifies that there's something going on
2. The search function inputs the text and dynamically adjusts the autocomplete list
to display suggestions for the current string.
3. Handle input performs reading in the data
*/
extension NewPathViewController {
    func textFieldDidChange(textField: UITextField){
        if let strings = self.destinationEntry?.autoCompleteStrings {
            println("Auto Complete String is not nil")
        } else {
            self.destinationEntry.autoCompleteStrings? = []
        }
        search(textField.text)
    }
    
    func startFieldDidChange(textField: UITextField){
        if let strings = self.startPointEntry?.autoCompleteStrings {
            println("Auto Complete String is not nil - start")
        } else {
            self.startPointEntry.autoCompleteStrings? = ["Current Location"]
        }
        self.startPointEntry!.textColor = UIColor.blackColor()
        searchStart(textField.text)
    }
    
    func setUserBounds() {
        removeGestureRecognizers()
        //Checking if there is a registered user location
        if let coord = self.userLocation {
            bounds = GMSCoordinateBounds(coordinate: coord, coordinate: coord)
        } else {
            bounds = GMSCoordinateBounds()
            println("No User Location")
        }
    }
    
    func searchStart(query: String) {
        setUserBounds()
        self.startPointEntry!.autoCompleteStrings?.removeAll(keepCapacity: false)
        self.data?.removeAll(keepCapacity: false)
        if count(query) > 0 {
            placesClient?.autocompleteQuery(query, bounds: bounds, filter: filter, callback: { (results, error) -> Void in
                if error != nil {
                    //println("Autocomplete error \(error) for query '\(query)'")
                    return
                }
                
                //println("Populating results for query '\(query)'")
                self.data = [GMSAutocompletePrediction]()
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        self.data!.append(result)
                        self.startPointEntry!.autoCompleteStrings?.append(result.attributedFullText.string)
                        self.startDictionary[result.attributedFullText.string] = result
                        //println(self.startPointEntry!.autoCompleteStrings?.count)
                    }
                }
            })
        } else {
            self.data = [GMSAutocompletePrediction]()
            self.startPointEntry.autoCompleteStrings = []
        }
    }
    
    func search(query: String) {
        setUserBounds()
        self.destinationEntry!.autoCompleteStrings?.removeAll(keepCapacity: false)
        self.data?.removeAll(keepCapacity: false)
        if count(query) > 0 {
            //println("Searching for '\(query)'")
            placesClient?.autocompleteQuery(query, bounds: bounds, filter: filter, callback: { (results, error) -> Void in
                if error != nil {
                    println("Autocomplete error \(error) for query '\(query)'")
                    return
                }
                
                //println("Populating results for query '\(query)'")
                self.data = [GMSAutocompletePrediction]()
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        self.data!.append(result)
                        self.destinationEntry!.autoCompleteStrings?.append(result.attributedFullText.string)
                        self.locationDictionary[result.attributedFullText.string] = result
                        //println(self.destinationEntry!.autoCompleteStrings?.count)
                    }
                }
            })
        } else {
            self.data = [GMSAutocompletePrediction]()
            self.destinationEntry!.autoCompleteStrings = []
        }
    }
    
    func handleInput() {
        destinationEntry.onSelect = {[weak self] text, indexpath in
            //Clearing out the text box
            self!.destinationEntry!.text.removeAll(keepCapacity: false)
            
            //Adding the destination text to display list
            self?.destinationList.append(text)
            
            /*
              Retrieving PlaceID string necessary to access GMSPlace
              1. self?.locationDictionary[text] grabs the GMSAutocomplete
              2. .placeID grabs the string value placeID
            */
            var placeid = self?.locationDictionary[text]?.placeID
            
            //Note: Point where you use placeID string to grab GMSPlace
            self!.placesClient?.lookUpPlaceID(placeid!, callback: {(place, error) -> Void in
                if error != nil {
                    println("lookup place id query error: \(error!.localizedDescription)")
                    return
                }
                
                if let p = place {
                    //Adding GMSPlace (User Destination) to list
                    self?.locationList.append(p)
                    //println("LocationList: \(self?.locationList)") //Displays All Items in List
                } else {
                    println("No place details for \(placeid)")
                }
            })
            self!.checkExternalTaps()
            self!.destinationTableView.reloadData()
        }
    }
    
    func handleStartInput() {
        startPointEntry.onSelect = {[weak self] text, indexpath in
            self!.startPointEntry!.text = text
            self!.startPointEntry!.textColor = self!.textFieldColorUI
            
            var placeid = self?.startDictionary[text]?.placeID
            
            self!.placesClient?.lookUpPlaceID(placeid!, callback: {(place, error) -> Void in
                if error != nil {
                    println("lookup place id query error: \(error!.localizedDescription)")
                    return
                }
                
                if let p = place {
                    //Registering User Start Position
                    self!.startLocation = p
                } else {
                    println("No place details for \(placeid)")
                }
            })
        }
        self.checkExternalTaps()
    }
}

//MARK: User Location
extension NewPathViewController : CLLocationManagerDelegate {
    func locationManager(manager: CLLocationManager!, didUpdateLocations locations: [AnyObject]!) {
        self.userLocation = manager.location.coordinate
        
        CLGeocoder().reverseGeocodeLocation(manager.location, completionHandler: { (placemarks, error) -> Void in
            if error != nil {
                println("Error: " + error.localizedDescription)
                return
            }
            if placemarks.count > 0 {
                let pm = placemarks[0] as! CLPlacemark
                //self.displayLocationInfo(pm)
            }
        })
    }
    
    func displayLocationInfo(placemark: CLPlacemark) {
        self.locationManager.stopUpdatingLocation()
        println("Locality: \(placemark.locality)")
        println(placemark.postalCode)
        println("Administrative Area: \(placemark.administrativeArea)")
        println("Country: \(placemark.country)")
    }
    
    func locationManager(manager: CLLocationManager!, didFailWithError error: NSError!) {
        println("Error: " + error.localizedDescription)
    }
}
