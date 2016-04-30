//
//  booksViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 15/12/20.
//  Copyright © 2015年 G52GRP-peter. All rights reserved.
//

import UIKit

class booksViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UINavigationControllerDelegate, UIWebViewDelegate{
    
    @IBOutlet var collectionView: UICollectionView!
    let gif = UIImage.gifWithName("loading")
    
//    Store the book Details
    var books:[String] = ["Your special care baby: A guide for families", "Look at me-I'm talking to you", "Multiple births-A parents' guide to neonatal care", "Going home on oxygen", "Weaning your premature baby", "Skin to Skin", "Common winter illnesses", "Going home: the next big step"]
    var bookURL:[NSURL]! = [NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=7366b6ce-cbbe-420c-bad2-77275a7dd193")!,NSURL(string: "http://bliss.org.uk/Handlers/Download.ashx?IDMF=cdb3e4f0-2346-4b0d-9d07-d58f211eec1b")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=3fed7f9b-7fc7-494a-943a-7627681fd384")!,NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=869bbf25-af6c-4a4a-9c00-5dfad7936758")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=4249368c-02ac-4eae-b3d4-4fdb115a6a66%20")!, NSURL(string: "http://bliss.org.uk/Handlers/Download.ashx?IDMF=73dc0750-0ddf-4752-bcdd-a74ac3f86595")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=bbe903a7-4efb-4f7a-950a-cfa2ef594367")!, NSURL(string: "http://www.bliss.org.uk/Handlers/Download.ashx?IDMF=d4936722-0fe8-44f3-94fb-df4044df2b62")!]
    var bookImg:[String] = ["book1", "book3", "book5", "book7", "book2", "book4", "book6", "book8"]
    
    var selectedCell: bookCollectionViewCell!
    var loadingImgO:UIImageView!
    var loadingTextO:UILabel!
    var selected = 0
    var cellWeb:UICollectionViewCell!
    var selectedId:Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.

        collectionView.dataSource = self
        collectionView.delegate = self
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.navigationController?.delegate = self
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
    }

    override func viewWillDisappear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.books.count
    }
    
    //Displaying a collection cell (the book)
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("bookcell", forIndexPath: indexPath) as UICollectionViewCell
        let bookName = cell.viewWithTag(1) as! UILabel
        bookName.text = self.books[indexPath.row]
        let bookImg = cell.viewWithTag(2) as! UIImageView
        bookImg.image = UIImage(named: self.bookImg[indexPath.row])
        let loadingText = cell.viewWithTag(5) as! UILabel
        loadingText.hidden = true
        let loadingImge = cell.viewWithTag(4) as! UIImageView
        loadingImge.image = gif
        loadingImge.hidden = true
        let webView = cell.viewWithTag(3) as! UIWebView
        webView.hidden = true
        let backButton = cell.viewWithTag(6) as! UIButton
        backButton.hidden = true
        return cell
    }
    
//    When click a book, should show the animation and pass the url to the webView
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        view.backgroundColor = UIColor.whiteColor()
        if(self.selected == 0){
            self.selectedId = indexPath.row
            cellWeb = collectionView.cellForItemAtIndexPath(indexPath)
            self.navigationController?.navigationBar.hidden = true
            let bookImg = cellWeb?.viewWithTag(2) as! UIImageView
            bookImg.hidden = true
            let loadingText = cellWeb!.viewWithTag(5) as! UILabel
            loadingText.hidden = false
            self.loadingTextO = loadingText
            let loadingImge = cellWeb!.viewWithTag(4) as! UIImageView
            loadingImge.hidden = false
            self.loadingImgO = loadingImge
            let webView = cellWeb!.viewWithTag(3) as! UIWebView
            webView.hidden = false
            webView.loadRequest(NSURLRequest(URL: bookURL[indexPath.row]))
            webView.delegate = self
            webView.scalesPageToFit = true
            let bookName = cellWeb?.viewWithTag(1) as! UILabel
            bookName.hidden = true
            collectionView.scrollEnabled = false
            let backButton = cellWeb!.viewWithTag(6) as! UIButton
            backButton.hidden = false
            backButton.addTarget(self, action: Selector("backBtnAction"), forControlEvents: UIControlEvents.TouchUpInside)
            cellWeb?.superview?.bringSubviewToFront(cellWeb!)
            UIView.animateWithDuration(0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: [], animations: ({
                self.cellWeb?.frame = collectionView.bounds
            }), completion: nil)
            self.selected = 1
        }
        
    }
    
//    Go back to the main page
    func backBtnAction(){
        view.backgroundColor = UIColor(netHex: 0x0D616D)
        let indexPath = collectionView?.indexPathsForSelectedItems() as [NSIndexPath]!
        collectionView?.scrollEnabled = true
        collectionView?.reloadItemsAtIndexPaths(indexPath)
        self.navigationController?.navigationBar.hidden = false
        let bookName = self.cellWeb.viewWithTag(1) as! UILabel
        bookName.text = self.books[self.selectedId]
        bookName.hidden = false
        let bookImg = self.cellWeb.viewWithTag(2) as! UIImageView
        bookImg.image = UIImage(named: self.bookImg[self.selectedId])
        bookImg.hidden = false
        let loadingText = self.cellWeb.viewWithTag(5) as! UILabel
        loadingText.hidden = true
        let loadingImge = self.cellWeb.viewWithTag(4) as! UIImageView
        loadingImge.image = gif
        loadingImge.hidden = true
        let webView = self.cellWeb.viewWithTag(3) as! UIWebView
        webView.hidden = true
        let backButton = self.cellWeb.viewWithTag(6) as! UIButton
        backButton.hidden = true
        
        self.selected = 0
    }
    
    //Add loading gif for the webView
    func webViewDidFinishLoad(webView: UIWebView) {
        self.loadingImgO.hidden = true
        self.loadingTextO.hidden = true
        print("Finish")
    }
    func webViewDidStartLoad(webView: UIWebView) {
        print("Start")
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
