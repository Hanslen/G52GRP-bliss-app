//
//  detailTopicViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/27.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class detailTopicViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var topicTitle: UILabel!
    
    @IBOutlet var topicIntro: UILabel!
    @IBOutlet var followerNumber: UILabel!
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var followButton: UIButton!
    @IBOutlet var tableView: UITableView!
    var topicName:String!
    var topicIntroduction:String!
    var topicId:String!
    var allComment:[AnyObject]! = []
    var alertMsg:UIAlertController! = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        followButton.layer.addBorder(UIRectEdge.Top, color: UIColor.whiteColor(), thickness: 0.5)
        followButton.layer.addBorder(UIRectEdge.Right, color: UIColor.whiteColor(), thickness: 0.5)
        followButton.layer.addBorder(UIRectEdge.Bottom, color: UIColor.whiteColor(), thickness: 0.5)
        commentButton.layer.addBorder(UIRectEdge.Top, color: UIColor.whiteColor(), thickness: 0.5)
        commentButton.layer.addBorder(UIRectEdge.Bottom, color: UIColor.whiteColor(), thickness: 0.5)
        commentButton.layer.addBorder(UIRectEdge.Left, color: UIColor.whiteColor(), thickness: 0.5)
        
        let favourite = UIBarButtonItem(image: UIImage(named: "like.png"), style: .Plain, target: self, action: "like")
        self.navigationItem.rightBarButtonItem = favourite;
        self.tableView.dataSource = self
        self.tableView.delegate = self
        topicTitle.text = topicName
        topicIntro.text = topicIntroduction
        
        let nib = UINib(nibName: "commentCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "commentCell")
        self.getTopicFromMYSQL()
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    override func viewDidAppear(animated: Bool) {
        if(self.checkAlreadyLike()){
            let favourite = UIBarButtonItem(image: UIImage(named: "like_filled.png"), style: .Plain, target: self, action: "unlike")
            self.navigationItem.rightBarButtonItem = favourite;
        }else{
            let favourite = UIBarButtonItem(image: UIImage(named: "like.png"), style: .Plain, target: self, action: "like")
            self.navigationItem.rightBarButtonItem = favourite;
        }
    }
    func unlike(){
        let results = self.checkHasLoged()
        if(results.count == 0){
            self.createAlertMsg("Error", Message: "You must log in first!:-(")
        }else{
            self.deletFavouriteTopic(topicId)
            let favourite = UIBarButtonItem(image: UIImage(named: "like.png"), style: .Plain, target: self, action: "like")
            self.navigationItem.rightBarButtonItem = favourite;
        }
    }
    
    func checkAlreadyLike()->Bool{
        
        for(var i = 0; i < favouriteTopic.count; i++){
            print("Pai",favouriteTopic[i]["id"])
            if(favouriteTopic[i]["id"] as! String == topicId){
                print("Already liked")
                return true
            }
        }
        return false
    }
    
    func like(){
        let results = self.checkHasLoged()
        if(results.count == 0){
            self.createAlertMsg("Error", Message: "You must log in first!:-(")
        }else{
            self.favouriteTopicRequest()
            let favourite = UIBarButtonItem(image: UIImage(named: "like_filled.png"), style: .Plain, target: self, action: "unlike")
            self.navigationItem.rightBarButtonItem = favourite;
        }
    }
    //Send User data to server side
    func favouriteTopicRequest(){
        let URL:NSURL = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/favouriteTopic.php")!
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "POST"
        
        let email:String! = userEmail
        let postString = "email=\(email)&topicId=\(self.topicId)"
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
                if let parseJSON = json
                {
                    let messageToDisplay:Bool = parseJSON["message"] as! Bool!
                    dispatch_async(dispatch_get_main_queue(), {
                        if(messageToDisplay == true){
                            self.createAlertMsg("Success", Message: "You have add this topic to favourtite successfully!:-)")
                        }else{
                            self.createAlertMsg("Error", Message: "Please check your network configuration!:-(")
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
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
    @IBAction func midFavouriteTopic(sender: UIButton) {
        if(self.checkAlreadyLike()){
            self.createAlertMsg("Error", Message: "You have already like the topic!:-)")
        }else{
            self.like()
        }
    }
    
    @IBAction func postComment(sender: UIButton) {
        let results = self.checkHasLoged()
        if(results.count == 0){
            self.createAlertMsg("Error", Message: "You must log in first!:-(")
        }else{
         performSegueWithIdentifier("postComment", sender: nil)
        }
    }
    
    func checkHasLoged()->[AnyObject]{
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        var results: [AnyObject]?
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        return results!
    }

    @IBAction func seeFullIntroduction(sender: UIButton) {
        self.performSegueWithIdentifier("seeIntroduction", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "postComment"){
            let commentVC = segue.destinationViewController as! addCommentForTopicViewController
            commentVC.topicId = self.topicId
            commentVC.topicIntro = self.topicIntroduction
            commentVC.topicName = self.topicName
            
        }
        else if(segue.identifier == "seeIntroduction"){
            if(sender == nil){
                let detailVC = segue.destinationViewController as! topicIntroFullViewController
                detailVC.topicId = self.topicId
                detailVC.topicIntroduction = self.topicIntroduction
                detailVC.topicName = self.topicName
                print("Seeing detailed controller")
            }else{
                print("I want to see comment")
                let detailVC = segue.destinationViewController as! topicIntroFullViewController
                detailVC.topicId = self.topicId
                detailVC.topicIntroduction = self.topicIntroduction
                detailVC.topicName = self.topicName
                let id = sender as! Int
                detailVC.comment = allComment[id]["comment"] as! String
                
            }
            
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(self.allComment.count == 0){
            return 1
        }else{
            return allComment.count
        }
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("seeIntroduction", sender: indexPath.row)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:commentCellTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("commentCell") as! commentCellTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if(allComment.count != 0){
            
            cell.userComment.text = allComment[indexPath.row]["comment"] as? String
            let email:String! = allComment[indexPath.row]["owner"] as! String
            let imageURL:String! = "http://bliss.sadiqi.org/api/ios/php/userIcon/"+email+".jpg"
            cell.userName.text = allComment[indexPath.row]["username"] as? String
            cell.userIcon.image = getProfPic(imageURL)
            cell.userIcon.layer.borderWidth = 1.0
            cell.userIcon.layer.masksToBounds = false
            cell.userIcon.layer.borderColor = UIColor.whiteColor().CGColor
            cell.userIcon.layer.cornerRadius = cell.userIcon.frame.size.width/2
            cell.userIcon.clipsToBounds = true
            self.tableView.hidden = false
            print("The comment URL is ", imageURL)
        }else{
            self.tableView.hidden = true
        }
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    //Get the topic comment from the mysql server
    func getTopicFromMYSQL(){
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/getComment.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = "topicId=\(topicId)"
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
                    self.allComment = parseJSON["getResult"]! as! [AnyObject]
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
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

    //Delete the favourite topic, which means unlike it
    func deletFavouriteTopic(topicId:String){
        print("You pass topic Id for deleting", topicId)
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/deleteFavouriteTopic.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let email:String = userEmail
        let postString = "email=\(email)&topicId=\(topicId)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
        //        print("Get all topic")
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
                    getTopicIdFromMYSQL()
                    dispatch_async(dispatch_get_main_queue(), {
                        if(resultValue == "Success"){
                            self.createAlertMsg("Success", Message: "Un favourite it successfully!:-)")
                        }
                        else{
                            self.createAlertMsg("Error", Message: "Please check your network configuration!:-(")
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

//Extend the UILabel to resize the height automatically
extension UILabel {
    func resizeHeightToFit(heightConstraint: NSLayoutConstraint) {
        let attributes = [NSFontAttributeName : font]
        numberOfLines = 0
        lineBreakMode = NSLineBreakMode.ByWordWrapping
        let rect = text!.boundingRectWithSize(CGSizeMake(frame.size.width, CGFloat.max), options: NSStringDrawingOptions.UsesLineFragmentOrigin, attributes: attributes, context: nil)
        heightConstraint.constant = rect.height
        setNeedsLayout()
    }
}
