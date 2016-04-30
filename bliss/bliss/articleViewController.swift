//
//  articleViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/2.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class articleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    
//    The following functions are for different segue to a subArticle list
    @IBAction func bbc(sender: UIButton) {
        performSegueWithIdentifier("beforeNextSegue", sender: "Before Birth")
    }
    @IBAction func npc(sender: UIButton) {
        performSegueWithIdentifier("beforeNextSegue", sender: "Next Pregnancy")
    }
    @IBAction func inHosptialClick(sender: UIButton) {
        performSegueWithIdentifier("articleToListSegue", sender: "In Hospital")
    }
    @IBAction func goingHomeClick(sender: UIButton) {
        performSegueWithIdentifier("articleToListSegue", sender: "Going Home")
    }
    @IBAction func atHomeClick(sender: UIButton) {
        performSegueWithIdentifier("articleToListSegue", sender: "At Home")
    }
    @IBAction func growingUpClick(sender: UIButton) {
        performSegueWithIdentifier("articleToListSegue", sender: "Growing Up")
    }
    
//    Implement the segue
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "articleToListSegue"){
            let articleListVC = segue.destinationViewController as! articleDetailViewController
            articleListVC.titleNav = sender as! String
        }else if(segue.identifier == "beforeNextSegue"){
            let detailVC = segue.destinationViewController as! viewArticleViewController
            let articleName:String! = sender as! String
            detailVC.titleForArticle = articleName
            if(articleName == "Before Birth"){
                detailVC.article = beforeBirth
            }else{
                detailVC.article = nextPregancy
            }
            
        }
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
