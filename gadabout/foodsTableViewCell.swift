//
//  foodsTableViewCell.swift
//  gadabout
//
//  Created by Ahmet on 17.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

protocol foodsTableViewCellDelegate {
    func didAlternativeSelected(sender: foodsTableViewCell, selectedIndex: Int)
    
    func isDetailButtonTapped(sender: foodsTableViewCell)
    
    func appendToDoList(sender: foodsTableViewCell)
    
}

class foodsTableViewCell: UITableViewCell {

    var delegate: foodsTableViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
