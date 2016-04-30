//
//  LogUser+CoreDataProperties.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/26.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension LogUser {

    @NSManaged var babyImage: NSData?
    @NSManaged var babyname: String?
    @NSManaged var babyWeight: String?
    @NSManaged var birthday: NSDate?
    @NSManaged var email: String?
    @NSManaged var faceBookId: String?
    @NSManaged var gender: NSNumber?
    @NSManaged var googleId: String?
    @NSManaged var hasComeToWorld: NSNumber?
    @NSManaged var length: NSNumber?
    @NSManaged var twitterId: String?
    @NSManaged var userImage: NSData?
    @NSManaged var username: String?
    @NSManaged var weight: NSNumber?

}
