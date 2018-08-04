//
//  PlacesTableViewCell.swift
//  gadabout
//
//  Created by Ahmet on 4.08.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

class PlacesTableViewCell: UITableViewCell {

    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var option1: UILabel!
    
    @IBOutlet weak var option2: UILabel!

    @IBOutlet weak var option3: UILabel!
    
    @IBOutlet weak var option4: UILabel!
    
    @IBOutlet weak var markOption1: UIButton!
    
    @IBOutlet weak var markOption2: UIButton!
    
    @IBOutlet weak var markOption3: UIButton!
    
    @IBOutlet weak var markOption4: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
