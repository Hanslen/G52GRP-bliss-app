//
//  viewArticleViewController.swift This file is for displaying the article in the article category, when it receive the data, it will customize it automatically
//  bliss
//
//  Created by Hanslen Chen on 16/2/20.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class viewArticleViewController: UIViewController {
    
    var titleForArticle:String! = ""
    @IBOutlet var scrollView: UIScrollView!
    var id:String! = ""
    var yPosition:CGFloat = 0
    let textLength:Int! = 0
    var article:[String]!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        print("The article id is ",id)
        
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
        self.navigationItem.title = self.titleForArticle
        
        let mainPic:UIImage = UIImage(named: article[0])!
        let mainPicView:UIImageView = UIImageView()
        mainPicView.image = mainPic
        mainPicView.frame.size.width = self.view.frame.size.width
        mainPicView.frame.size.height = (self.view.frame.size.width)/2
        mainPicView.frame.origin.x = 0
        mainPicView.frame.origin.y = -10
        yPosition += (self.view.frame.size.width)/2
        scrollView.addSubview(mainPicView)
        
        //Displaying the artilce, when i is a even number it is the title, otherwise is the context
        for(var i = 1; i < article.count; i++){
            if(i%2 == 0){
                let titleLabel:UILabel! = UILabel()
                titleLabel.text = article[i]
                titleLabel.textColor = UIColor(netHex: 0x37BC9B)
                titleLabel.font = UIFont(name: "Gill Sans", size: 30)
                titleLabel.frame.size.width = self.view.frame.size.width-20
                titleLabel.frame.size.height = heightForView(titleLabel.text!, font: titleLabel.font, width: titleLabel.frame.size.width)
                titleLabel.frame.origin.x = 10
                titleLabel.numberOfLines = 0
                titleLabel.frame.origin.y = yPosition
                yPosition += titleLabel.frame.size.height
                scrollView.addSubview(titleLabel)
            }else{
                let intro:UILabel! = UILabel()
                intro.text = article[i]
                intro.textColor = UIColor.whiteColor()
                intro.font = UIFont(name: "Gill Sans", size: 18)
                intro.frame.size.width = self.view.frame.size.width-20
                intro.frame.size.height = heightForView(intro.text!, font: intro.font, width: intro.frame.size.width)
                intro.frame.origin.x = 10
                intro.frame.origin.y = yPosition
                intro.numberOfLines = 0
                yPosition += intro.frame.size.height
                scrollView.addSubview(intro)
            }
        }
        
        scrollView.contentSize = CGSize(width: self.view.frame.size.width, height: yPosition)
    }
    
    func heightForView(text:String, font:UIFont, width:CGFloat) -> CGFloat{
        let label:UILabel = UILabel(frame: CGRectMake(0, 0, width, CGFloat.max))
        label.numberOfLines = 0
        label.lineBreakMode = NSLineBreakMode.ByWordWrapping
        label.font = font
        label.text = text
        
        label.sizeToFit()
        return label.frame.height
    }
    
    func like(){
        let success = UIAlertController(title: "Success", message: "You have added this article to your favourite!:-)", preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        success.addAction(cancel)
        success.addAction(ok)
        self.presentViewController(success, animated: true, completion: nil)
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

//An extension for the string count length
extension String {
    var count: Int { return self.characters.count }
}