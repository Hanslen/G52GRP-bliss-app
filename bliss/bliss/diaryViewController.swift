//
//  diaryViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/23.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit
import CoreData

class diaryViewController: UIViewController,UICollectionViewDataSource, UICollectionViewDelegate{
    @IBOutlet var collectionVIew: UICollectionView!
    var diaries:[Diary] = []
    var selectedTitle:String!
    var selectedContext:String!
    var selectedTime:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        let add = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "addTapped")
        self.navigationItem.rightBarButtonItem = add
        self.collectionVIew.dataSource = self
        self.collectionVIew.delegate = self
        
        let newBackButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: .Plain, target: self, action: "back")
        newBackButton.image = UIImage(named: "back.png")
        self.navigationItem.leftBarButtonItem = newBackButton;
        
        self.fetchLocalData()
    }
    
//    This function is for go back to the main page
    func back(){
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let MainVC : UIViewController = storyBoard.instantiateViewControllerWithIdentifier("mainStoryBoard")
        self.navigationController?.pushViewController(MainVC, animated: true)
    }
    
//    The diary data has been stored locally, this part is for fetch the local diary data
    func fetchLocalData(){
        let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
        let request = NSFetchRequest(entityName: "Diary")
        var result:[AnyObject]?
        do{
            result = try context.executeFetchRequest(request)
        }catch _{
            result = nil
        }
        if(result != nil)
        {
            self.diaries = result as! [Diary]
        }
        self.collectionVIew.reloadData()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return diaries.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("diaryCell", forIndexPath: indexPath) as UICollectionViewCell
        let date = cell.viewWithTag(1) as! UILabel
        
        //Transfer date format
        let formatter = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        date.text = formatter.stringFromDate(diaries[indexPath.row].date!)
        
        let title = cell.viewWithTag(2) as! UILabel
        title.text = diaries[indexPath.row].title
        let context = cell.viewWithTag(3) as! UILabel
        context.text = diaries[indexPath.row].context
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.cellForItemAtIndexPath(indexPath)
        let date = cell?.viewWithTag(1) as! UILabel
        self.selectedTime = date.text
        let title = cell?.viewWithTag(2) as! UILabel
        self.selectedTitle = title.text
        let context = cell?.viewWithTag(3) as! UILabel
        self.selectedContext = context.text
        self.performSegueWithIdentifier("detailDiarySegue", sender: nil)
    }
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "detailDiarySegue"){
            let detailDiaryVC = segue.destinationViewController as! diaryDetailViewController
            detailDiaryVC.diaryT = self.selectedTitle
            detailDiaryVC.contextT = self.selectedContext
            detailDiaryVC.timeT = self.selectedTime
        }
    }
    
    func addTapped(){
        print("Add data for diary")
        performSegueWithIdentifier("addDiarySegue", sender: nil)
    }
    
    //The main page's navigation bar is translucent, but the diary has color, the following function is for transfer the color between two controller
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }
    
    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
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
