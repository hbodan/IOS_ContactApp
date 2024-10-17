//
//  ContactTableViewCell.swift
//  ContactApp
//
//  Created by User-UAM on 10/13/24.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    
    
    @IBOutlet weak var contactImage: UIImageView!
    
    @IBOutlet weak var completeName: UILabel!
    
    @IBOutlet weak var phoneNumber: UILabel!
    
    @IBOutlet weak var email: UILabel!
    
    @IBOutlet weak var dateLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
