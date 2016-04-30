//
//  initialBabyDataViewController.swift If the user has not create a baby profile, show this page
//  bliss
//
//  Created by Hanslen Chen on 16/2/25.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class initialBabyDataViewController: UIViewController,UITextFieldDelegate {

    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var babyName: UITextField!
    @IBOutlet var babyBirthday: UIDatePicker!
    @IBOutlet var babyLength: UITextField!
    @IBOutlet var babyWeight: UITextField!
    @IBOutlet var femaleButton: UIButton!
    @IBOutlet var maleButton: UIButton!
    var alertMsg:UIAlertController! = UIAlertController()
    var gender:Int! = 100
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneTapped")
        self.navigationItem.rightBarButtonItem = done
    }
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }

    func back(sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    
//    Insert the baby data into the mysql
    func sendInitialDataToServer(){
        let gender:Int! = self.gender
        let name:String! = self.babyName.text
        let birthday:NSDate! = self.babyBirthday.date
        let length:String! = self.babyLength.text
        let weight:String! = self.babyWeight.text
        print("UserEmail:",userEmail)
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        let bir:String! = formatter.stringFromDate(birthday)

        
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/initializeBaby.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "email=\(userEmail)&name=\(name)&birthday=\(bir)&length=\(length)&weight=\(weight)&gender=\(gender)"
        print("This is the postString: ", postString)
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if(error != nil){
                print("wowerror=\(error)")
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as? String
                    print("results: \(resultValue)")
                    let resultMessage = parseJSON["message"] as? String
                    print("message: \(resultMessage)")
                    dispatch_async(dispatch_get_main_queue(), {
                        if(resultValue == "Pass"){
                        }
                        else{
                            let error=UIAlertController(title: "Error", message: "Please check your network configuration!:-(", preferredStyle: .Alert)
                            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            error.addAction(cancel)
                            error.addAction(ok)
                            self.presentViewController(error, animated: true, completion: nil)
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
    
    func doneTapped(){
        let name:String! = self.babyName.text
        let birthday:NSDate! = self.babyBirthday.date
        let length:String! = self.babyLength.text
        let weight:String! = self.babyWeight.text
        self.sendInitialDataToServer()
        
//        check Has the select the gender
        if(name != ""){
        if(self.gender != 100){
//        check is length and weight a number or not
        if let _ = length.doubleValue{
//            lenght is a double Value
            if let _ = weight.doubleValue{
                let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
                let request = NSFetchRequest(entityName: "LogUser")
                var loguser:[LogUser]! = []
                var results: [AnyObject]?
                
                do{
                    results = try context.executeFetchRequest(request)
                }catch _{
                    results = nil
                }
                if(results != nil){
                    loguser = results! as? [LogUser]
                }
                let person = loguser![0] as NSManagedObject
                person.setValue(name, forKey: "babyname")
                person.setValue(self.gender, forKey: "gender")
                
                person.setValue(birthday, forKey: "birthday")
                person.setValue(Double(length), forKey: "length")
                person.setValue(Double(weight), forKey: "weight")
                person.setValue(100, forKey: "hasComeToWorld")
                do{
                    try person.managedObjectContext?.save()
                    let success = UIAlertController(title: "Success", message: "Save baby data!:-)", preferredStyle: .Alert)
                    let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in
                        self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
                        
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let MainVC:UIViewController!
                        MainVC = storyBoard.instantiateViewControllerWithIdentifier("signInToBaby")
                        self.navigationController!.pushViewController(MainVC, animated: true)
                    })
                    let ok = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
                        self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
                        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                        let MainVC:UIViewController!
                        MainVC = storyBoard.instantiateViewControllerWithIdentifier("signInToBaby")
                        self.navigationController!.pushViewController(MainVC, animated: true)
                    })
                    success.addAction(cancel)
                    success.addAction(ok)
                    self.presentViewController(success, animated: true, completion: nil)
                }catch _{
                    
                }
            }
            else{
                self.createAlertMsg("Error", Message: "You baby weight should be a number! :-(")
            }
        }
        else{
            self.createAlertMsg("Error", Message: "You baby length should be a number! :-(")
        }
        }
        else{
            self.createAlertMsg("Error", Message: "Please select a gender! :-(")
        }
        }else{
            self.createAlertMsg("Error", Message: "Please enter baby name!:-(")
        }
        
    }
    
//    When a gender has been clicked, border that button
    @IBAction func femaleClick(sender: UIButton) {
        self.gender = 1
        self.femaleButton.setImage(UIImage(named: "female_filled"), forState: .Normal)
        self.maleButton.setImage(UIImage(named: "male"), forState: .Normal)
    }
    
    @IBAction func maleClick(sender: UIButton) {
        self.gender = 0
        self.femaleButton.setImage(UIImage(named: "female"), forState: .Normal)
        self.maleButton.setImage(UIImage(named: "male_filled"), forState: .Normal)
        
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 250), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
    @IBAction func endBabyName(sender: UITextField) {
        self.babyName.resignFirstResponder()
    }
    
    @IBAction func endBabyLength(sender: UITextField) {
        self.babyLength.resignFirstResponder()
    }
    @IBAction func endBabyWeight(sender: UITextField) {
        self.babyWeight.resignFirstResponder()
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


//extend the string class to have doubleValue, floatValue, integerValue this will help to check the type of the user input
extension String {
    var doubleValue: Double? {
        return Double(self)
    }
    var floatValue: Float? {
        return Float(self)
    }
    var integerValue: Int? {
        return Int(self)
    }
}
