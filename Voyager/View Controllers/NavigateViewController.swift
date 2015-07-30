//
//  NavigateViewController.swift
//  Voyager
//
//  Created by John Yang on 7/29/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit

class NavigateViewController: UIViewController {

    var location1: Location!
    var location2: Location!
    var shouldUseGoogleMaps: Bool!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shouldUseGoogleMaps = (UIApplication.sharedApplication().canOpenURL(NSURL(string: "comgooglemaps://")!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func navigateButtonClicked(sender: AnyObject) {
        if shouldUseGoogleMaps == true {
            let url = NSURL(string: "comgooglemaps://?saddr=&daddr=\(location1!.latitude),\(location1!.longitude)")
            UIApplication.sharedApplication().openURL(url!)
        } else {
            let url = NSURL(string: "http://maps.apple.com/maps?saddr=Current%20Location&daddr=\(location1!.latitude),\(location1!.longitude)")
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
