//
//  myAccountViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/24.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class myAccountViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    var username:String = ""
    var email:String = ""
    var loguser: [LogUser]? = nil

    @IBOutlet var babyName: UILabel!
    @IBOutlet var babyBirth: UILabel!
    @IBOutlet var babyDetailButton: UIButton!
    @IBOutlet var logOutButton: UIButton!
    @IBOutlet var resetPasswordButton: UIButton!
    
    @IBOutlet var faceBookConnect: UILabel!
    @IBOutlet var userNameButton: UIButton!
    @IBOutlet var emailStaticLabel: UILabel!
    @IBOutlet var emailLabel: UILabel!
    @IBOutlet var googleButton: UIButton!
    @IBOutlet var twitterButton: UIButton!
    @IBOutlet var fbButton: UIButton!
    @IBOutlet var userIcon: UIImageView!
    let tapRec = UITapGestureRecognizer()
    
    var alertMsg:UIAlertController!
    var success = 0
    
    
    let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
    let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        tapRec.addTarget(self, action: "changeIcon")
        userIcon.addGestureRecognizer(tapRec)
        userIcon.userInteractionEnabled = true
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        logOutButton.backgroundColor = UIColor(netHex: 0x0D616D)
        logOutButton.layer.cornerRadius = 10
        logOutButton.layer.borderWidth = 2
        logOutButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        resetPasswordButton.backgroundColor = UIColor.whiteColor()
        resetPasswordButton.layer.cornerRadius = 10
        resetPasswordButton.layer.borderWidth = 2
        resetPasswordButton.layer.borderColor = UIColor(netHex: 0x0D616D).CGColor
        
        userIcon.layer.borderWidth = 1.0
        userIcon.layer.masksToBounds = false
        userIcon.layer.borderColor = UIColor.whiteColor().CGColor
        userIcon.layer.cornerRadius = userIcon.frame.size.width/2
        userIcon.clipsToBounds = true
        
        babyDetailButton.layer.cornerRadius = 10
        babyDetailButton.layer.borderWidth = 2
        babyDetailButton.layer.borderColor = UIColor(netHex: 0x0D616D).CGColor
        
        pullLocalData()
    }
    
    
    @IBAction func checkBabyDetail(sender: UIButton) {
    }
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    func back(sender: UIBarButtonItem) {
        print("You want to go back to viewController")
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    func changeIcon() {
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
    
    func takePhoto(){
        if(UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)){
            let cameraViewController = UIImagePickerController()
            cameraViewController.sourceType = UIImagePickerControllerSourceType.Camera
            cameraViewController.delegate = self
            self.presentViewController(cameraViewController, animated: true, completion: nil)
            print("Tapped")
        }
        else{
            print("Disable tapped")
        }
    }
    
    func fromAlbum(){
        let picker : UIImagePickerController = UIImagePickerController()
        picker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picker.delegate = self
        picker.allowsEditing = false
        self.presentViewController(picker, animated: true, completion: nil)
    }
    
    @IBAction func updateUserName(sender: UIButton) {
        var inputTextField: UITextField?
        let inputNameAlert = UIAlertController(title: "Please Input your name: ", message: "", preferredStyle: .Alert)
        var inputName:String! = ""
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "Submit", style: .Default, handler: {(action:UIAlertAction!) -> Void in
            let person = self.loguser![0] as NSManagedObject
            person.setValue(inputTextField?.text, forKey: "username")
            do{
                print("Successfully updated username")
                try person.managedObjectContext?.save()
                self.userNameButton.titleLabel?.text = inputTextField?.text
                inputName = inputTextField?.text
                self.updateUsernameNet(inputName)
            }catch _{
            }
        })
        inputNameAlert.addTextFieldWithConfigurationHandler { textField -> Void in
            // you can use this text field
            inputTextField = textField
        }
        inputNameAlert.addAction(cancel)
        inputNameAlert.addAction(ok)
        self.presentViewController(inputNameAlert, animated: true, completion: nil)
        
        
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        self.userIcon.image = UIImage(named: "parentIcon")
        
        let person = self.loguser![0] as NSManagedObject
        person.setValue(UIImageJPEGRepresentation(image, 1), forKey: "userImage")
        do{
            self.userIcon.image = image
            print("Successfully updated photo")
            try person.managedObjectContext?.save()
            print("Insert into coreData")
            self.myImageUploadRequest()
        }catch _{
            
        }
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    Upload the user Icon to the server
    func myImageUploadRequest()
    {
        
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/postImage.php");
        
        let request = NSMutableURLRequest(URL:myUrl!);
        request.HTTPMethod = "POST";
        
        let param = [
            "userId": self.email
        ]
        
        let boundary = generateBoundaryString()
        
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        
        let imageData = UIImageJPEGRepresentation(userIcon.image!, 1)
        
        if(imageData==nil)  { return; }
        
        request.HTTPBody = createBodyWithParameters(param, filePathKey: "file", imageDataKey: imageData!, boundary: boundary)
        
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            if error != nil {
                print("error=\(error)")
                return
            }
            
            // You can print out response object
            print("******* response = \(response)")
            
            // Print out reponse body
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("****** response data = \(responseString!)")
            
            do {
                if let jsonResult = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    print(jsonResult) }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
        }
        
        task.resume()
        
    }
    
//    Update the userName, and this operation should update the serverside as well
    func updateUsernameNet(usernameI:String){
        let userNamen:String! = usernameI
        
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/updateUsername.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "email=\(emailLabel.text!)&username=\(userNamen)"
        print("PostString is ", postString)
        print("This is the postString: ", postString)
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
                        }
                        else{
                            self.createAlertMsg("Error", Message: "Please check you network configuration")
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

//    The following functions are the subFunction for the uploading user Icon to the server, transfer the data format
    func createBodyWithParameters(parameters: [String: String]?, filePathKey: String?, imageDataKey: NSData, boundary: String) -> NSData {
        let body = NSMutableData();
        
        if parameters != nil {
            for (key, value) in parameters! {
                body.appendString("--\(boundary)\r\n")
                body.appendString("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n")
                body.appendString("\(value)\r\n")
            }
        }
        
        let filename = self.email+".jpg"
        
        let mimetype = "image/jpg"
        
        body.appendString("--\(boundary)\r\n")
        body.appendString("Content-Disposition: form-data; name=\"\(filePathKey!)\"; filename=\"\(filename)\"\r\n")
        body.appendString("Content-Type: \(mimetype)\r\n\r\n")
        body.appendData(imageDataKey)
        body.appendString("\r\n")
        
        
        
        body.appendString("--\(boundary)--\r\n")
        
        return body
    }
    
    func generateBoundaryString() -> String {
        return "Boundary-\(NSUUID().UUIDString)"
    }
    @IBAction func logOutType(sender: UIButton) {
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        context.deleteObject(self.loguser![0] as NSManagedObject)
        self.loguser?.removeAtIndex(0)
        do{
            try context.save()
            self.success = 1
            creatAlert("Success", message: "You have logged off successfully!:-)")
            
        }catch _{
            creatAlert("Error", message: "Sorry...Please try again.:-(")
        }
    }
    
//    Pull the login user local data from the core data
    func pullLocalData(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        
        var results: [AnyObject]?
        
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        if(results != nil){
            self.loguser = results! as? [LogUser]
            username = self.loguser![0].username!
            self.userNameButton.setTitle(loguser![0].username as String!, forState: .Normal)
            self.emailLabel.text = loguser![0].email as String!
            self.email = loguser![0].email as String!
            if(loguser![0].userImage == nil){
                self.userIcon.image = UIImage(named: "parentIcon")
            }else{
                self.userIcon.image = UIImage(data: loguser![0].userImage!)
            }
            let fbId:String! = loguser![0].faceBookId
            if(fbId != "0"){
            }else{
                self.faceBookConnect.text = "Not connected"
                self.faceBookConnect.textColor = UIColor.grayColor()
            }
            print("This is the faceBookId: ", fbId)
            if(loguser![0].babyname == nil){
                self.babyName.text = "Please add baby data"
                self.babyBirth.text = "Click the buttom"
            }else{
                self.babyName.text = "Name: "+loguser![0].babyname!
                let formatter = NSDateFormatter()
                formatter.dateFormat = "yyyy-MM-dd"
                let bir:String! = formatter.stringFromDate(loguser![0].birthday!)
                self.babyBirth.text = "Birthday: "+bir
            }
        }
        
    }
    
    
    func creatAlert(type:String, message:String){
        self.alertMsg = UIAlertController(title: type, message: message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action:UIAlertAction!) -> Void in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
            self.presentViewController(MainVC, animated: true, completion: nil)
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: { (action:UIAlertAction!) -> Void in
            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
            self.navigationController?.pushViewController(MainVC, animated: true)
        })
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }

}

//Extend the CALayer for drawing a border
extension CALayer {
    
    func addBorder(edge: UIRectEdge, color: UIColor, thickness: CGFloat) {
        
        let border = CALayer()
        
        switch edge {
        case UIRectEdge.Top:
            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame)*0.535, thickness)
            break
        case UIRectEdge.Bottom:
            border.frame = CGRectMake(-100, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame), thickness)
            break
        case UIRectEdge.Left:
            border.frame = CGRectMake(-0, 0, thickness, CGRectGetHeight(self.frame))
            break
        case UIRectEdge.Right:
            border.frame = CGRectMake(CGRectGetWidth(self.frame) - thickness, 0, thickness, CGRectGetHeight(self.frame))
            break
        default:
            break
        }
        
        border.backgroundColor = color.CGColor;
        
        self.addSublayer(border)
    }
    
}

//Extend the UIColor for hexFor color
extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}

//Extend the UIImage for rotate the image
extension UIImage {
    public func imageRotatedByDegrees(degrees: CGFloat, flip: Bool) -> UIImage {
        let radiansToDegrees: (CGFloat) -> CGFloat = {
            return $0 * (180.0 / CGFloat(M_PI))
        }
        let degreesToRadians: (CGFloat) -> CGFloat = {
            return $0 / 180.0 * CGFloat(M_PI)
        }
        
        // calculate the size of the rotated view's containing box for our drawing space
        let rotatedViewBox = UIView(frame: CGRect(origin: CGPointZero, size: size))
        let t = CGAffineTransformMakeRotation(degreesToRadians(degrees));
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size
        
        // Create the bitmap context
        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()
        
        // Move the origin to the middle of the image so we will rotate and scale around the center.
        CGContextTranslateCTM(bitmap, rotatedSize.width / 2.0, rotatedSize.height / 2.0);
        
        //   // Rotate the image context
        CGContextRotateCTM(bitmap, degreesToRadians(degrees));
        
        // Now, draw the rotated/scaled image into the context
        var yFlip: CGFloat
        
        if(flip){
            yFlip = CGFloat(-1.0)
        } else {
            yFlip = CGFloat(1.0)
        }
        
        CGContextScaleCTM(bitmap, yFlip, -1.0)
        CGContextDrawImage(bitmap, CGRectMake(-size.width / 2, -size.height / 2, size.width, size.height), CGImage)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
}
extension NSMutableData {
    
    func appendString(string: String) {
        let data = string.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
        appendData(data!)
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


