//
//  diaryDetailViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/24.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class diaryDetailViewController: UIViewController {

    @IBOutlet var diaryTitle: UILabel!
    @IBOutlet var context: UITextView!
    @IBOutlet var timeForDiary: UILabel!
    
    var diaryT:String!
    var contextT:String!
    var timeT:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.context.textColor = UIColor.whiteColor()
        self.diaryTitle.text = self.diaryT
        self.context.text = self.contextT
        self.timeForDiary.text = self.timeT
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
