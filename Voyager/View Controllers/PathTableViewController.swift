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
    
    @IBOutlet var tableViewObj: UITableView!
    
    var paths = [Path]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.paths = [Path()]
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        self.tableViewObj.reloadData()
        tableViewObj.dataSource = self
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
            default:
                //Cancel Button
                println("I see how it is")
            }
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
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    }
    */
    
}

extension PathTableViewController: UITableViewDataSource{
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paths.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! PathTableViewCell
        
        let path = self.paths[indexPath.row]
        
        cell.titleLabel?.text = path.pathName
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        
        return cell
    }
}
