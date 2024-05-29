//
//  UserToyTableViewCell.swift
//  labProject
//
//  Created by prk on 12/14/23.
//

import UIKit

class UserToyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var toyName: UILabel!
    
    @IBOutlet weak var toyDesc: UILabel!
    
    @IBOutlet weak var toyCategory: UILabel!
    
    @IBOutlet weak var toyPrice: UILabel!
    
    @IBOutlet weak var quantityLabel: UILabel!

    @IBOutlet weak var addToCartButton: UIButton!
    
    @IBOutlet weak var qtyStepper: UIStepper!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func addtoCart(_ sender: Any) {
        
    }
}
