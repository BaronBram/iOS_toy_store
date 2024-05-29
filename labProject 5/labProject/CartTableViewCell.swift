//
//  CartTableViewCell.swift
//  labProject
//
//  Created by prk on 12/15/23.
//

import UIKit

class CartTableViewCell: UITableViewCell {
    @IBOutlet weak var quantity: UILabel!
    
    @IBOutlet weak var price: UILabel!

    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var totalprice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
