//
//  contactUsTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/4.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class contactUsTableViewCell: UITableViewCell {

    @IBOutlet var serviceName: UILabel!
    @IBOutlet var serviceNumber: UILabel!
    @IBOutlet var phone: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func phoneTyped(sender: UIButton) {
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
