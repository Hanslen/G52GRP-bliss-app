//
//  addDiaryViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/24.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class addDiaryViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet var titleTF: UITextField!
    @IBOutlet var diaryTF: UITextView!
    @IBOutlet var addImageIcon: UIButton!
    var diaryPic:UIImage! = UIImage(named: "AppIcon")
    let attributedString = NSMutableAttributedString(string: "before after")
    let textAttachment = NSTextAttachment()
    var alertMsg = UIAlertController()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let done = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "doneTapped")
        self.navigationItem.rightBarButtonItem = done
        self.diaryTF.delegate = self
        self.addImageIcon.hidden = true
    }

    @IBAction func endTitleTF(sender: UITextField) {
        titleTF.resignFirstResponder()
    }
    
//    When the user enter a "Enter" expand the textView for more text
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            textView.frame.size.height = 300
            return false
        }
        return true
    }
    
//    Save the diary data into core Data
    func saveContext(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let diary = NSEntityDescription.insertNewObjectForEntityForName("Diary", inManagedObjectContext: context) as! Diary
        if(self.titleTF.text == "" || self.diaryTF.text == ""){
            self.alertMsg = UIAlertController(title: "Error", message: "Please fill all the blanket!:-(", preferredStyle: .Alert)
            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
            self.alertMsg.addAction(cancel)
            self.alertMsg.addAction(ok)
            self.presentViewController(self.alertMsg, animated: true, completion: nil)
        }else{
            diary.title = self.titleTF.text
            diary.context = self.diaryTF.text
            let date = NSDate()
            diary.date = date
        
            do{
                try context.save()
                print("Insert into coreData")
                self.createAlertMsg("Success", Message: "You have saved the diary successfully!")
            }catch _{
            
            }
        }
    }
    
    func createAlertMsg(Type:String, Message:String){
        self.alertMsg = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: {(action:UIAlertAction!) -> Void in
            self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("backToDiarySegue", sender: nil)
        })
        let ok = UIAlertAction(title: "OK", style: .Default, handler: {(action:UIAlertAction!) -> Void in
            self.alertMsg.dismissViewControllerAnimated(true, completion: nil)
            self.performSegueWithIdentifier("backToDiarySegue", sender: nil)
        })
        self.alertMsg.addAction(cancel)
        self.alertMsg.addAction(ok)
        self.presentViewController(self.alertMsg, animated: true, completion: nil)
    }
    
    func doneTapped(){
//        print("Done is tapped")
        self.saveContext()
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
