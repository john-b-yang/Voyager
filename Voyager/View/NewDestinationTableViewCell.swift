//
//  NewDestinationTableViewCell.swift
//  Voyager
//
//  Created by John Yang on 7/15/15.
//  Copyright (c) 2015 John Yang. All rights reserved.
//

import UIKit

class NewDestinationTableViewCell: UITableViewCell {

    @IBOutlet weak var destinationLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
