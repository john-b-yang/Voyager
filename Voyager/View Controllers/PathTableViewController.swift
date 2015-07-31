//
//  PathTableViewController.swift
//  Dijsktra
//
//  Created by John Yang on 7/7/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit
import RealmSwift
import GoogleMaps

class PathTableViewController: UITableViewController {
    
    var selectedPath: Path?
    
    @IBOutlet var tableViewObj: UITableView!
    @IBOutlet weak var defaultLabel: UILabel!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    var paths: Results<Path>! {
        didSet {
            tableViewObj?.reloadData()
            defaultLabel.hidden = false
            if let test = paths {
                if test.count > 0 {
                    defaultLabel.hidden = true
                }

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableViewObj.reloadData()
        tableViewObj.dataSource = self
    }
    
    override func viewWillAppear(animated: Bool) {
        addButton.enabled = true
        
        let realm = Realm()
        paths = realm.objects(Path).sorted("pathName", ascending: true)
        defaultLabel.hidden = false
        if let test = paths {
            if test.count > 0 {
                defaultLabel.hidden = true
            }
        }
        super.viewWillAppear(animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createLocation(gmsplace: GMSPlace) -> Location {
        var location = Location()
        location.name = gmsplace.name
        location.address = gmsplace.formattedAddress
        location.placeID = gmsplace.placeID
        location.latitude = gmsplace.coordinate.latitude
        location.longitude = gmsplace.coordinate.longitude
        return location
    }
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        
        if let identifier = segue.identifier {
            
            let realm = Realm()
            var alert: UIAlertView!
            
            switch identifier {
            case "Save" :
                let source = segue.sourceViewController as! NewPathViewController
                
                if !source.pathNameEntry.text.isEmpty {
                    if let start = source.startLocation {
                        if !source.locationList.isEmpty {
                                
                            let newPath = Path()
                            newPath.pathName = source.pathNameEntry.text
                            
                            for var i = 0; i < source.locationList.count; i++ {
                                var gmsplace = source.locationList[i]
                                newPath.initialList.append(createLocation(gmsplace))
                            }
                            
                            var startGMSPlace = source.startLocation
                            newPath.start = createLocation(startGMSPlace)
                            
                            newPath.createPath()
                            
                            realm.write() {
                                realm.add(newPath)
                            }
                        } else {
                            source.displayAlert("Error", alertMessage: "Please enter at least one destination")
                        }
                    } else {
                        source.displayAlert("Error", alertMessage: "Please enter a start location")
                    }
                } else {
                    source.displayAlert("Error", alertMessage: "Please enter a path name")
                }
            case "Delete":
                realm.write() {
                    realm.delete(self.selectedPath!)
                }
                
                let source = segue.sourceViewController as! PathDescriptionViewController
                source.path = nil
                
            default:
                //Cancel Button
                println("Cancelled")
            }
            
            paths = realm.objects(Path).sorted("pathName", ascending: true)
        }
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showExistingPath") {
            let pathViewController = segue.destinationViewController as! PathDescriptionViewController
            pathViewController.path = selectedPath
        }
        if (segue.identifier == "createNewPath") {
            addButton.enabled = false
        }
    }
    
}

extension PathTableViewController: UITableViewDataSource{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(paths?.count ?? 0)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PathTableViewCell
        
        let row = indexPath.row
        
        let aPath = paths[row] as Path
        cell.titleLabel?.text = aPath.pathName
        cell.titleLabel.textColor = StyleConstants.defaultBlueColor
        cell.distanceLabel.text = "Total Distance: \(aPath.totalDistance) \(aPath.units)"
        cell.startLocationLabel.text = "Start: \(aPath.start.name)"
        cell.timeLabel.hidden = true
        
        cell.modificationDate.text = PathTableViewCell.dateFormatter.stringFromDate(aPath.modificationDate)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
    
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if (editingStyle == UITableViewCellEditingStyle.Delete) {
            
            var alertTitle = "Warning"
            var alertMessage = "Are you sure you want to delete the path?"
            
            var alert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default) { (action) in
                let path = self.paths[indexPath.row] as Object
                let realm = Realm()
                realm.write() {
                    realm.delete(path)
                }
                self.paths = realm.objects(Path).sorted("pathName", ascending: true)
            })
            alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
}

extension PathTableViewController : UITableViewDelegate {
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedPath = paths[indexPath.row]
        self.performSegueWithIdentifier("showExistingPath", sender: self)
    }
}
