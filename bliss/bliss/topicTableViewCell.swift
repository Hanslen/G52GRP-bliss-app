//
//  topicTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/6.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class topicTableViewCell: UITableViewCell {

    @IBOutlet var topicName: UILabel!
    @IBOutlet var underline: UILabel!
    @IBOutlet var userIcon: UIImageView!
    @IBOutlet var reads: UILabel!
    @IBOutlet var introTopic: UILabel!
    @IBOutlet var forwardIcon: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        underline.layer.addTopicLine(UIColor(netHex: 0x358875), thickness: 0.5)
        userIcon.image = UIImage(named: "parentIcon")
        forwardIcon.image = UIImage(named: "forward")
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
extension CALayer {
    
    func addTopicLine(color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        border.frame = CGRectMake(0, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame)-30, thickness)
        border.backgroundColor = color.CGColor;
        self.addSublayer(border)
    }}
