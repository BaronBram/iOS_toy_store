//
//  ToyTableViewCell.swift
//  labProject
//
//  Created by Baron Bram on 15/11/23.
//

import UIKit

class ToyTableViewCell: UITableViewCell {

    
    @IBOutlet weak var toyName: UILabel!
    
    
    @IBOutlet weak var toyDesc: UILabel!
    
    
    @IBOutlet weak var toyCategory: UILabel!
    
    
    @IBOutlet weak var toyPrice: UILabel!
    @IBOutlet weak var updateButton: UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
}
