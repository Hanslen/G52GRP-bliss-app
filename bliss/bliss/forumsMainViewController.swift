//
//  forumsMainViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/27.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class forumsMainViewController: UIViewController,UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var errorImage: UIImageView!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var tableView: UITableView!
    
    var getAllTopic:[AnyObject] = []
    var refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

//        network checking
        self.tableView.hidden = true
        self.errorImage.hidden = true
        self.errorLabel.hidden = true
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("networkStatusChanged:"), name: ReachabilityStatusChangedNotification, object: nil)
        Reach().monitorReachabilityChanges()
        let status = Reach().connectionStatus()
        
        switch status {
        case .Unknown, .Offline:
            let networkError = UIAlertController(title: "Error", message: "Please check your network connection", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            networkError.addAction(cancel)
            networkError.addAction(ok)
            self.errorImage.hidden = false
            self.errorLabel.hidden = false
            self.presentViewController(networkError, animated: true, completion: nil)
        case .Online(.WWAN):
            print("Connected via WWAN")
            self.tableView.hidden = false
        case .Online(.WiFi):
            print("Connected via WiFi")
            self.tableView.hidden = false
        }
        self.tableView.hidden = true
        //network check ends
        
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTapped")
        self.navigationItem.rightBarButtonItem = add
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        let nib = UINib(nibName: "topicCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "topicCellIden")
        tableView.separatorColor = UIColor.clearColor()
        refreshControl.tintColor = UIColor.whiteColor()
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: .ValueChanged)
        tableView.addSubview(refreshControl)
        self.getTopicFromMYSQL()
        
        print(getAllTopic)
    }
    
    func refresh(refreshControl: UIRefreshControl){
        self.getTopicFromMYSQL()
        refreshControl.endRefreshing()
    }
    func networkStatusChanged(notification: NSNotification) {
        let userInfo = notification.userInfo
        print(userInfo)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
//    Add a topic, if the user want to app a topic, he/she mush sign in first
    func addTapped(){
        let user = self.checkHasLoged()
        if(user.count == 0){
            let error = UIAlertController(title: "Error", message: "You must log in first!:-(", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            error.addAction(cancel)
            error.addAction(ok)
            self.presentViewController(error, animated: true, completion: nil)
        }else{
            performSegueWithIdentifier("addTopic", sender: nil)
        }
        
    }
    
//    Check has the user log in or not
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
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(getAllTopic.count == 0){
            return 1
        }else{
            return getAllTopic.count
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:topicTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("topicCellIden") as! topicTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        if(getAllTopic.count != 0){
            let specificTopic = getAllTopic[indexPath.row]
            let topicName:String! = specificTopic["title"] as! String
            cell.topicName.text = topicName
            cell.introTopic.text = getAllTopic[indexPath.row]["introduction"] as? String
            cell.userIcon.image = getProfPic((getAllTopic[indexPath.row]["userImage"] as? String)!)
            cell.userIcon.layer.borderWidth = 1.0
            cell.userIcon.layer.masksToBounds = false
            cell.userIcon.layer.borderColor = UIColor.whiteColor().CGColor
            cell.userIcon.layer.cornerRadius = cell.userIcon.frame.size.width/2
            cell.userIcon.clipsToBounds = true
        }
        return cell
        
    }
    
//    Get all the topics from the mysql server
    func getTopicFromMYSQL()->[AnyObject]{
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/getAllTopic.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        
        let postString = ""
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
                    self.getAllTopic = parseJSON["getResult"]! as! [AnyObject]
                    dispatch_async(dispatch_get_main_queue(), {
                        self.tableView.reloadData()
                        self.tableView.hidden = false
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
        return getAllTopic
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier("presentDetailTopic", sender: getAllTopic[indexPath.row])
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "presentDetailTopic"){
            let topicVC = segue.destinationViewController as! detailTopicViewController
            topicVC.topicName = sender!["title"] as! String
            topicVC.topicIntroduction = sender!["introduction"] as! String
            topicVC.topicId = sender!["id"] as! String
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 185
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

//Extend the CALayer for drawing a bottom line
extension CALayer {
    func addUnderLine(color: UIColor, thickness: CGFloat) {
        let border = CALayer()
        border.frame = CGRectMake(20, CGRectGetHeight(self.frame) - thickness, CGRectGetWidth(self.frame)-40, thickness)
        border.backgroundColor = color.CGColor;
        self.addSublayer(border)
    }}
