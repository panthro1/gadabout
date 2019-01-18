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
    
    func isDetailButtonTapped(sender: PlacesTableViewCell)
    
    func appendToDoList(sender: PlacesTableViewCell)

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
    
    @IBOutlet weak var markOption1: UIButton!
    
    @IBOutlet weak var markOption2: UIButton!
    
    @IBOutlet weak var markOption3: UIButton!
    
    @IBOutlet weak var markOption4: UIButton!
    
    @IBOutlet weak var detailsButton: UIButton!
    
    @IBOutlet weak var detailText: UILabel!
    
    @IBOutlet weak var toDoListButton: UIButton!
    
    @IBOutlet weak var optionALabel: UILabel!
    
    @IBOutlet weak var optionBLabel: UILabel!
    
    @IBOutlet weak var optionCLabel: UILabel!
    
    @IBOutlet weak var optionDLabel: UILabel!
    
    @IBAction func markOption1Tapped(_ sender: Any) {
         markOption1.pulsate()
        
        if option1Marked {
            
            markOption1.backgroundColor = UIColor.clear
            markOption2.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear
            
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            
            markOption2.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear
            
            markOption1.layer.cornerRadius = 10
            markOption1.backgroundColor = UIColor(rgb: 0x7E9BE6)

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
        
        markOption2.pulsate()

        if option2Marked {
            
            markOption1.backgroundColor = UIColor.clear
            markOption2.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear

            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            
            markOption1.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear
            
            markOption2.layer.cornerRadius = 10
            markOption2.backgroundColor = UIColor(rgb: 0x7E9BE6)
            
            option1Marked = false
            option2Marked = true
            option3Marked = false
            option4Marked = false
            checkedOption = 2
        }
        delegate?.didAlternativeSelected( sender: self,selectedIndex: checkedOption)

    }
    
    
    
    @IBAction func markOption3Tapped(_ sender: Any) {
         markOption3.pulsate()
        
        if option3Marked {
            
            markOption1.backgroundColor = UIColor.clear
            markOption2.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear

            
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            
            markOption1.backgroundColor = UIColor.clear
            markOption2.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear
            
            markOption3.layer.cornerRadius = 10
            markOption3.backgroundColor = UIColor(rgb: 0x7E9BE6)
            
            option1Marked = false
            option2Marked = false
            option3Marked = true
            option4Marked = false
            checkedOption = 3
        }
        delegate?.didAlternativeSelected( sender: self,selectedIndex: checkedOption)
    }
    
    
    @IBAction func markOption4Tapped(_ sender: Any) {
         markOption4.pulsate()
        
        if option4Marked {
            
            markOption1.backgroundColor = UIColor.clear
            markOption2.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear
            markOption4.backgroundColor = UIColor.clear

            
            option1Marked = false
            option2Marked = false
            option3Marked = false
            option4Marked = false
            checkedOption = 0
            
        }
        else {
            
            markOption1.backgroundColor = UIColor.clear
            markOption2.backgroundColor = UIColor.clear
            markOption3.backgroundColor = UIColor.clear

            markOption4.layer.cornerRadius = 10
            markOption4.backgroundColor = UIColor(rgb: 0x7E9BE6)

            
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

        delegate?.isDetailButtonTapped(sender: self)
    }
    
    @IBAction func addToDoListTapped(_ sender: Any) {
        
        let button = sender as? UIButton
        button?.pulsate()
        
        delegate?.appendToDoList(sender: self)
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
