//
//  favouriteTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/9.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class favouriteTableViewCell: UITableViewCell {

    @IBOutlet var picForArticle: UIImageView!
    @IBOutlet var title: UILabel!
    @IBOutlet var intro: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
