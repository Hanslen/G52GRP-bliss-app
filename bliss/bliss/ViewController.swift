//
//  ViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 15/12/2.
//  Copyright © 2015年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData
import CoreSpotlight
class ViewController: UIViewController {

    
    @IBOutlet weak var menuButton: UIBarButtonItem!
    @IBOutlet weak var searchButton: UIBarButtonItem!
    @IBOutlet var accountButton: UIButton!
    @IBOutlet var articleButton: UIButton!
    @IBOutlet var forumsButton: UIButton!
    @IBOutlet var settingsButton: UIButton!
    @IBOutlet var babyButton: UIButton!
    @IBOutlet var booksButton: UIButton!
    @IBOutlet var favouriteButton: UIButton!
    @IBOutlet var contactUsButton: UIButton!
    var search:[String]! = ["Bliss"]
    var user:[LogUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.spotSearch()
        
//        initialize the navigation controller style
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        
        self.navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationController?.navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor(),
                NSFontAttributeName : UIFont(name: "Gill Sans", size: 25)!
            ]
        
//        cancel the animation of button
        accountButton.adjustsImageWhenHighlighted = false
        articleButton.adjustsImageWhenHighlighted = false
        forumsButton.adjustsImageWhenHighlighted = false
        settingsButton.adjustsImageWhenHighlighted = false
        babyButton.adjustsImageWhenHighlighted = false
        booksButton.adjustsImageWhenHighlighted = false
        favouriteButton.adjustsImageWhenHighlighted = false
        contactUsButton.adjustsImageWhenHighlighted = false
        
        getTopicIdFromMYSQL()
        self.checkHasLoged()
    }
    override func viewDidAppear(animated: Bool) {
        getTopicIdFromMYSQL()
    
    }
    
//    Due to myAccount and Baby category must sign in first, so the following two functions are used for check has the user login or not
    @IBAction func clickForAccount(sender: UIButton) {
        let results = self.checkHasLoged()
        if(results.count == 0){
            print("You have not logged")
            performSegueWithIdentifier("logInSegue", sender: "My Account")
        }
        else{
            performSegueWithIdentifier("myAccountSegue", sender: nil)
        }
    }
    
    @IBAction func clickForBaby(sender: UIButton) {
        let results = self.checkHasLoged()
        if(results.count == 0){
            print("You have not logged")
            performSegueWithIdentifier("logInSegue", sender: "Baby")
        }
        else{
            performSegueWithIdentifier("babySegue", sender: nil)
        }
    }
    
//    check has the user logged in or not
    func checkHasLoged()->[AnyObject]{
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "LogUser")
        var results: [AnyObject]?
        do{
            results = try context.executeFetchRequest(request)
        }catch _{
            results = nil
        }
        self.user = results as? [LogUser]
        return results!
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "logInSegue"){
            let signInVC = segue.destinationViewController as! signUpViewController
            signInVC.titleForNav = sender as! String
        }
    }
    
//    Implement the spotlight search function
    func spotSearch(){
        for se in self.search{
            let attributeSet = CSSearchableItemAttributeSet(itemContentType: "kUTTypeItem")
            attributeSet.title = se
            attributeSet.contentDescription = "For babies born too soon, too small, too sick. Check winter illness, baby chart and booksr"
            let item = CSSearchableItem(uniqueIdentifier: se, domainIdentifier: "G52GRP-peter.bliss", attributeSet: attributeSet)
            
            CSSearchableIndex.defaultSearchableIndex().indexSearchableItems([item], completionHandler: nil)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

