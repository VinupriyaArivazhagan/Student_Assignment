//
//  PopUPView.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/12/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

protocol PopUPDelegate : class
{
    func ShowStudent(indexPath : NSIndexPath)
}

class PopUPView: UIView {

    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tblView: UITableView!
    var arrData : [String] = [String]()
    weak var delegate : PopUPDelegate!
    
    /*
    // Only override drawRect: if you perform custom drawing.
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

    //MARK: Tableview datasouce and delagte
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrData.count
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return 50
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell: UITableViewCell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel?.text = arrData [indexPath.row]
        cell.textLabel?.textColor = UIColor.blackColor()
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        delegate.ShowStudent(indexPath)
    }
    
}
