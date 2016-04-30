//
//  favouriteViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/9.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class favouriteViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var subNav: UINavigationBar!
    @IBOutlet var forumButton: UIButton!
    @IBOutlet var articleButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        
        self.subNav.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.subNav.shadowImage = UIImage()
        self.subNav.backgroundColor = UIColor(netHex: 0x358875)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        forumButton.backgroundColor = UIColor(netHex: 0x358875)
        forumButton.layer.cornerRadius = 5
        forumButton.layer.borderWidth = 3
        forumButton.layer.borderColor = UIColor.whiteColor().CGColor
        
        articleButton.backgroundColor = UIColor(red: 1, green: 1, blue: 1, alpha: 1)
        articleButton.layer.cornerRadius = 5
        
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back:")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        let nib = UINib(nibName: "favouriteCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "favouriteCell")
        tableView.separatorColor = UIColor.clearColor()
    }
    
//    Go back to the main page
    func back(sender: UIBarButtonItem) {
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(red: 0.1921568627, green: 0.537254902, blue: 0.4588235294, alpha: 1)
        getTopicIdFromMYSQL()
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 141
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:favouriteTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("favouriteCell") as! favouriteTableViewCell
        return cell
    }

//    Enable the delete favourite forum from the category
    func tableView(tableView: UITableView, editActionsForRowAtIndexPath indexPath: NSIndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .Default, title: "Delete"){(action:
            UITableViewRowAction!, indexPath: NSIndexPath!) -> Void in
            self.createAlertMsg("Success", Message: "Delete successfully~")
        }
        return [deleteAction]
    }
    
    func createAlertMsg(Type:String, Message:String){
        let error = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        error.addAction(cancel)
        error.addAction(ok)
        self.presentViewController(error, animated: true, completion: nil)
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
