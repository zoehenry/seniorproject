//
//  PersonEventTableViewCell.swift
//  FamilyArchives
//
//  Created by Zoe Henry on 4/15/19.
//  Copyright © 2019 Zoe Henry. All rights reserved.
//

import UIKit

class PersonEventTableViewCell: UITableViewCell {
    
    //MARK: Properties
    @IBOutlet weak var personEventNameLabel: UILabel!
    @IBOutlet weak var photoImageView: UIImageView!
    @IBOutlet weak var personEventDescriptionTextField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
