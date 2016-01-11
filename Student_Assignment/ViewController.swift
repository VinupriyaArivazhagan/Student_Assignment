//
//  ViewController.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/11/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

let STUDENT_URL = "http://103.230.85.92/smaapi/MastersMServices/StudentsMService.svc/FetchStudentsMbyParent"
let ASSIGNMENT_URL = "http://103.230.85.92/smaapi/MastersMServices/AssignmentService.svc/FetchAssignmentsByStudentsID"

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, AssignmentCellDelegate,PopUPDelegate {

    var student_data : Student!
    var arrAssignment : [Assignment]! = [Assignment]()
    var popupView : PopUPView!
    var ShowPopUp : Bool = false
    
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var btnPopUp: UIBarButtonItem!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        let con : UIViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("PopUPView")
        popupView  = con.view as! PopUPView
        popupView.delegate = self
        
        let arrData : [AnyObject] = Student.getData()
        if arrData.count > 0
        {
            student_data = arrData[0] as! Student
            let assignement_set : NSSet = student_data.relation_assignment! as NSSet
            for assignmet in assignement_set
            {
                let assignment_data : Assignment = assignmet as! Assignment
                arrAssignment.append(assignment_data)
            }
            for student in arrData
            {
                let stu : Student = student as! Student
                popupView.arrData.append(stu.name!)
            }
            popupView.frame = CGRectMake(view.frame.size.width - 160, 54, 150, CGFloat(popupView.arrData.count * 50) )
            popupView.heightConstraint.constant = CGFloat(popupView.arrData.count * 50)
            popupView.tblView.reloadData()
            tblView.delegate = self
            tblView.dataSource = self
            tblView.reloadData()
        }
        else
        {
            btnPopUp.enabled = false
            GetStudent()
        }
    }
    
    func GetStudent()
    {
        weak var weakSelf = self
        let dictPostBody = ["guidParentTransID" : "f5811ed7-e61f-428a-9d98-c5d493f66b3f"]
        let session : UrlSession = UrlSession.sharedInstance
        AppDelegate.SharedDelegate().ShowLoadingView()
        session.connectWithUrl(NSURL(string: STUDENT_URL)!, params: dictPostBody, closure: {result in
            AppDelegate.SharedDelegate().HideLoadingView()
            switch result {
            case let .Success(response):
                if let FetchStudentsMbyParentResult = response["FetchStudentsMbyParentResult"]
                {
                    if FetchStudentsMbyParentResult["ResponseCode"] as! NSNumber == NSNumber(int: 1)
                    {
                        for dict in FetchStudentsMbyParentResult["StudentsMClass"] as! [AnyObject]
                        {
                            if let dictResult : [String : AnyObject] = dict as? [String : AnyObject]
                            {
                                weakSelf?.GetAssignment(dictResult)
                            }
                        }
                    }
                }
                
            case let .Failure(error):
                print("\(error.localizedDescription)")
            }
        })
    }
    
    func GetAssignment(dictResult : [String : AnyObject])
    {
        weak var weakSelf = self
        let dictPostBody = ["guidStudentTransID" : dictResult["TransID"]!]
        let session : UrlSession = UrlSession.sharedInstance
        AppDelegate.SharedDelegate().ShowLoadingView()
        session.connectWithUrl(NSURL(string: ASSIGNMENT_URL)!, params: dictPostBody, closure: {result in
            AppDelegate.SharedDelegate().HideLoadingView()
            switch result {
            case let .Success(response):
                if let FetchStudentsMbyParentResult = response["FetchAssignmentsByStudentsIDResult"]
                {
                    if FetchStudentsMbyParentResult["ResponseCode"] as! NSNumber == NSNumber(int: 1)
                    {
                        if let arrResult : [AnyObject] = FetchStudentsMbyParentResult["AssignmentClass"] as? [AnyObject]
                        {
                            Student.saveStudent(dictResult, dictAssignment: arrResult)
                            let arrData : [AnyObject] = Student.getData()
                            if arrData.count > 0
                            {
                                weakSelf!.student_data = arrData[0] as! Student
                                let assignement_set : NSSet = weakSelf!.student_data.relation_assignment! as NSSet
                                weakSelf!.arrAssignment.removeAll()
                                for assignmet in assignement_set
                                {
                                    let assignment_data : Assignment = assignmet as! Assignment
                                    weakSelf!.arrAssignment.append(assignment_data)
                                }
                                weakSelf!.popupView.arrData.removeAll()
                                for student in arrData
                                {
                                    let stu : Student = student as! Student
                                    weakSelf!.popupView.arrData.append(stu.name!)
                                }
                                weakSelf!.btnPopUp.enabled = true
                                weakSelf!.popupView.tblView.reloadData()
                                weakSelf!.popupView.heightConstraint.constant = CGFloat(weakSelf!.popupView.arrData.count * 50)
                                weakSelf!.popupView.frame = CGRectMake(weakSelf!.view.frame.size.width - 160, 64, 150, CGFloat(weakSelf!.popupView.arrData.count * 50) )
                                weakSelf!.tblView.delegate = self
                                weakSelf!.tblView.dataSource = self
                                weakSelf!.tblView.reloadData()
                            }
                        }
                    }
                }
                
            case let .Failure(error):
                print("\(error.localizedDescription)")
            }
        })
    }

    //MARK: Tableview datasouce and delagte
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1
        {
            return arrAssignment.count
        }
        return 1
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if indexPath.section == 0
        {
            return 100
        }
        else
        {
            return 150
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        if indexPath.section == 0
        {
            let cell: ProfileCell = tableView.dequeueReusableCellWithIdentifier("ProfileCell", forIndexPath: indexPath) as! ProfileCell
            cell.lblName.text = student_data.name
            cell.lblStandard.text = student_data.standard
            cell.selectionStyle = UITableViewCellSelectionStyle.None
            return cell
        }
        else
        {
            let cell: AssignmentCell = tableView.dequeueReusableCellWithIdentifier("AssignmentCell", forIndexPath: indexPath) as! AssignmentCell
            let assignment : Assignment = arrAssignment[indexPath.row] as Assignment
            cell.lblSubject.text = assignment.subjectName
            cell.lblTitle.text = "Title : " + "\(assignment.title!)"
            cell.lblDuteDate.text = "Due Date : " + "\(assignment.dueDate!)"
            cell.delegate = self
            cell.attachmentUrl = assignment.attachment
            
            if assignment.isAttachment == NSNumber(int: 0)
            {
                cell.btnAttachment.hidden = true
            }
            else
            {
                cell.btnAttachment.hidden = false
            }
            return cell
        }
    }
    
    //MARK: Assignment cell delagte
    
    func ShowAttachment(attachmentUrl: String)  {
        let vc: AttachmentViewController = storyboard?.instantiateViewControllerWithIdentifier("AttachmentViewController") as! AttachmentViewController
        vc.attachmentUrl = attachmentUrl
        navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: popup delagte
    
    func ShowStudent(indexPath: NSIndexPath) {
        let arrData : [AnyObject] = Student.getData()
        if arrData.count > indexPath.row
        {
            student_data = arrData[indexPath.row] as! Student
            let assignement_set : NSSet = student_data.relation_assignment! as NSSet
            arrAssignment.removeAll()
            for assignmet in assignement_set
            {
                let assignment_data : Assignment = assignmet as! Assignment
                arrAssignment.append(assignment_data)
            }
            popupView.removeFromSuperview()
            ShowPopUp = false
            tblView.delegate = self
            tblView.dataSource = self
            tblView.reloadData()
        }
    }
    
    @IBAction func PopUp(sender: AnyObject) {
        if ShowPopUp == false
        {
            self.view.addSubview(popupView)
            ShowPopUp = true
        }
        else
        {
            popupView.removeFromSuperview()
            ShowPopUp = false
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

