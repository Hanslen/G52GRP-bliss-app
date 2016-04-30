//
//  signInViewController.swift
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


class signInViewController: UIViewController {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var signInLabel: UILabel!
    @IBOutlet var orLabel: UILabel!
    @IBOutlet var emailTF: UITextField!
    @IBOutlet var passwordTF: UITextField!
    @IBOutlet var loginButton: UIButton!
//    @IBOutlet var forgetButton: UIButton!
    @IBOutlet var createButton: UIButton!
    
    var alertMsg:UIAlertController!
    var success = 0
    var userEmailSignin:String! = ""
    var userPassword:String! = ""
    var faceBookID:String! = "0"
    var userName:String! = ""
    var userImage:String! = ""
    
    var babyName:String! = ""
    var babyWeight:Double! = 100.0
    var birthday:String! = ""
    var gender:Int! = 100
    var length:Double! = 100.0
    
//    When the user click myAccount and Baby, if he/she has not logged in should show this page, create a variable for the title
    var titleForNav:String! = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        self.signInLabel.font =  UIFont(name: "Gill Sans", size: signInLabel.font.pointSize)
        self.orLabel.font =  UIFont(name: "Gill Sans", size: orLabel.font.pointSize)
        self.loginButton.titleLabel?.font = UIFont(name: "Gill Sans", size: (loginButton.titleLabel?.font?.pointSize)!)
//        self.forgetButton.titleLabel?.font = UIFont(name: "Gill Sans", size: (forgetButton.titleLabel?.font?.pointSize)!)
        self.createButton.titleLabel?.font = UIFont(name: "Gill Sans", size: (createButton.titleLabel?.font?.pointSize)!)
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.title = self.titleForNav
        
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
    
    @IBAction func endEmail(sender: UITextField) {
        emailTF.resignFirstResponder()
    }
    @IBAction func endPassword(sender: UITextField) {
        passwordTF.resignFirstResponder()
    }
    @IBAction func backToSignUp(sender: AnyObject) {
        performSegueWithIdentifier("signInToSignUpSegue", sender: titleForNav)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "signInToSignUpSegue"){
            let signUpVC = segue.destinationViewController as! signUpViewController
            signUpVC.titleForNav = sender as! String
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
        
    }
    
    @IBAction func logInType(sender: UIButton) {
        self.userEmailSignin = emailTF.text!
        self.userPassword = passwordTF.text!
        if(userEmailSignin == "" || userPassword == ""){
            createAlertMsg("Error", Message: "Please fill all the blancket.:-(")
        }
        else{
            self.requestForLoginURL()
        }
    }
    
//    Check the user login information
    func requestForLoginURL(){
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/userLogin.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(userEmailSignin)&password=\(userPassword)"
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
                    let userDetailInfo = parseJSON["userDetailInfo"]!
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        if(resultValue == "Success"){
                            
//                            Store the locally for inserting the data to the Core Data
                            self.userName = userDetailInfo["username"] as! String
                            userEmail = userDetailInfo["email"] as! String
                            self.userEmailSignin = userDetailInfo["email"] as! String
                            self.faceBookID = userDetailInfo["faceBookId"] as! String
                            print("Excuse me:",userDetailInfo["babyname"])
                            if(userDetailInfo["babyname"] is NSNull){
                                
                            }else{
                                self.babyName = userDetailInfo["babyname"] as! String
                                self.babyWeight = Double(userDetailInfo["babyweight"] as! String)
                                self.birthday = userDetailInfo["birthday"] as! String
                                self.gender = Int(userDetailInfo["gender"] as! String)
                                self.length = Double(userDetailInfo["length"] as! String)
                            }
                            if(self.faceBookID == ""){
                                self.faceBookID = "0"
                            }
                            self.saveContext()
                        }
                        else{
                            self.success = 0
                            self.createAlertMsg("Error", Message: "The Email and Password does not match")
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
    
//    Save the user information into the coreData, so next time, when the use the App, she will not need to log in again
    func saveContext(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let logUser = NSEntityDescription.insertNewObjectForEntityForName("LogUser", inManagedObjectContext: context) as! LogUser
        logUser.email = self.userEmailSignin
        logUser.faceBookId = self.faceBookID
        logUser.username = self.userName
        logUser.userImage = UIImageJPEGRepresentation(self.getProfPic("http://bliss.sadiqi.org/api/ios/php/userIcon/"+self.userEmailSignin+".jpg")!, 1)
        
        if(self.babyName != ""){
            logUser.babyname = self.babyName
            logUser.weight = self.babyWeight
        
//            Date format transfer
            let dateFormatter = NSDateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            let date = dateFormatter.dateFromString(self.birthday)
            logUser.birthday = date
        
            logUser.gender = self.gender
            logUser.length = self.length
        }
        
        do{
            try context.save()
            print("Insert into coreData")
            self.success = 1
            self.createAlertMsg("Success", Message: "Log in successfully:-)")
        }catch _{
            
        }
    }
    
//    Convert the URL of the img to a UIImage type
    func getProfPic(imgURLString: String) -> UIImage? {
        let imgURL = NSURL(string: imgURLString)
        let imageData = NSData(contentsOfURL: imgURL!)
        if(imageData != nil){
            let image = UIImage(data: imageData!)
            return image
        }
        return UIImage(named: "parentIcon")
        
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
                
                    self.presentViewController(MainVC, animated: true, completion: nil)
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
                    self.navigationController?.pushViewController(MainVC, animated: true)
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
    
//    This is a facebook login Button
    @IBAction func faceBookSignIn(sender: UIButton) {
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
    
//    Get facebook login user data
    func getFBUserData(){
        if((FBSDKAccessToken.currentAccessToken()) != nil){
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).startWithCompletionHandler({ (connection, result, error) -> Void in
                if (error == nil){
                    self.userEmailSignin = result["email"] as! String
                    print("userEmailSignin: ",self.userEmailSignin)
                    self.userName = (result["last_name"] as! String) + " "+(result["first_name"] as! String)
                    print("userName:", self.userName)
                    self.userImage = result["picture"]!!["data"]!!["url"] as! String
                    print("This should be the url of facebookIcon",self.userImage)
                    self.faceBookID = result["id"] as! String
                    print("FacebookId:", self.faceBookID)
                    self.saveContext()
                }
            })
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
