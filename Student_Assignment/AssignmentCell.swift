//
//  AssignmentCell.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/11/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

protocol AssignmentCellDelegate : class
{
    func ShowAttachment(attachmentUrl : String)
}

class AssignmentCell: UITableViewCell {

    @IBOutlet weak var lblSubject: UILabel!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblDuteDate: UILabel!
    @IBOutlet weak var btnAttachment: UIButton!
    
    var attachmentUrl : String!
    weak var delegate : AssignmentCellDelegate!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func Attachment(sender: AnyObject) {
        delegate.ShowAttachment(attachmentUrl)
    }
}
