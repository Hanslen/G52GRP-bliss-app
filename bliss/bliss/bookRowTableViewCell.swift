//
//  bookRowTableViewCell.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/31.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class bookRowTableViewCell: UITableViewCell {

    @IBOutlet var bookLeft: UIButton!
    @IBOutlet var bookRight: UIButton!
    @IBOutlet var bookLeftLabel: UILabel!
    @IBOutlet var bookRightLabel: UILabel!
    var row:Int! = 0
    var bookURLLeft:[NSURL]! = [NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=7366b6ce-cbbe-420c-bad2-77275a7dd193")!,NSURL(string: "")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=3fed7f9b-7fc7-494a-943a-7627681fd384")!,NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=869bbf25-af6c-4a4a-9c00-5dfad7936758")!]
    var bookURLRight:[NSURL]! = [NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=4249368c-02ac-4eae-b3d4-4fdb115a6a66%20")!, NSURL(string: "http://bliss.org.uk/Handlers/Download.ashx?IDMF=73dc0750-0ddf-4752-bcdd-a74ac3f86595")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=bbe903a7-4efb-4f7a-950a-cfa2ef594367")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=d4936722-0fe8-44f3-94fb-df4044df2b62")!]
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    @IBAction func leftBook(sender: UIButton) {
        
    }
    @IBAction func rightBook(sender: UIButton) {
    }
    

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
