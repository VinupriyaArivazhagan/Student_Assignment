//
//  ProfileCell.swift
//  Student_Assignment
//
//  Created by Vinupriya on 1/11/16.
//  Copyright © 2016 Vinupriya. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var imgProfile: UIImageView!
    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblStandard: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imgProfile.setImageViewBoundsAndBorder()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
