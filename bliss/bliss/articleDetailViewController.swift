//
//  articleDetailViewController.swift The sublist of the article
//  bliss
//
//  Created by Hanslen Chen on 16/2/10.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class articleDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView: UITableView!
    
    var titleNav:String! = ""
//    These arrays are for the subList of the article
    let inHosptial = [["You and your baby", "Find out why your baby may have arrived early, why they have been admitted into neonatal care and sources of help and support.", "inHospital1"], ["About neonatal care", "Find out about the different levels of neonatal care and the equipment and terminology used on the neonatal unit.", "inHospital2"], ["Visiting your baby", "Answers to common questions from parents about visiting their baby in the neonatal unit.", "inHospital3"], ["Medical conditions and procedures", "Find out about different types of infections and other medical conditions, and some common tests and procedures.", "inHospital4"], ["Feeding", "In this section, you can find more information about different ways of feeding.", "inHospital5"], ["Multiple births", "Babies in a multiple pregnancy are more likely to need neonatal care in hospital after birth.", "inHospital6"]]
    let goingHome = [["Going home with your baby", "Watch our going home video and find out more about leaving the neonatal unit.", "goingHome1"], ["Preparing to go home", "Information on preparing to go home from the neonatal unit.", "goingHome2"], ["Before you leave", "A checklist to help you before your baby leaves the neonatal unit.", "goingHome3"], ["Transporting your baby", "Information about transporting your baby from the hospital to home.", "goingHome4"], ["Going home on oxygen", "Some babies who need extra help with breathing will go home from the neonatal unit 'on oxygen'.", "goingHome5"]]
    let atHome = [["Settling in at home", "Information for parents of special care babies about settling in at home.", "atHome1"], ["Safe Sleeping", "This section tells you what you need to know about safe sleeping for your baby.", "atHome2"], ["Multiple babies", "Going home with multiple babies.", "atHome3"], ["If your baby becomes unwell", "This section looks at what to do if your baby becomes unwell.", "atHome4"], ["Common winter illnesses", "Common winter illnesses and reducing the risk of infection", "atHome5"],["Weaning", "Guidance on weaning your premature baby.", "atHome6"]]
    let growingUp = [["Developmental milestones", "Premature babies may take longer to reach major developmental milestones than babies born at full term.", "growingUp1"], ["Advice for families wih a disabled child", "Babies who are born premature or sick sometimes start life with a disability. Find information here about help and benefits available to them.", "growingUp2"],["Starting primary school", "Information and resources to help you if your child was born prematurely and is not yet ready to start school", "growingUp3"]]
    var currentCat:[Array<String>]!
    var subTitle:String! = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let nib = UINib(nibName: "favouriteCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "favouriteCell")
        tableView.separatorColor = UIColor.clearColor()
        self.navigationItem.title = self.titleNav
        currentCat = self.getArticleListArray()
        
    }
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
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCat.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:favouriteTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("favouriteCell") as! favouriteTableViewCell
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.title.text = self.currentCat[indexPath.row][0]
        cell.intro.text = self.currentCat[indexPath.row][1]
        cell.picForArticle.image = UIImage(named: self.currentCat[indexPath.row][2])
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let title:String! = self.currentCat[indexPath.row][0]
        subTitle = self.currentCat[indexPath.row][0]
        if(self.noSubArticle(self.currentCat, id: indexPath.row) == 0){
            performSegueWithIdentifier("subArticleSegue", sender: title)
        }
    }
    
//    When some category do not have and article, need to show them detailly
    func noSubArticle(cat:[[String]], id:Int)->Int{
        if(cat == self.inHosptial){
            if(id != 5){
                return 0
            }
            performSegueWithIdentifier("noSubArticleSegue", sender: multipleBirths)
            return 1
        }else if(cat == self.goingHome){
            if(id != 0 && id != 1 && id != 2 && id != 3 && id != 4){
                return 0
            }
            switch id{
                case 0: performSegueWithIdentifier("noSubArticleSegue", sender: goingHome1)
                case 1:performSegueWithIdentifier("noSubArticleSegue", sender: goingHome2)
                case 2:performSegueWithIdentifier("noSubArticleSegue", sender: goingHome3)
                case 3:performSegueWithIdentifier("noSubArticleSegue", sender: goingHome4)
                case 4:performSegueWithIdentifier("noSubArticleSegue", sender: goingHome5)
                default:break
            }
            return 1
        }else if(cat == self.atHome){
            if(id != 2 && id != 3 && id != 4){
                return 0
            }
            switch id{
                case 2: performSegueWithIdentifier("noSubArticleSegue", sender: atHome2)
                case 3: performSegueWithIdentifier("noSubArticleSegue", sender: atHome3)
                case 4: performSegueWithIdentifier("noSubArticleSegue", sender: atHome4)
                default:break
            }
            return 1
        }else if(cat == self.growingUp){
            if(id != 0 && id != 1){
                return 0
            }
            switch id{
                case 0: performSegueWithIdentifier("noSubArticleSegue", sender: growingUp0)
                case 1: performSegueWithIdentifier("noSubArticleSegue", sender: growingUp1)
                default:break
            }
            return 1
        }
        return 0
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "subArticleSegue"){
            let articleDetailListVC = segue.destinationViewController as! articleSubListViewController
            articleDetailListVC.titleNav = sender as! String
        }else if(segue.identifier == "noSubArticleSegue"){
            let noSubArticleDetailVC = segue.destinationViewController as! viewArticleViewController
            noSubArticleDetailVC.titleForArticle = self.subTitle
            noSubArticleDetailVC.article = sender as! [String]
        }
    }
    
    
    
    func createAlertMsg(Type:String, Message:String){
        let error = UIAlertController(title: Type, message: Message, preferredStyle: .Alert)
        let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
        let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
        error.addAction(cancel)
        error.addAction(ok)
        self.presentViewController(error, animated: true, completion: nil)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 140.5
    }
    
    func getArticleListArray() -> [Array<String>]{
        let empty:[Array<String>] = [["error"]]
        print("Print the titleNav:", self.titleNav)
        switch self.titleNav{
            case "In Hospital":return self.inHosptial
            case "Going Home": return self.goingHome
            case "At Home":return self.atHome
            case "Growing Up":return self.growingUp
            default: print("Error, for getArticle List Array")
        }
        return empty
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
