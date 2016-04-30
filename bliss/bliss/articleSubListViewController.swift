//
//  articleSubListViewController.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/20.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import UIKit

class articleSubListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var titleNav:String! = ""
    let youAndYouBaby:[String]! = ["Why your baby may have arrived early", "Why your baby may be in special care", "How you might be feeling", "How bliss can help", "Financial advice for families"]
    let aboutNeonatalCare:[String]! = ["Different levels of care", "Who's who on the neonatal unit", "Equipment on the unit", "Baby transfers"]
    let visitingYourBaby:[String]! = ["Taking part in daily cares", "Skin-to-skin and Kangaroo Care", "Family-centred care"]
    let medicalConditionAndProdure:[String]! = ["Sepsis", "Necrotising Enterocolitis(NEC)", "Meningitis and septicaemia", "Pneumonia", "Patent ductus or patent ductus arteriosus(PDA)", "Brain haemorrhage", "MRSA", "Hypoxic-ischaemic encephalopathy(HIE)", "Common tests and procedures"]
    let feeding:[String]! = ["Total Parenteral Nutrition", "Tube feeding", "Expressing", "Breastfeeding", "Bottle feeding", "Colic and wind", "Reflux", "Weanning"]
    let settlingInAtHome:[String]! = ["Help at home", "Visitors", "Feeding Q&A", "Breastfeeding Q&A", "Vitamin supplements", "Follow up appointments", "Immunisations", "You baby's development", "Readmission to hospital"]
    let safeSleeping:[String]! = ["What is the best sleeping position?", "Can my baby sleep with me?", "Temperature", "Smoking"]
    let weaning:[String]! = ["When to start", "Important things to remember", "Meal times", "First foods", "Introducing more foods", "Finger foods", "Family foods", "Food refusal", "First year drinks and beyond"]
    let startingPrimarySchool:[String]! = ["Your options", "What the law says", "Your application pack", "Appeals and complaints", "Delaying school entry in the rest of the UK"]
    var currentCat:[String]!
    var colorForLeft:[UIColor]! = [UIColor(red: 248, green: 218, blue: 58), UIColor(red: 35, green: 215, blue: 124), UIColor(red: 255, green: 80, blue: 128), UIColor(red: 30, green: 175, blue: 255), UIColor(red: 143, green: 78, blue: 202)]
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        self.navigationItem.title = self.titleNav
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.currentCat = self.checkCategory()
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .Plain, target: nil, action: nil)
        
        let nib = UINib(nibName: "subArticleCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: "subArticleCell")
    }
    
//    return the list of the category user choose
    func changeNavToNoSpace(id:Int)->[String]{
        switch self.titleNav{
        case "You and your baby":switch id{
            case 0:return youAndYourBaby1
            case 1:return youAndYourBaby2
            case 2: return youAndYourBaby3
            case 3: return youAndYourBaby4
            case 4: return youAndYourBaby5
            default:break
            }
        case "About neonatal care":switch id{
            case 0: return aboutNeonatalCare1
            case 1: return aboutNeonatalCare2
            case 2: return aboutNeonatalCare3
            case 3: return aboutNeonatalCare4
            default:break
            }
        case "Visiting your baby":switch id{
            case 0: return visitingYourBaby1
            case 1: return visitingYourBaby2
            case 2:return visitingYourBaby3
            default:break
            }
        case "Medical conditions and procedures":switch id{
            case 0: return medicalConditionAndProdure1
            case 1:return medicalConditionAndProdure2
            case 2:return medicalConditionAndProdure3
            case 3: return medicalConditionAndProdure4
            case 4: return medicalConditionAndProdure5
            case 5: return medicalConditionAndProdure6
            case 6:return medicalConditionAndProdure7
            case 7: return medicalConditionAndProdure8
            case 8:return medicalConditionAndProdure9
            default:break
            }
        case "Feeding":switch id{
            case 0: return feeding1
            case 1:return feeding2
            case 2: return feeding3
            case 3: return feeding4
            case 4: return feeding5
            case 5:return feeding6
            case 6: return feeding7
            case 7:return feeding8
            default:break
            }
        case "Settling in at home":switch id{
            case 0:return settlingInAtHome1
            case 1:return settlingInAtHome2
            case 2: return settlingInAtHome3
            case 3: return settlingInAtHome4
            case 4: return settlingInAtHome5
            case 5: return settlingInAtHome6
            case 6:return settlingInAtHome7
            case 7: return settlingInAtHome8
            case 8: return settlingInAtHome9
            default:break
            }
        case "Safe Sleeping":switch id{
            case 0: return safeSleeping1
            case 1: return safeSleeping2
            case 2: return safeSleeping3
            case 3:return safeSleeping4
            default:break
            }
        case "Weaning":switch id{
            case 0: return weaning1
            case 1: return weaning2
            case 2: return weaning3
            case 3: return weaning4
            case 4: return weaning5
            case 5: return weaning6
            case 6: return weaning7
            case 7: return weaning8
            case 8:return weaning9
            default:break
            
            }
        case "Starting primary school":switch id{
            case 0: return startingPrimarySchool1
            case 1:return startingPrimarySchool2
            case 2:return startingPrimarySchool3
            case 3:return startingPrimarySchool4
            case 4 : return startingPrimarySchool5
            default:break
            }
        default:break
        }
        let error:[String]! = ["error","error"]
        return error
    }
    override func viewDidAppear(animated: Bool) {
        self.navigationController!.navigationBar.backgroundColor = UIColor(netHex: 0x0D616D)    }
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.currentCat.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:subArticleCellTableViewCell = self.tableView.dequeueReusableCellWithIdentifier("subArticleCell") as! subArticleCellTableViewCell
        cell.cellTitle.text = self.currentCat[indexPath.row]
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        cell.leftView.backgroundColor = self.colorForLeft[(indexPath.row%5)]
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let id:[String] = [self.titleNav, String(indexPath.row)]
        performSegueWithIdentifier("viewArticleSegue", sender: id)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "viewArticleSegue"){
            let data = sender as! [String]
            let title = data[0]
            let id = data[1]
            let articleVC = segue.destinationViewController as! viewArticleViewController
            articleVC.titleForArticle = title
            articleVC.id = id
            articleVC.article = changeNavToNoSpace(Int(id)!)
            
        }
    }
    
    //Check the category and should return the arraylist of the sublist of that category
    func checkCategory()->[String]{
        let error:[String]! = ["Error"]
        switch self.titleNav{
            case "You and your baby": return self.youAndYouBaby
            case "About neonatal care": return self.aboutNeonatalCare
            case "Visiting your baby":return self.visitingYourBaby
            case "Medical conditions and procedures": return self.medicalConditionAndProdure
            case "Feeding":return self.feeding
            case "Settling in at home":return self.settlingInAtHome
            case "Safe Sleeping":return self.safeSleeping
            case "Weaning":return self.weaning
            case "Starting primary school":return self.startingPrimarySchool
        default: return error
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
