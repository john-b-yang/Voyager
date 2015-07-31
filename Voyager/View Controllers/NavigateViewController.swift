//
//  NavigateViewController.swift
//  Voyager
//
//  Created by John Yang on 7/29/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit

class NavigateViewController: UIViewController {

    var location1: Location? {
        didSet {
            println("1 Clear")
            println(location1?.name)
        }
    }
    
    var location2: Location? {
        didSet {
            println("2 Clear")
            println(location2?.name)
        }
    }
    
    var shouldUseGoogleMaps: Bool!
    
    @IBOutlet weak var location1Label: UILabel!
    @IBOutlet weak var location2Label: UILabel!
    @IBOutlet weak var legNumber: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldUseGoogleMaps = (UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!))
        
        location1Label.text = location1?.name
        location2Label.text = location2?.name
        legNumber.hidden = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func navigateButtonClicked(sender: AnyObject) {
        if shouldUseGoogleMaps == true {
            let url = NSURL(string: "comgooglemaps://?saddr=\(location1!.latitude),\(location1!.longitude)&daddr=\(location2!.latitude),\(location2!.longitude)")
            UIApplication.sharedApplication().openURL(url!)
        } else {
            let url = NSURL(string: "http://maps.apple.com/maps?saddr=\(location1!.latitude),\(location1!.longitude)&daddr=\(location2!.latitude),\(location2!.longitude)")
            UIApplication.sharedApplication().openURL(url!)
        }
//        } else {
//            if shouldUseGoogleMaps == true {
//                let url = NSURL(string: "comgooglemaps://")
//                UIApplication.sharedApplication().openURL(url!)
//
//            } else {
//                let url = NSURL(string: "http://maps.apple.com/?q=")
//                UIApplication.sharedApplication().openURL(url!)
//            }
//        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

    
}
