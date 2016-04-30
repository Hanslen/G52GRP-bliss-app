//
//  addCommentForTopicViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/27.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class addCommentForTopicViewController: UIViewController, UITextViewDelegate {

    @IBOutlet var commentTV: UITextView!
    let placeholder = "Please enter your comment"
    var topicName:String!
    var topicId:String!
    var topicIntro:String!
    var alertMsg:UIAlertController!
    var success = 0
    
    var userEmail:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        commentTV.delegate = self
        commentTV.layer.borderWidth = 2
        commentTV.layer.borderColor = UIColor.whiteColor().CGColor
        commentTV.text = self.placeholder
        commentTV.textColor = UIColor(netHex: 0xfffffe)
        commentTV.contentInset = UIEdgeInsetsMake(-65.0, 0, 0, 0)
        let add = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "sendRequest")
        self.navigationItem.rightBarButtonItem = add
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    func textViewDidBeginEditing(textView: UITextView) {
        if(textView.textColor == UIColor(netHex: 0xfffffe)){
            commentTV.text = nil
            commentTV.textColor = UIColor.whiteColor()
        }
    }
    func textViewDidEndEditing(textView: UITextView) {
        if(textView.text.isEmpty){
            commentTV.text = placeholder
            commentTV.textColor = UIColor(netHex: 0xfffffe)
        }
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if(text == "\n"){
            commentTV.resignFirstResponder()
            return false
        }
        return true
    }
    
//    Get the logged in user data
    func checkHasLoged()->[AnyObject]{
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        var results: [AnyObject]?
        var logUser: [LogUser]!
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        if(results != nil){
            logUser = results! as? [LogUser]
            self.userEmail = logUser![0].email
        }
        return results!
    }
    
    //Send User data to server side
    func sendRequest(){
        let URL:NSURL = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/postComment.php")!
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        self.checkHasLoged()
        let email:String! = self.userEmail
        let commentText:String! = commentTV.text as String!
        if(commentText == "" || commentText == "Please enter your comment"){
            self.createAlertMsg("Error", Message: "Please enter your comment! :-(")
        }else{
        let postString = "comment=\(commentText)&owner=\(email)&topicId=\(topicId)"
        print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if(error != nil){
                print("error = \(error)")
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                print("You are posting topic~~~")
                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as? String
                    
                    var postSuccess:Bool = false
                    if(resultValue == "Success"){
                        postSuccess = true
                    }
                    
                    let messageToDisplay:String = parseJSON["message"] as! String!
                    print("Post message(from server)",messageToDisplay)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if(postSuccess == true){
                            self.success = 1
                            self.createAlertMsg("Success", Message: messageToDisplay)
                        }else{
                            self.success = 0
                            self.createAlertMsg("Error", Message: messageToDisplay)
                        }
                        
                    })
                }
                
            }catch
            {
                print(error)
            }
        }
        task.resume()
        }
    }
    
//    Create an alert Message 
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction!) -> Void in
            if(self.success == 1){
                
                self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("afterSubmitComment", sender: nil)
            }
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if(self.success == 1){
                self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("afterSubmitComment", sender: nil)
            }
        })
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "afterSubmitComment"){
            let topicVC = segue.destinationViewController as! detailTopicViewController
            topicVC.topicId = self.topicId
            topicVC.topicIntroduction = self.topicIntro
            topicVC.topicName = self.topicName
        }
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
