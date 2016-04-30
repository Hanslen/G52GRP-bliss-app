//
//  signUpViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/23.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
//import Parse
import CoreData
import FBSDKCoreKit
import FBSDKLoginKit
var faceBookR:Bool = false


class signUpViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var passwordAgainTF: UITextField!
    @IBOutlet var signUpLabel: UILabel!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var registerButton: UIButton!
    @IBOutlet var haveAnAccount: UIButton!
    
    var alertMsg:UIAlertController!
    var success = 0
    var email:String! = ""
    var password:String! = ""
    var username:String! = "Pleas set your username"
    var faceBookId:String! = "0"
    var userImage:String! = ""
    var titleForNav:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.signUpLabel.font =  UIFont(name: "Gill Sans", size: signUpLabel.font.pointSize)
        self.orLabel.font =  UIFont(name: "Gill Sans", size: signUpLabel.font.pointSize)
        self.registerButton.titleLabel?.font = UIFont(name: "Gill Sans", size: (registerButton.titleLabel?.font?.pointSize)!)
        self.haveAnAccount.titleLabel?.font = UIFont(name: "Gill Sans", size: (haveAnAccount.titleLabel?.font?.pointSize)!)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.title = self.titleForNav
        if(FBSDKAccessToken.currentAccessToken() == nil){
            print("Facebook user is not logged in")
        }else{
            print("Facebook user is logged in")
        }
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
    }
    
    //    This function is for go back to the main page
    func back(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        checkHasLoged()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Check has the user login or not
    func checkHasLoged(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        var results: [AnyObject]?
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        if(results?.count != 0){
            print("You have logged")
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("myAccountLogIn")
            self.presentViewController(MainVC, animated: true, completion: nil)
        }
    }
    @IBAction func endEmail(sender: UITextField) {
        emailTF.resignFirstResponder()
    }
    
    @IBAction func endPassword(sender: AnyObject) {
        passwordTF.resignFirstResponder()
    }

    @IBAction func endPasswordAgain(sender: UITextField) {
        passwordAgainTF.resignFirstResponder()
    }
    
    @IBAction func typeRegister(sender: AnyObject) {
        if(emailTF.text == "" || passwordTF.text == "" || passwordAgainTF.text == ""){
            self.createAlertMsg("Error",Message: "You must fill all the blancket. :-(")
        }
        else{
            if(passwordTF.text == passwordAgainTF.text){
                self.email = emailTF.text!
                self.password = passwordTF.text!
                sendRequest()
            }
            else{
                self.createAlertMsg("Error",Message: "The password you type did not match. :-(")
            }
        }
    }
    
    //Send User data to server side
    func sendRequest(){
        let URL:NSURL = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/userRegister.php")!
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(email)&password=\(password)&faceBookId=\(faceBookId)&username=\(username)&userImage=\(userImage)"
        
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if(error != nil){
                print("error = \(error)")
                return
            }

            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as? String
                    print("results: \(resultValue)")
                    
                    var isUserRegistered:Bool = false
                    if(resultValue == "Success"){
                        isUserRegistered = true
                        self.success = 1
                    }
                    
                    let messageToDisplay:String = parseJSON["message"] as! String!
                    print("message to display",messageToDisplay)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if(isUserRegistered){
                            self.saveContext()
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
    
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction!) -> Void in
            if(self.success == 1){
                self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let MainVC:UIViewController!
                    if(self.titleForNav == "My Account"){
                        MainVC = storyBoard.instantiateViewControllerWithIdentifier("myAccountLogIn")
                    }else{
                        MainVC = storyBoard.instantiateViewControllerWithIdentifier("signInToBaby")
                    }
                    self.navigationController!.pushViewController(MainVC, animated: true)
            }else{
            }
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            if(self.success == 1){
                self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let MainVC:UIViewController!
                    if(self.titleForNav == "My Account"){
                        MainVC = storyBoard.instantiateViewControllerWithIdentifier("myAccountLogIn")
                    }else{
                        MainVC = storyBoard.instantiateViewControllerWithIdentifier("signInToBaby")
                    }
                    self.navigationController!.pushViewController(MainVC, animated: true)
            }else{
            }
        })
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 200), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
//    Go to sign In page
    @IBAction func changeToSignIn(sender: UIButton) {
        performSegueWithIdentifier("signUpToSignInSegue", sender: titleForNav)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "signUpToSignInSegue"){
            let signInVC = segue.destinationViewController as! signInViewController
            signInVC.titleForNav = sender as! String
        }
    }
    
//    Connect to the facebook and register the user
    @IBAction func faceBookRegister(sender: UIButton) {
        let fbLoginManager : FBSDKLoginManager = FBSDKLoginManager()
        fbLoginManager .logInWithReadPermissions(["email"], handler: { (result, error) -> Void in
            if (error == nil){
                let fbloginresult : FBSDKLoginManagerLoginResult = result
                
                if(fbloginresult.grantedPermissions.contains("email"))
                {
                    self.getFBUserData()
                    fbLoginManager.logOut()
                }
            }
        })
    }
    
//    Get facebook signup user information
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.email = result["email"] as! String
                    self.username = (result["last_name"] as! String) + " "+(result["first_name"] as! String)
                    self.userImage = result["picture"]!!["data"]!!["url"] as! String
                    self.faceBookId = result["id"] as! String
                    self.password = "facebook"
                    
                    self.sendRequest()
                }
            })
        }
    }
    
//    Save the user information to the core Data
    func saveContext(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let logUser = NSEntityDescription.insertNewObjectForEntityForName("LogUser", inManagedObjectContext: context) as! LogUser
        logUser.email = self.email
        logUser.username = self.username
        logUser.faceBookId = self.faceBookId
        do{
            try context.save()
            self.success = 1
            print("Insert into coreData")
        }catch _{
            self.success = 0
        }
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
