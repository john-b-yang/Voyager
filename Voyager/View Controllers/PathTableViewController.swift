//
//  PathTableViewController.swift
//  Dijsktra
//
//  Created by John Yang on 7/7/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit
import RealmSwift

class PathTableViewController: UITableViewController {
    
    var selectedPath: Path?
    
    @IBOutlet var tableViewObj: UITableView!
    @IBOutlet weak var defaultLabel: UILabel!
    
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
    
    @IBAction func unwindToSegue(segue: UIStoryboardSegue) {
        let source = segue.sourceViewController as! NewPathViewController
        if let identifier = segue.identifier {
            let realm = Realm()
            var alert: UIAlertView!
            switch identifier {
            case "Save" :
                if let name = source.pathName {
                    if let start = source.startLocation {
                        if !source.locationList.isEmpty {
                            
                            let newPath = Path()
                            newPath.pathName = source.pathName
                            
                            var location = Location()
                            for var i = 0; i < source.locationList.count; i++ {
                                var gmsplace = source.locationList[i]
                                location.name = gmsplace.name
                                location.address = gmsplace.formattedAddress
                                location.placeID = gmsplace.placeID
                                location.latitude = gmsplace.coordinate.latitude
                                location.longitude = gmsplace.coordinate.longitude
                            }
                            newPath.initialList.append(location)
                            
                            var startLocation = Location()
                            var startGMSPlace = source.startLocation
                            startLocation.name = startGMSPlace.name
                            startLocation.address = startGMSPlace.formattedAddress
                            startLocation.placeID = startGMSPlace.placeID
                            startLocation.latitude = startGMSPlace.coordinate.latitude
                            startLocation.longitude = startGMSPlace.coordinate.longitude
                            newPath.start = startLocation
                            
                            //TODO: Append location to list
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
            default:
                //Cancel Button
                println("I see how it is")
            }
            
            paths = realm.objects(Path).sorted("pathName", ascending: true)
        }
    }

    // MARK: - Table view data source
    
    //override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    // #warning Potentially incomplete method implementation.
    // Return the number of sections.
    //return 0
    //}
    
    //override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    // #warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return self.paths.count
    //}
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the specified item to be editable.
    return true
    }
    */
    
    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
    if editingStyle == .Delete {
    // Delete the row from the data source
    tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
    } else if editingStyle == .Insert {
    // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }
    }
    */
    
    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
    
    }
    */
    
    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
    // Return NO if you do not want the item to be re-orderable.
    return true
    }
    */
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "showExistingPath") {
            let pathViewController = segue.destinationViewController as! PathDescriptionViewController
            pathViewController.path = selectedPath
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
        cell.titleLabel.textColor = UIColor(red: 154/225, green: 20/225, blue: 138/225, alpha: 1.0)
        cell.startLocationLabel.text = "Start: \(aPath.start.name)"
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
