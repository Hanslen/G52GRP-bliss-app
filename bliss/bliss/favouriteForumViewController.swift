//
//  favouriteForumViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/20.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class favouriteForumViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    var alertMsg:UIAlertController = UIAlertController()
    
    var getId:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "topicCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "topicCellIden")
        tableView.separatorColor = UIColor.clearColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favouriteTopic.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:topicTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("topicCellIden") as! topicTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.topicName.text = favouriteTopic[indexPath.row]["title"] as? String
        cell.introTopic.text = favouriteTopic[indexPath.row]["introduction"] as? String
        print("This is the userIcon", (favouriteTopic[indexPath.row]["owner"] as? String)!)
        let imageE:String! = favouriteTopic[indexPath.row]["owner"] as? String!
        cell.userIcon.image = getProfPic("http://bliss.sadiqi.org/api/ios/php/userIcon/"+imageE+".jpg")
        cell.userIcon.layer.borderWidth = 1.0
        cell.userIcon.layer.masksToBounds = false
        cell.userIcon.layer.borderColor = UIColor.whiteColor().CGColor
        cell.userIcon.layer.cornerRadius = cell.userIcon.frame.size.width/2
        cell.userIcon.clipsToBounds = true
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("favouriteForumDetailSegue", sender: favouriteTopic[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "favouriteForumDetailSegue"){
            let topicVC = segue.destinationViewController as! detailTopicViewController
            topicVC.topicName = sender!["title"] as! String
            topicVC.topicIntroduction = sender!["introduction"] as! String
            topicVC.topicId = sender!["id"] as! String
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 185
    }
    
//    Provide a delete function
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete"){(action:
            UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            let globalQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
            let group = dispatch_group_create()
            dispatch_group_async(group, globalQueue){
                () ->Void in
                self.deletFavouriteTopic(favouriteTopic[indexPath.row]["id"] as! String)
            }
            dispatch_group_wait(group, DISPATCH_TIME_FOREVER)
        }
        return [deleteAction]
    }

    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
//    Implement the delete function and excute that in the server
    func deletFavouriteTopic(topicId:String){
        print("You pass topic Id for deleting", topicId)
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/deleteFavouriteTopic.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let email:String = userEmail
        let postString = "email=\(email)&topicId=\(topicId)"
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
                        self.getTopicIdFromMYSQLForTableView()
                        if(resultValue == "Success"){
                            self.createAlertMsg("Success", Message: "Delete it successfully!:-)")
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
    
//    Fetch favourite topic id from MYSQL
    func getTopicIdFromMYSQLForTableView(){
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/getFavouriteTopic.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        let email:String = userEmail
        let postString = "email=\(email)"
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
                    
                    favouriteTopic = parseJSON["getResult"]! as! [AnyObject]
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
