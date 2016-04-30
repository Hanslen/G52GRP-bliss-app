//
//  userInfo.swift This file is for global functions and variables
//  bliss
//
//  Created by Hanslen Chen on 16/2/21.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//

import Foundation
import CoreData

//This variable store the favourite topic for the user
var favouriteTopic:[AnyObject] = []

//This variable store the log in user's email
var userEmail:String! = ""

//Get the favourite topic from the server and store it in the favouriteTopic
func getTopicIdFromMYSQL(){
        checkHasLoged()
        let myUrl = NSURL(string: "http://bliss.sadiqi.org/api/ios/php/getFavouriteTopic.php")
        let request = NSMutableURLRequest(URL: myUrl!)
        request.HTTPMethod = "POST"
        print("The current email is", userEmail)
        let email:String = userEmail
        let postString = "email=\(email)"
        request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding)
//        print("Get all topic")
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request){
            data, response, error in
            if(error != nil){
                
//                print("Get all topic")
                print("error=\(error)")
                return
            }
            do {
                let json = try NSJSONSerialization.JSONObjectWithData(data!, options: .MutableContainers) as? NSDictionary
                
                if let parseJSON = json
                {
                    let resultValue = parseJSON["status"] as? String
                    
//                    print("Get all topic")
                    favouriteTopic = parseJSON["getResult"]! as! [AnyObject]
                    print("return topic:\(favouriteTopic)")
//                    print("wow Done for result:",resultValue)
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        
                        if(resultValue == "Success"){
                            
                        }
                        else{
                            let error = UIAlertController(title: "Error", message: "Please check your network configuration!:-(", preferredStyle: .Alert)
                            let cancel = UIAlertAction(title: "Cancel", style: .Cancel, handler: nil)
                            let ok = UIAlertAction(title: "OK", style: .Default, handler: nil)
                            error.addAction(cancel)
                            error.addAction(ok)
                        }
                    })
                    
                }
                
            }catch
            {
                print(error)
            }
            
        }
        task.resume()
}
func checkHasLoged()->[AnyObject]{
    let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext
    let request = NSFetchRequest(entityName: "LogUser")
    var results: [AnyObject]?
    var logUser: [LogUser]!
    do{
        results = try context.executeFetchRequest(request)
    }catch _{
        results = nil
    }
    if(results != nil){
        if(results?.count != 0){
            logUser = results! as? [LogUser]
            userEmail = logUser![0].email
        }
    }
    return results!
}

func getProfPic(imgURLString: String) -> UIImage? {
    let imgURL = NSURL(string: imgURLString)
    let imageData = NSData(contentsOfURL: imgURL!)
    if(imageData != nil){
        let image = UIImage(data: imageData!)
        return image
    }
    
    return UIImage(named: "parentIcon")
    
}
