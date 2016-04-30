//
//  addTopicViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/13.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class addTopicViewController: UIViewController {

    @IBOutlet var topicTitle: UITextField!
    @IBOutlet var topicIntro: UITextView!
    var userEmail:String! = ""
    
    var alertMsg:UIAlertController!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "sendRequest")
        self.navigationItem.rightBarButtonItem = done
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func endTitle(sender: UITextField) {
        topicIntro.resignFirstResponder()
    }
    
//    Get User information from the coreData for inserting to the mysql server
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
        let URL:NSURL = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/postTopic.php")!
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        checkHasLoged()
        let email:String! = self.userEmail
        let topicTitleText:String! = topicTitle.text as String!
        let topicIntroText:String! = topicIntro.text as String!
        if(topicTitleText == "" || topicIntroText == ""){
            self.createAlertMsg("Error", Message: "Please fill all the blanket!:-(")
        }
        else{
        let postString = "title=\(topicTitleText)&topicIntro=\(topicIntroText)&email=\(email)"
        print(postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if(error != nil){
                NSOperationQueue.mainQueue().addOperationWithBlock{
                    self.createAlertMsg("Error", Message: "Please check your network!:-(")
                }

                print("error = \(error)")
                return
            }
            do {
                
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as? String
                    
                    var postSuccess:Bool = false
                    if(resultValue == "Success"){
                        postSuccess = true
                    }else{
                        postSuccess = false
                    }
                    
                    let messageToDisplay:String = parseJSON["message"] as! String!
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if(postSuccess == true){
                            self.createAlertMsg("Success", Message: messageToDisplay)
                        }else{
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
    
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {
            (action:UIAlertAction!) -> Void in
            self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("finishAddTopicSegue", sender: nil)
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("finishAddTopicSegue", sender: nil)
        })
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
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
