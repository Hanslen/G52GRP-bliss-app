//
//  BabyChart+CoreDataProperties.swift
//  bliss
//
//  Created by Hanslen Chen on 16/2/24.
//  Copyright © 2016年 G52GRP-peter. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension BabyChart {

    @NSManaged var month: NSNumber?
    @NSManaged var weight: NSNumber?

}
