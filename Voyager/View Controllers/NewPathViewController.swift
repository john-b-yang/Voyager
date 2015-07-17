//
//  NewPathTableViewController.swift
//  Voyager
//
//  Created by John Yang on 7/9/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit
import GoogleMaps

class NewPathViewController: UIViewController {

    var placesClient: GMSPlacesClient?
    var data: [GMSAutocompletePrediction]?
    
    @IBOutlet weak var destinationEntry: AutoCompleteTextField!
    @IBOutlet weak var startPointEntry: UITextField!
    @IBOutlet weak var pathNameEntry: UITextField!
    @IBOutlet weak var destinationTableView: UITableView!
    
    let textFieldColor = (UIColor(red: 154/225, green: 20/225, blue: 138/225, alpha: 1.0)).CGColor
    let cellBorderWidth: CGFloat = 0.5
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.toolbarHidden = false
        
        placesClient = GMSPlacesClient()
        
        startPointEntry.layer.borderColor = textFieldColor
        startPointEntry.layer.borderWidth = cellBorderWidth
        
        pathNameEntry.layer.borderColor = textFieldColor
        pathNameEntry.layer.borderWidth = cellBorderWidth
        
        destinationEntry.layer.borderColor = textFieldColor
        destinationEntry.layer.borderWidth = cellBorderWidth
        destinationEntry.autoCompleteStrings = []
        destinationEntry.addTarget(self, action: "textFieldDidChange:", forControlEvents: UIControlEvents.EditingChanged)
        destinationEntry.maximumAutoCompleteCount = 5
        
        checkExternalTaps()
        handleInput()
        
        destinationTableView.dataSource = self
        self.destinationTableView.reloadData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
    
    // Configure the cell...
    
    return cell
    }
    */
    
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

extension NewPathViewController: UITableViewDataSource {
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.destinationTableView.dequeueReusableCellWithIdentifier("DestinationEntry", forIndexPath: indexPath) as! NewDestinationTableViewCell
        
        cell.destinationLabel?.text = "Destination"
        
        return cell
    }
}

//MARK: Keyboard Settings
extension NewPathViewController {
    func checkExternalTaps() {
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
    }
    
    func didTapView() {
        self.view.endEditing(true)
    }
}

//MARK: Google Maps Autocomplete
extension NewPathViewController {
    func textFieldDidChange(textField: UITextField){
        if let strings = self.destinationEntry?.autoCompleteStrings {
            println("Auto Complete String is not nil")
        } else {
            self.destinationEntry.autoCompleteStrings? = []
        }
        search(textField.text)
    }
    
    func search(query: String) {
        let filter = GMSAutocompleteFilter()
        let bounds = GMSCoordinateBounds()
        self.destinationEntry!.autoCompleteStrings?.removeAll(keepCapacity: false)
        self.data?.removeAll(keepCapacity: false)
        if count(query) > 0 {
            println("Searching for '\(query)'")
            placesClient?.autocompleteQuery(query, bounds: bounds, filter: filter, callback: { (results, error) -> Void in
                if error != nil {
                    println("Autocomplete error \(error) for query '\(query)'")
                    return
                }
                
                println("Populating results for query '\(query)'")
                self.data = [GMSAutocompletePrediction]()
                for result in results! {
                    if let result = result as? GMSAutocompletePrediction {
                        self.data!.append(result)
                        self.destinationEntry!.autoCompleteStrings?.append(result.attributedFullText.string)
                        println(self.destinationEntry!.autoCompleteStrings?.count)
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
            self!.destinationEntry!.text = text
            println("You got it")
        }
    }
}
