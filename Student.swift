//
//  Student.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/12/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import Foundation
import CoreData

@objc(Student)
class Student: NSManagedObject {

    class func saveStudent(dict : [String:AnyObject], dictAssignment : [AnyObject] ) {
        
        let managedObjectContext = AppDelegate.SharedDelegate().managedObjectContext
        
        let entity =  NSEntityDescription.entityForName("Student",
            inManagedObjectContext:managedObjectContext)
        
        let newItem = Student(entity: entity!,
            insertIntoManagedObjectContext: managedObjectContext)
        
        if let name : String = dict["Name"] as? String{
            newItem.name = name
        }
        
        if let standardName : String = dict["StandardName"] as? String, let sectionName : String = dict["SectionName"] as? String  {
            newItem.standard = "\(standardName)" + " - " +  "\(sectionName)"
        }
        
        if let transid : String = dict["TransID"] as? String {
            newItem.transId = transid
        }
        
        var assignments: NSMutableSet
        
        assignments = newItem.mutableSetValueForKey("relation_assignment")
        for dictResult in dictAssignment
        {
            let entity_assignment =  NSEntityDescription.entityForName("Assignment",
                inManagedObjectContext:managedObjectContext)
            
            let newItem_assignment = Assignment(entity: entity_assignment!,
                insertIntoManagedObjectContext: managedObjectContext)
            if let subjectName : String = dictResult["SubjectName"] as? String {
                newItem_assignment.subjectName = subjectName
            }
            
            if let dueDate : String = dictResult["DueDate"] as? String {
                newItem_assignment.dueDate = dueDate
            }
            
            if let title : String = dictResult["AssignmentTitle"] as? String {
                newItem_assignment.title = title
            }
            
            if let isAttachment : NSNumber = dictResult["IsAttachment"] as? NSNumber {
                newItem_assignment.isAttachment = isAttachment
            }
            
            if let attachment : String = dictResult["Attachment"] as? String {
                newItem_assignment.attachment = attachment
            }
            
            newItem_assignment.relation_student = newItem
            assignments.addObject(newItem_assignment)
        }
        do
        {
            try managedObjectContext.save()
        }
        catch
        {
            print(error)
        }
    }

    class func getData() -> [AnyObject] {
        
        let managedObjectContext = AppDelegate.SharedDelegate().managedObjectContext
        
        let fetchRequest : NSFetchRequest = NSFetchRequest()
        fetchRequest.entity = NSEntityDescription.entityForName("Student", inManagedObjectContext: managedObjectContext)
        
        var arrList = [AnyObject]()
        do
        {
            arrList = try managedObjectContext.executeFetchRequest(fetchRequest)
        }
        catch
        {
            print (error)
        }
        return arrList
    }
}
