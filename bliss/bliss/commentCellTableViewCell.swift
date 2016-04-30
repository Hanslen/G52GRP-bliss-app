//
//  commentCellTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/6.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class commentCellTableViewCell: UITableViewCell {

    @IBOutlet var userName: UILabel!
    @IBOutlet var userComment: UILabel!
    @IBOutlet var userIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
