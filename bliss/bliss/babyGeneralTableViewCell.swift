//
//  babyGeneralTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 15/12/22.
//  Copyright © 2015年 G52GRP-peter. All rights reserved.
//

import UIKit

class babyGeneralTableViewCell: UITableViewCell {

    
    @IBOutlet var category: UILabel!
    
    @IBOutlet var information: UILabel!
    
    @IBOutlet var categoryIcon: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
//        information.textColor = UIColor(red: 0, green: 0.4176, blue: 0.4608, alpha: 1)
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
