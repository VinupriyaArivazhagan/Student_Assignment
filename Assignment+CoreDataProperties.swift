//
//  Assignment+CoreDataProperties.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/12/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Assignment {

    @NSManaged var subjectName: String?
    @NSManaged var title: String?
    @NSManaged var dueDate: String?
    @NSManaged var isAttachment: NSNumber?
    @NSManaged var attachment: String?
    @NSManaged var relation_student: Student?

}
