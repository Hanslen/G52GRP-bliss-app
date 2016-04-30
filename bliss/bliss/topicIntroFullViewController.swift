//
//  topicIntroFullViewController.swift This file is for viewing a detailed topic
//  bliss
//
//  Created by Hanslen Chen on 16/2/14.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class topicIntroFullViewController: UIViewController {

    @IBOutlet var context: UITextView!
    
    var topicName:String! = ""
    var topicIntroduction:String! = ""
    var comment:String! = ""
    var topicId:String! = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if(comment == ""){
            context.text = topicIntroduction
        }else{
            context.text = comment
        }
        context.font = UIFont(name: "Gill Sans", size: 17)
        context.textColor = UIColor.whiteColor()
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
