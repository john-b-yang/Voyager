//
//  NavigationTableViewCell.swift
//  Voyager
//
//  Created by John Yang on 7/29/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit

class NavigationTableViewCell: UITableViewCell {

    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
