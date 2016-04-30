//
//  addChartDataViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/16.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class addChartDataViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    @IBOutlet var babyWeightTF: UITextField!
    @IBOutlet var pickerView: UIPickerView!
    @IBOutlet var scrollView: UIScrollView!
    let selects:[String] = ["6 month", "7 month", "8 month", "9 month", "10 month", "11 month", "12 month", "13 month", "14 month", "15 month", "16 month", "17 month", "18 month", "19 month", "20 month", "21 month", "22 month", "23 month", "24 month"]
    let selectedId:[Int] = [6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24]
    var pickerViewSelect:Int! = 6
    var alertMsg:UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        pickerView.delegate = self
        pickerView.dataSource = self
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneTapped")
        self.navigationItem.rightBarButtonItem = done
        let status = Reach().connectionStatus()
        
        switch status {
        case .Unknown, .Offline:
            let networkError = UIAlertController(title: "Error", message: "You have not connected to the internet, so the data you input will not be stored online.:-(", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            networkError.addAction(cancel)
            networkError.addAction(ok)
            self.presentViewController(networkError, animated: true, completion: nil)
        case .Online(.WWAN):
            print("Connected via WWAN")
        case .Online(.WiFi):
            print("Connected via WiFi")
        }

//        print("This is the log user Email: ", userEmail)
        
    }

    func doneTapped(){
        self.saveContext()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
    
//    When the user edit the textField we need to stopped scroll the scrollView up in order to avoid cover the userful information
    func textFieldDidBeginEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 50), animated: true)
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        scrollView.setContentOffset(CGPointMake(0, 0), animated: true)
    }
    
    func sendTheDataToServer(){
//        print("This is the log user Email: ", userEmail)
        let email:String = userEmail
        let month:String = String(self.selectedId[self.pickerViewSelect])
        let weight:String = self.babyWeightTF.text!
        let URL:NSURL = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/updateBabyData.php")!
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(email)&month=\(month)&weight=\(weight)"
        
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
                    if(resultValue == "Pass"){
                        isUserRegistered = true
                    }
                    
                    let messageToDisplay:String = parseJSON["message"] as! String!
                    print("message to display",messageToDisplay)
                    
//                    dispatch_async(dispatch_get_main_queue(), {
//                        if(isUserRegistered){
//                            self.createAlertMsg("Success", Message: messageToDisplay)
//                        }else{
//                            self.createAlertMsg("Error", Message: messageToDisplay)
//                        }
//                    })
                }
                
            }catch
            {
                print(error)
            }
        }
        task.resume()
    }
    
//    Store the chart data into the core Data
    func saveContext(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let chartdata = NSEntityDescription.insertNewObjectForEntityForName("BabyChart", inManagedObjectContext: context) as! BabyChart
        chartdata.month = self.selectedId[self.pickerViewSelect]
        if let _ = self.babyWeightTF.text!.doubleValue{
            chartdata.weight = Double(self.babyWeightTF.text!)
            do{
                try context.save()
                print("Insert into coreData")
                sendTheDataToServer()
                self.createAlertMsg("Success", Message: "You have saved the data successfully!")
            }catch _{
            
            }
        }else{
            self.alertMsg = UIAlertController(title: "Error", message: "The weight should be a number!:-(", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            self.alertMsg.addAction(cancel)
            self.alertMsg.addAction(ok)
            self.presentViewController(self.alertMsg, animated: true, completion: nil)
        }
    }
    
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in
            self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("finishAddChartSegue", sender: nil)
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("finishAddChartSegue", sender: nil)
        })
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return selects[row]
    }
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return selects.count
    }
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = selects[row]
        let myTitle = NSAttributedString(string: titleData, attributes: [NSFontAttributeName:UIFont(name: "Gill Sans", size: 20)!,NSForegroundColorAttributeName: UIColor.whiteColor()])
        return myTitle
    }
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.pickerViewSelect = row
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    @IBAction func endBabyWeight(sender: AnyObject) {
        babyWeightTF.resignFirstResponder()
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
