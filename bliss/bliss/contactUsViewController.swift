//
//  contactUsViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/1/20.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import MessageUI

class contactUsViewController: UIViewController, MFMailComposeViewControllerDelegate, UITableViewDataSource,UITableViewDelegate{
    
    @IBOutlet var toolbar: UIToolbar!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var scrollView: UIScrollView!
    var contact:String!
    var contactInfo:String!
    var contactInfoExtra:String!
    var busPhone:String!
    let serviceName:[String]! = ["Bliss Family Support", "Bliss Scotland", "Bliss Birmingham", "Bliss Leeds", "Bliss Manchester"]
    let servicePhone:[String]! = ["0500618140","07920650546","0121713 8823", "07436102 619","0161234 2788"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.tableView.dataSource = self
        self.tableView.delegate = self
        let nib = UINib(nibName: "contactUsCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "contactUsCell")
        
        self.toolbar.setBackgroundImage(UIImage(),forToolbarPosition: UIBarPosition.Any,barMetrics: UIBarMetrics.Default)
        self.toolbar.setShadowImage(UIImage(),forToolbarPosition: UIBarPosition.Any)
        
        self.scrollView.frame = CGRectMake(0, 0, self.scrollView.frame.width, self.scrollView.frame.height*0.8)
        scrollView.backgroundColor = UIColor(netHex: 0xD616D)
        let scrollViewHeight = self.scrollView.frame.height*1
        let scrollViewWidth = self.scrollView.frame.width/3.5
        
        let blissFamilyService = UIImageView(frame: CGRectMake(0, 0, scrollViewWidth, scrollViewHeight))
        let blissScotland = UIImageView(frame: CGRectMake(scrollViewWidth*1, 0, scrollViewWidth, scrollViewHeight))
        let blissBirmingham = UIImageView(frame: CGRectMake(scrollViewWidth*2, 0, scrollViewWidth, scrollViewHeight))
        let blissLeeds = UIImageView(frame: CGRectMake(scrollViewWidth*3, 0, scrollViewWidth, scrollViewHeight))
        let blissManchester = UIImageView(frame: CGRectMake(scrollViewWidth*4, 0, scrollViewWidth, scrollViewHeight))
        let blissDepartmental = UIImageView(frame: CGRectMake(scrollViewWidth*5, 0, scrollViewWidth, scrollViewHeight))
        blissFamilyService.image = UIImage(named: "blissFamilyService")
        blissScotland.image = UIImage(named: "blissScotland")
        blissBirmingham.image = UIImage(named: "blissBirmingham")
        blissLeeds.image = UIImage(named: "blissLeeds")
        blissManchester.image = UIImage(named: "blissMach")
        blissDepartmental.image = UIImage(named: "departmentalService")
        
        self.scrollView.addSubview(blissFamilyService)
        self.scrollView.addSubview(blissScotland)
        self.scrollView.addSubview(blissBirmingham)
        self.scrollView.addSubview(blissLeeds)
        self.scrollView.addSubview(blissManchester)
        self.scrollView.addSubview(blissDepartmental)
        
        self.scrollView.contentSize = CGSizeMake(scrollViewWidth*6, self.scrollView.frame.height)
    }
    @IBAction func alertRing(sender: UIBarButtonItem) {
        let warning = UIAlertController(title: "Warning", message: "Please pay attention to the opening time!:-)", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        warning.addAction(cancel)
        warning.addAction(ok)
        self.presentViewController(warning, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.serviceName.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:contactUsTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("contactUsCell") as! contactUsTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.serviceName.text = self.serviceName[indexPath.row]
        cell.serviceNumber.text = self.servicePhone[indexPath.row]
        cell.phone.tag = indexPath.row
        cell.phone.addTarget(self, action: "callBliss:", forControlEvents: .TouchUpInside)

        return cell
    }
    
    func callBliss(sender:UIButton){
        let number:String! = String(self.servicePhone[sender.tag])
        if let url = NSURL(string: "tel://\(number)") {
            UIApplication.sharedApplication().openURL(url)
        }
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
//    Open the facebook App
    @IBAction func facebookContact(sender: UIButton) {
        let fbURLWeb:NSURL = NSURL(string: "https://www.facebook.com/Blisscharity")!
        let fbURLID:NSURL = NSURL(string: "fb://profile/95155519857")!
        if(UIApplication.sharedApplication().canOpenURL(fbURLID)){
            UIApplication.sharedApplication().openURL(fbURLID)
        }else{
            UIApplication.sharedApplication().openURL(fbURLWeb)
        }
    }
    
//    Open the twitter App
    @IBAction func twitterContact(sender: UIButton) {
        let twitterUrl:NSURL = NSURL(string:"twitter://user?screen_name=blisscharity")!
        let twitterWeb:NSURL = NSURL(string: "https://twitter.com/blisscharity")!
        if(UIApplication.sharedApplication().canOpenURL(twitterUrl)){
            UIApplication.sharedApplication().openURL(twitterUrl)
        }else{
            UIApplication.sharedApplication().openURL(twitterWeb)
        }
    }

//    Open the website
    @IBAction func websiteContact(sender: UIButton) {
        let blissURLWeb:NSURL = NSURL(string: "http://www.bliss.org.uk")!
        UIApplication.sharedApplication().openURL(blissURLWeb)
    }
    
    func configuredMailComposeViewController()->MFMailComposeViewController{
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["ask@bliss.org.uk"])
        mailComposerVC.setSubject("App contacts")
        mailComposerVC.setMessageBody("Hi bliss, \n", isHTML: false)
        return mailComposerVC
    }
    @IBAction func emailContact(sender: UIButton) {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail(){
            self.presentViewController(mailComposeViewController, animated:true, completion:nil)
        }else{
            self.showSendMailErrorAlert()
        }
    }
    
    
//    The following two functions are for showing create a email message for the bliss
    func showSendMailErrorAlert(){
        let sendMailErrorAlert = UIAlertController(title: "Could not send email", message: "Your device could not send e-mail. Please check e-mail configuration and try again.", preferredStyle: UIAlertControllerStyle.Alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let okAction = UIAlertAction(title: "OK", style: .Default, handler: nil)
        sendMailErrorAlert.addAction(cancelAction)
        sendMailErrorAlert.addAction(okAction)
        
        self.presentViewController(sendMailErrorAlert, animated:true){
            
        }
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        switch result.rawValue{
            case MFMailComposeResultCancelled.rawValue:print("Cancel email")
            case MFMailComposeResultSent.rawValue:print("Mail sent")
            default:break
        }
        self.dismissViewControllerAnimated(true, completion: nil)
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
