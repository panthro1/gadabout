//
//  flagChallengeViewController.swift
//  gadabout
//
//  Created by Ahmet on 23.12.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

var glbFlagImageFile = [PFFile]() // Global food variables
var glbFlagOption1 = [String]()
var glbFlagOption2 = [String]()
var glbFlagOption3 = [String]()
var glbFlagOption4 = [String]()
var glbFlagCorrectAnswer = [String]()

class flagChallengeViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var option1: UIButton!
    
    @IBOutlet weak var option2: UIButton!
    
    @IBOutlet weak var option3: UIButton!
    
    @IBOutlet weak var option4: UIButton!
    
    var flagImageFile = [PFFile]() // Global food variables
    var flagOption1 = [String]()
    var flagOption2 = [String]()
    var flagOption3 = [String]()
    var flagOption4 = [String]()
    var flagCorrectAnswer = [String]()
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "flagBackSegue", sender: self)
    }
    
    
    @IBAction func option1Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "check.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
    }
    
    @IBAction func option2Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "check.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
    }
    
    @IBAction func option3Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "check.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
    }
    
    @IBAction func option4Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "check.png"), for: [])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let spacing: CGFloat = 5 // the amount of spacing to appear between image and title

        option1.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        option1.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        option1.imageView?.contentMode = .scaleAspectFit
        option1.setTitleColor(UIColor.black, for: .normal)
        option1.layer.borderWidth = 0

        option2.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        option2.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        option2.imageView?.contentMode = .scaleAspectFit
        option2.setTitleColor(UIColor.black, for: .normal)
        option2.layer.borderWidth = 0

        option3.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        option3.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        option3.imageView?.contentMode = .scaleAspectFit
        option3.setTitleColor(UIColor.black, for: .normal)
        option3.layer.borderWidth = 0

        option4.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        option4.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        option4.imageView?.contentMode = .scaleAspectFit
        option4.setTitleColor(UIColor.black, for: .normal)
        option4.layer.borderWidth = 0
        
        prepareNextQuestion()
        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "flagBackSegue" {
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            
            
            src.view.window?.layer.add(transition, forKey: nil)
        }
        
    }
    
    func prepareNextQuestion() {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
        
        /*option1.setTitle("Country1", for: [])
        option2.setTitle("Country2", for: [])
        option3.setTitle("Country3", for: [])
        option4.setTitle("Country4", for: [])*/
        
        let randomIndex = 0
        option1.setTitle(flagOption1[randomIndex], for: [])
        option2.setTitle(flagOption2[randomIndex], for: [])
        option3.setTitle(flagOption3[randomIndex], for: [])
        option4.setTitle(flagOption4[randomIndex], for: [])
        
        flagImageFile[randomIndex].getDataInBackground { [unowned self] (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    self.image.image = imageToDisplay
                    
                }
            }
            
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        
        if glbFlagOption1.count == 0 {
            let flagsQuery = PFQuery(className: "Flags")
            flagsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                if let flags = objects {
                    
                    for flag in flags {
                        
                        glbFlagOption1.append(flag["option1"] as! String)
                        glbFlagOption2.append(flag["option2"] as! String)
                        glbFlagOption3.append(flag["option3"] as! String)
                        glbFlagOption4.append(flag["option4"] as! String)
                        glbFlagImageFile.append(flag["imageFile"] as! PFFile)
                        glbFlagCorrectAnswer.append(flag["correctAnswer"] as! String)
                        
                        self.flagOption1.append(flag["option1"] as! String)
                        self.flagOption2.append(flag["option2"] as! String)
                        self.flagOption3.append(flag["option3"] as! String)
                        self.flagOption4.append(flag["option4"] as! String)
                        self.flagImageFile.append(flag["imageFile"] as! PFFile)
                        self.flagCorrectAnswer.append(flag["correctAnswer"] as! String)
                    }
                }
                //activityIndicator.stopAnimating()
                //UIApplication.shared.endIgnoringInteractionEvents()
                
                
            }
        }
        else {
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImageFile = glbFlagImageFile
            flagCorrectAnswer = glbFlagCorrectAnswer
        }

    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
