//
//  babyViewController.swift This page is for the initial page for viewing baby profile
//  bliss
//
//  Created by Hanslen Chen on 15/12/20.
//  Copyright © 2015年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class babyViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate,UINavigationControllerDelegate {

   
    @IBOutlet var babyInfoSelect: UINavigationBar!
    @IBOutlet var generalButton: UIButton!
    @IBOutlet var chartButton: UIButton!
    @IBOutlet var babyIcon: UIImageView!
    @IBOutlet var tableView: UITableView!
    let tapRec = UITapGestureRecognizer()
    var success = 0
    var alertMsg:UIAlertController! = UIAlertController()
    var localChartData:[BabyChart] = []

//    This array is for storing the tableView category
    var babyGeneral = ["Name", "Gender", "Birthday", "Height", "Weight", "Days"]
    
//    This array is for CoreData format, can transfer the information to the current data format
    var cdFormat = ["babyname", "gender", "birthday","length","weight","hasComeToWorld"]
    var babyDataCD:[LogUser] = []
    var babyData:[String]! = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        success = self.pullLocalData()
        if(success == 0){
            print("That is 0")
            performSegueWithIdentifier("initialBabyData", sender: nil)
        }else{
            print("That is 1")
        }
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.separatorColor = UIColor.clearColor()
        tapRec.addTarget(self, action: "changeBabyIcon")
        babyIcon.addGestureRecognizer(tapRec)
        babyIcon.userInteractionEnabled = true;
        
        babyIcon.layer.borderWidth = 1.0
        babyIcon.layer.masksToBounds = false
        babyIcon.layer.borderColor = UIColor.whiteColor().CGColor
        babyIcon.layer.cornerRadius = babyIcon.frame.size.width/2
        babyIcon.clipsToBounds = true

        // Do any additional setup after loading the view.
        
        babyInfoSelect.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        babyInfoSelect.shadowImage = UIImage()
        
        chartButton.backgroundColor = UIColor(netHex: 0x0D616D)
        chartButton.layer.cornerRadius = 5
        chartButton.layer.borderWidth = 3
        chartButton.layer.borderColor = UIColor.whiteColor().CGColor
        generalButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        generalButton.layer.cornerRadius = 5
        
        let nib = UINib(nibName: "babyGeneralCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "cell")
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        self.getOnlineChartData()
        
//        For better user experience the tableView should not be scrolled
        tableView.scrollEnabled = false

    }

//    Change the baby Icon
    func changeBabyIcon(){
        let chooseImgFrom = UIAlertController(title: "Add photo for your diary", message: "", preferredStyle: UIAlertControllerStyle.ActionSheet)
        let takePhoto = UIAlertAction(title: "Take photo", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            print("Take photo")
            self.takePhoto()
        })
        let fromAlbum = UIAlertAction(title: "From album", style: UIAlertActionStyle.Default, handler: {(action:UIAlertAction!) -> Void in
            print("from Album")
            self.fromAlbum()
        })
        let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.Cancel, handler: {(action:UIAlertAction!) -> Void in
            self.dismissViewControllerAnimated(true, completion: nil)
        })
        chooseImgFrom.addAction(takePhoto)
        chooseImgFrom.addAction(fromAlbum)
        chooseImgFrom.addAction(cancel)
        self.presentViewController(chooseImgFrom, animated: true, completion: nil)
    }
   
//    Change baby Icon by taking photo
    func takePhoto(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.Camera
            cameraViewController.delegate = self
            self.presentViewController(cameraViewController, animated: true, completion: nil)
            print("Tapped wow")
        }
        else{
            print("Disable tapped")
        }
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.babyIcon.image = image
        let baby = self.babyDataCD[0] as NSManagedObject
        baby.setValue(UIImagePNGRepresentation(image), forKey: "babyImage")
        do{
            print("Successfully updated photo")
            try baby.managedObjectContext?.save()
            print("Insert into coreData")
        }catch _{
            
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    Changing baby Icon by choosing a photo from the Album
    func fromAlbum(){
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    func back(sender: UIBarButtonItem) {
        print("You want to go back to viewController")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return babyGeneral.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: babyGeneralTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell") as! babyGeneralTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.category.text = babyGeneral[indexPath.row]
        cell.categoryIcon.image = UIImage(named: babyGeneral[indexPath.row])
        if(success == 0){
            cell.information.text = "Add data"
        }else{
            cell.information.text = babyData[indexPath.row]
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var alertMsg:String!
        switch(indexPath.row){
            case 0:alertMsg = "Baby name"
            case 3:alertMsg = "Baby height"
            case 4:alertMsg = "Baby weight"
            default: break
        }
        
//        Only row 0, row 3 and row 4 can be edited
        if(indexPath.row == 0 || indexPath.row == 3 || indexPath.row == 4){
            var inputTextField:UITextField!
            let changeBabyData = UIAlertController(title: "Update baby Information", message: alertMsg, preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
                let person = self.babyDataCD[0] as NSManagedObject
                if(indexPath.row == 3 || indexPath.row == 4){
                    person.setValue(NSNumber(integer: Int((inputTextField?.text)!)!), forKey: self.cdFormat[indexPath.row])
                }else{
                    person.setValue(inputTextField?.text, forKey: self.cdFormat[indexPath.row])
                }
            
                do{
                    print("Successfully updated baby infor")
                    try person.managedObjectContext?.save()
                    let data = self.tableView.cellForRowAtIndexPath(indexPath)?.viewWithTag(1) as! UILabel!
                    if(indexPath.row == 0){
                        data.text = inputTextField?.text
                    }else if(indexPath.row == 3){
                        data.text = (inputTextField?.text)! + " cm"
                    }else if(indexPath.row == 4){
                        data.text = (inputTextField?.text)! + " kg"
                    }
                    self.updateBabyDataNet(indexPath.row, inputD: (inputTextField?.text)!)
                }catch _{
                }
            })
            changeBabyData.addTextFieldWithConfigurationHandler { textField -> Void in
                // you can use this text field
                inputTextField = textField
            }
            changeBabyData.addAction(cancel)
            changeBabyData.addAction(ok)
            self.presentViewController(changeBabyData, animated: true, completion: nil)
        }
    }
    
//    fetch the baby profile data from the server
    func updateBabyDataNet(id:Int, inputD:String){
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/"+self.cdFormat[id]+".php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let postString = "email=\(userEmail)&value=\(inputD)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if(error != nil){
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
//                    This variable is the return value from the server, if it is Pass, then it fetches the data successfully
                    let resultValue = parseJSON["status"] as? String
                    dispatch_async(dispatch_get_main_queue(), {
                        if(resultValue == "Pass"){
                        }
                        else{
                            self.creatAlert("Error", message: "Please check you network configuration")
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
    func getOnlineChartData(){
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/getBabyChartData.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        print("Baby chart user Email is", userEmail)
        let postString = "email=\(userEmail)"
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
                    let onlineChartData = parseJSON["getResult"]
                    print(onlineChartData)
                    for index in 6...24{
                        if let temp = (onlineChartData![String(index)]){
//                        print(temp)
                        let doubleTemp = temp!.doubleValue
                        print("This is temp: ", doubleTemp)
                        if(doubleTemp != 0){
                            self.saveContext(index, weight: doubleTemp)
                        }
                        }
                    }
                    dispatch_async(dispatch_get_main_queue(), {
                        if(resultValue == "Success"){
                            
                        }
                        else{
                            let error = UIAlertController(title: "Error", message: "Please check your network configuration!:-(", preferredStyle: .Alert)
                            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            error.addAction(cancel)
                            error.addAction(ok)
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
    func saveContext(month: Int, weight: Double){
        self.fetchLocalData()
        var find:Int = 0
        for i in 0 ..< self.localChartData.count{
            if(self.localChartData[i].month == month){
                find = 1
                break
            }
        }
        if(find == 0){
            let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
            let chartdata = NSEntityDescription.insertNewObjectForEntityForName("BabyChart", inManagedObjectContext: context) as! BabyChart
            chartdata.month = month
            chartdata.weight = weight
            do{
                try context.save()
                print("Insert into coreData")
            }catch _{
            
            }
        }
       
    }
    func fetchLocalData(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "BabyChart")
        var result:[AnyObject]?
        do{
            result = try context.executeFetchRequest(request)
        }catch _{
            result = nil
        }
        if(result != nil)
        {
            self.localChartData = result as! [BabyChart]
            print(self.localChartData)
        }
    }
    
    
    func creatAlert(type:String, message:String){
        self.alertMsg = UIAlertController(title: type, message: message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
//    pull baby profile data from the core Data
    func pullLocalData() -> Int{
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        
        var results: [AnyObject]?
        
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        if(results != nil){
            self.babyDataCD = (results! as? [LogUser])!
            print("self.babyDataCD", self.babyDataCD[0].babyname)
            if(self.babyDataCD[0].babyname != nil){
                self.babyData.append(self.babyDataCD[0].babyname!)
                if(self.babyDataCD[0].gender == 0){
                    self.babyData.append("male")
                }else{
                    self.babyData.append("female")
                }
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                print("This is the birthday: ", self.babyDataCD[0].birthday!)
                print("Hello cal days", NSDate().offsetFrom(self.babyDataCD[0].birthday!))
                let bir:String! = formatter.stringFromDate(self.babyDataCD[0].birthday!)
                self.babyData.append(bir)
                self.babyData.append(String(self.babyDataCD[0].length!)+" cm")
                self.babyData.append(String(self.babyDataCD[0].weight!)+" kg")
                self.babyData.append(String(NSDate().offsetFrom(self.babyDataCD[0].birthday!))+" days")
                if(self.babyDataCD[0].babyImage == nil){
                    self.babyIcon.image = UIImage(named: "parentIcon")
                }else{
                    self.babyIcon.image = UIImage(data:self.babyDataCD[0].babyImage!)
                }
                return 1
            }
        }
        return 0
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
extension NSDate {
    func yearsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Year, fromDate: date, toDate: self, options: []).year
    }
    func monthsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Month, fromDate: date, toDate: self, options: []).month
    }
    func weeksFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.WeekOfYear, fromDate: date, toDate: self, options: []).weekOfYear
    }
    func daysFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Day, fromDate: date, toDate: self, options: []).day
    }
    func hoursFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Hour, fromDate: date, toDate: self, options: []).hour
    }
    func minutesFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Minute, fromDate: date, toDate: self, options: []).minute
    }
    func secondsFrom(date:NSDate) -> Int{
        return NSCalendar.currentCalendar().components(.Second, fromDate: date, toDate: self, options: []).second
    }
    func offsetFrom(date:NSDate) -> Int {
//        if yearsFrom(date)   > 0 { print("year");return yearsFrom(date)   }
//        if monthsFrom(date)  > 0 { print("month");return monthsFrom(date)  }
//        if weeksFrom(date)   > 0 { print("weeks");return weeksFrom(date)   }
        if daysFrom(date)    > 0 { print("days");return daysFrom(date)    }
//        if hoursFrom(date)   > 0 { print("hour");return hoursFrom(date)   }
//        if minutesFrom(date) > 0 { print("minutes");return minutesFrom(date) }
//        if secondsFrom(date) > 0 { print("second");return secondsFrom(date) }
        return 1000
    }
}