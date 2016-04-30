//
//  resetPasswordViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/11.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class resetPasswordViewController: UIViewController {

    @IBOutlet var oldPasswordTF: UITextField!
    @IBOutlet var newPasswordTF: UITextField!
    @IBOutlet var newPasswordAgainTF: UITextField!
    
    var userEmail:String! = ""
    var alertmsg:UIAlertController!
    var success = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

    }
    override func viewDidAppear(animated: Bool) {
        getUserEmail()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func endOldPassword(sender: UITextField) {
        oldPasswordTF.resignFirstResponder()
    }
    @IBAction func endNewpassword(sender: UITextField) {
        newPasswordTF.resignFirstResponder()
    }
    @IBAction func endNewPasswordAgain(sender: UITextField) {
        newPasswordAgainTF.resignFirstResponder()
    }
    
//    Update the user password and send the information to server
    @IBAction func updatePassword(sender: AnyObject) {
        if(newPasswordAgainTF.text != newPasswordTF.text){
            createAlertMsg("Error", Message: "The two new password you type didn't matched")
        }else{
            let userOldPassword:String! = oldPasswordTF.text
            let userNewPassword:String! = newPasswordTF.text
            
            let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/resetPassword.php")
            let request = NSMutableURLRequest(URL: myUrl!)
            request.HTTPMethod = "POST"
            
            let postString = "email=\(userEmail)&oldpassword=\(userOldPassword)&newpassword=\(userNewPassword)"
            request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
            
            let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
                data, response, error in
                if(error != nil){
                    print("error=\(error)")
                    return
                }
                do {
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                    
                    if let parseJSON = json
                    {
                        let resultValue = parseJSON["status"] as? String
                        dispatch_async(dispatch_get_main_queue(), {
                            if(resultValue == "Pass"){
                                self.createAlertMsg("Success", Message: "You have reset the password successfully.:-)")
                                self.success = 1
                            }
                            else{
                                self.createAlertMsg("Error", Message: "You type the wrong old password")
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
    
//    Get userEmail from core Data
    func getUserEmail(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        var results: [AnyObject]?
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        print("Here comes with the results",results)
        if(results?.count != 0){
            var user:[LogUser] = []
            
            user = results! as! [LogUser]
            
            userEmail = user[0].email
            print(userEmail)
        }
        else{
            print("Error: You have not logged")
        }
    }
    
//    Create an alert message
    func createAlertMsg(Type:String, Message:String) -> UIAlertController{
        self.alertmsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction!) -> Void in
            if(self.success == 1){
                self.alertmsg.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: {() -> Void in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("myAccountLogIn")
                    self.presentViewController(MainVC, animated: true, completion: nil)
                })
            }
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if(self.success == 1){
                self.alertmsg.dismissViewControllerAnimated(true, completion: nil)
                self.dismissViewControllerAnimated(true, completion: {() -> Void in
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("myAccountLogIn")
                    self.presentViewController(MainVC, animated: true, completion: nil)
                })
            }
        }
        )
        self.alertmsg.addAction(cancel)
        self.alertmsg.addAction(ok)
        self.presentViewController(self.alertmsg, animated: true, completion: nil)
        
        return self.alertmsg
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
