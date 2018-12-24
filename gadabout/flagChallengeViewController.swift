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

class flagChallengeViewController: UIViewController{
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var option1: UIButton!
    
    @IBOutlet weak var option2: UIButton!
    
    @IBOutlet weak var option3: UIButton!
    
    @IBOutlet weak var option4: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var randomIndex = 0
    
    var score = 0
    
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
        
        if let correctAnsInt = Int(flagCorrectAnswer[randomIndex]) {
            if correctAnsInt == 1 {
                print("Correct")
                score += 1
                scoreLabel.text = "Score: \(score)"
                prepareNextQuestion()
                
            }
            else {
                print("Incorrect")
                showPopup(Score: score, totalScore: score)
                flagOption1 = glbFlagOption1
                flagOption2 = glbFlagOption2
                flagOption3 = glbFlagOption3
                flagOption4 = glbFlagOption4
                flagImageFile = glbFlagImageFile
                flagCorrectAnswer = glbFlagCorrectAnswer
                prepareNextQuestion()
            }
        }

    }
    
    @IBAction func option2Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "check.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
        
        if let correctAnsInt = Int(flagCorrectAnswer[randomIndex]) {
            if correctAnsInt == 2 {
                print("Correct")
                score += 1
                scoreLabel.text = "Score: \(score)"
                prepareNextQuestion()
            }
            else {
                print("Incorrect")
                showPopup(Score: score, totalScore: score)
                flagOption1 = glbFlagOption1
                flagOption2 = glbFlagOption2
                flagOption3 = glbFlagOption3
                flagOption4 = glbFlagOption4
                flagImageFile = glbFlagImageFile
                flagCorrectAnswer = glbFlagCorrectAnswer
                prepareNextQuestion()
            }
        }
    }
    
    @IBAction func option3Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "check.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
        
        if let correctAnsInt = Int(flagCorrectAnswer[randomIndex]) {
            if correctAnsInt == 3 {
                print("Correct")
                score += 1
                scoreLabel.text = "Score: \(score)"
                prepareNextQuestion()
            }
            else {
                print("Incorrect")
                showPopup(Score: score, totalScore: score)
                flagOption1 = glbFlagOption1
                flagOption2 = glbFlagOption2
                flagOption3 = glbFlagOption3
                flagOption4 = glbFlagOption4
                flagImageFile = glbFlagImageFile
                flagCorrectAnswer = glbFlagCorrectAnswer
                prepareNextQuestion()
            }
        }
    }
    
    @IBAction func option4Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "check.png"), for: [])
        
        if let correctAnsInt = Int(flagCorrectAnswer[randomIndex]) {
            if correctAnsInt == 4 {
                print("Correct")
                score += 1
                scoreLabel.text = "Score: \(score)"
                prepareNextQuestion()
            }
            else {
                print("Incorrect")
                showPopup(Score: score, totalScore: score)
                flagOption1 = glbFlagOption1
                flagOption2 = glbFlagOption2
                flagOption3 = glbFlagOption3
                flagOption4 = glbFlagOption4
                flagImageFile = glbFlagImageFile
                flagCorrectAnswer = glbFlagCorrectAnswer
                prepareNextQuestion()
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.isHidden = true
        option1.isHidden = true
        option2.isHidden = true
        option3.isHidden = true
        option4.isHidden = true

        
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
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
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
                    self.prepareNextQuestion()
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
            prepareNextQuestion()
        }
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
        
        image.isHidden = false
        option1.isHidden = false
        option2.isHidden = false
        option3.isHidden = false
        option4.isHidden = false

        
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
        
        /*option1.setTitle("Country1", for: [])
        option2.setTitle("Country2", for: [])
        option3.setTitle("Country3", for: [])
        option4.setTitle("Country4", for: [])*/
        
        randomIndex = Int(arc4random_uniform(UInt32(flagOption1.count)))
        print("Random Index: \(randomIndex)")
        
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
        
        flagOption1.remove(at: randomIndex)
        flagOption2.remove(at: randomIndex)
        flagOption3.remove(at: randomIndex)
        flagOption4.remove(at: randomIndex)
        flagImageFile.remove(at: randomIndex)
    }
    
    func showPopup(Score: Int, totalScore: Int) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
        popOverVC.scoreWin = Score
        popOverVC.totalScore = totalScore
        //popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.bounds//self.view.frame
        //complete.isEnabled = false
        //back.isEnabled = false
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
        
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
