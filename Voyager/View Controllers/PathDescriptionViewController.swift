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
    
    var path: Path? {
        didSet {
            displayPath(path)
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        self.navigationController?.toolbarHidden = false
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
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /*override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        var currentPath = Path()
        let pathViewController = segue.destinationViewController as! PathDescriptionViewController
        pathViewController.path = currentPath
    }*/

}
