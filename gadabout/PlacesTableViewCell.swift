//
//  PlacesTableViewCell.swift
//  gadabout
//
//  Created by Ahmet on 4.08.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

protocol placesTableViewCellDelegate {
    func didAlternativeSelected(sender: PlacesTableViewCell, selectedIndex: Int)
    
    func isDetailButtonTapped(sender: PlacesTableViewCell, showDetail: Bool)
}

class PlacesTableViewCell: UITableViewCell {
    var option1Marked = false
    var option2Marked = false
    var option3Marked = false
    var option4Marked = false
    
    var showDetail = false
    
    var checkedOption = -1
    
    var delegate: placesTableViewCellDelegate?
    

    @IBOutlet weak var placeImage: UIImageView!
    
    @IBOutlet weak var option1: UILabel!
    
    @IBOutlet weak var option2: UILabel!

    @IBOutlet weak var option3: UILabel!
    
    @IBOutlet weak var option4: UILabel!
    
    @IBOutlet weak var markOption1: UIButton!
    
    @IBOutlet weak var markOption2: UIButton!
    
    @IBOutlet weak var markOption3: UIButton!
    
    @IBOutlet weak var markOption4: UIButton!
    
    @IBOutlet weak var detailsButton: UIButton!
    
    
    @IBAction func markOption1Tapped(_ sender: Any) {
        
        if option1Marked {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            markOption1.setImage(UIImage(named: "check.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = true
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 1
        }
        print("Option 1 marked: \(option1Marked)")
        delegate?.didAlternativeSelected( sender: self,selectedIndex: checkedOption)
    }
    
    
    @IBAction func markOption2Tapped(_ sender: Any) {

        if option2Marked {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "check.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = false
            option2Marked = true
            option3Marked = false
            option4Marked = false
            checkedOption = 2
        }
        delegate?.didAlternativeSelected( sender: self,selectedIndex: checkedOption)

    }
    
    
    
    @IBAction func markOption3Tapped(_ sender: Any) {
        
        if option3Marked {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "check.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = false
            option2Marked = false
            option3Marked = true
            option4Marked = false
            checkedOption = 3
        }
        delegate?.didAlternativeSelected( sender: self,selectedIndex: checkedOption)
    }
    
    
    @IBAction func markOption4Tapped(_ sender: Any) {
        
        if option4Marked {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            markOption4.setImage(UIImage(named: "check.png"), for: [])
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = true
            checkedOption = 4
        }
        //print("\(checkedOption)")
        delegate?.didAlternativeSelected( sender: self,selectedIndex: checkedOption)

        
    }
    
    @IBAction func detailButtonTapped(_ sender: Any) {
        
        if showDetail == false {
            showDetail = true
        }
        else {
            showDetail = false
        }
        delegate?.isDetailButtonTapped(sender: self, showDetail: showDetail)
        print("Cell: \(showDetail)")
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
   
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
