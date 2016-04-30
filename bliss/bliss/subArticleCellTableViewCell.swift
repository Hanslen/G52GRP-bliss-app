//
//  subArticleCellTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/20.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class subArticleCellTableViewCell: UITableViewCell {

    @IBOutlet var cellTitle: UILabel!
    @IBOutlet var leftView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
