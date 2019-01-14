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

class flagChallengeViewController: UIViewController, scorePopupDelegate{
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var option1: UIButton!
    
    @IBOutlet weak var option2: UIButton!
    
    @IBOutlet weak var option3: UIButton!
    
    @IBOutlet weak var option4: UIButton!
    
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    
    var randomIndex = 0
    
    var score = 0
    
    var correctAnsInt = 1
    
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
        
        print("Option 1 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 1 {
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            prepareNextQuestion()
            
        }
        else {
            print("Incorrect")
            
            option1.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
            let origImage = UIImage(named: "check.png");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            option1.setImage(tintedImage, for: .normal)
            option1.tintColor = UIColor(rgb: 0xC20F16)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                option1.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                option2.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                option3.layer.cornerRadius = 10
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                option4.layer.cornerRadius = 10
                
            }
            
            showPopup(Score: score, oldRecord: glbFlagScore)
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImageFile = glbFlagImageFile
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
            
        }

    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.pulsate()
        
        tryAgainButton.isHidden = true
        
        prepareNextQuestion()
    }
    
    
    @IBAction func option2Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "check.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
        
        print("Option 2 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 2 {
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            prepareNextQuestion()
        }
        else {
            print("Incorrect")
            
            option2.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
            let origImage = UIImage(named: "check.png");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            option2.setImage(tintedImage, for: .normal)
            option2.tintColor = UIColor(rgb: 0xC20F16)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                option1.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                option2.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                option3.layer.cornerRadius = 10
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                option4.layer.cornerRadius = 10
                
            }

            
            showPopup(Score: score, oldRecord: glbFlagScore)
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImageFile = glbFlagImageFile
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
        }
    }
    
    @IBAction func option3Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "check.png"), for: [])
        option4.setImage(UIImage(named: "uncheck.png"), for: [])
        
        print("Option 3 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 3 {
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            prepareNextQuestion()
        }
        else {
            print("Incorrect")
            
            option3.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
            let origImage = UIImage(named: "check.png");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            option3.setImage(tintedImage, for: .normal)
            option3.tintColor = UIColor(rgb: 0xC20F16)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                option1.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                option2.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                option3.layer.cornerRadius = 10
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                option4.layer.cornerRadius = 10
                
            }

            
            showPopup(Score: score, oldRecord: glbFlagScore)
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImageFile = glbFlagImageFile
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
        }
    }
    
    @IBAction func option4Tapped(_ sender: Any) {
        option1.setImage(UIImage(named: "uncheck.png"), for: [])
        option2.setImage(UIImage(named: "uncheck.png"), for: [])
        option3.setImage(UIImage(named: "uncheck.png"), for: [])
        option4.setImage(UIImage(named: "check.png"), for: [])
        
        print("Option 4 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 4 {
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            prepareNextQuestion()
        }
        else {
            print("Incorrect")
            
            option4.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
            let origImage = UIImage(named: "check.png");
            let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            option4.setImage(tintedImage, for: .normal)
            option4.tintColor = UIColor(rgb: 0xC20F16)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                option1.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                option2.layer.cornerRadius = 10
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                option3.layer.cornerRadius = 10
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                option4.layer.cornerRadius = 10
                
            }

            
            showPopup(Score: score, oldRecord: glbFlagScore)
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImageFile = glbFlagImageFile
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        image.isHidden = true
        option1.isHidden = true
        option2.isHidden = true
        option3.isHidden = true
        option4.isHidden = true
        tryAgainButton.isHidden = true
        
        /*tryAgainButton.layer.cornerRadius = 10
        tryAgainButton.layer.borderWidth = 1
        tryAgainButton.layer.borderColor = UIColor.black.cgColor*/
        
        tryAgainButton.backgroundColor = .clear
        tryAgainButton.layer.cornerRadius = 5
        tryAgainButton.layer.borderWidth = 1
        tryAgainButton.layer.borderColor = UIColor.black.cgColor
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)

        
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
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
            
            activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()
            
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
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.prepareNextQuestion()
                    self.loadingView.alpha = 0
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
            loadingView.alpha = 0
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

        option1.setTitleColor(UIColor.black, for: [])
        option2.setTitleColor(UIColor.black, for: [])
        option3.setTitleColor(UIColor.black, for: [])
        option4.setTitleColor(UIColor.black, for: [])
        

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
        
        
        flagImageFile[randomIndex].getDataInBackground { [unowned self] (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    self.image.image = imageToDisplay
                    
                    self.option1.setTitle(self.flagOption1[self.randomIndex], for: [])
                    self.option2.setTitle(self.flagOption2[self.randomIndex], for: [])
                    self.option3.setTitle(self.flagOption3[self.randomIndex], for: [])
                    self.option4.setTitle(self.flagOption4[self.randomIndex], for: [])
                    
                    if let temp = Int(self.flagCorrectAnswer[self.randomIndex]) {
                        self.correctAnsInt = temp
                    }
                    
                    self.flagOption1.remove(at: self.randomIndex)
                    self.flagOption2.remove(at: self.randomIndex)
                    self.flagOption3.remove(at: self.randomIndex)
                    self.flagOption4.remove(at: self.randomIndex)
                    self.flagImageFile.remove(at: self.randomIndex)
                    self.flagCorrectAnswer.remove(at: self.randomIndex)
                    
                    if self.flagOption1.count == 0 {
                        
                        self.flagOption1 = glbFlagOption1
                        self.flagOption2 = glbFlagOption2
                        self.flagOption3 = glbFlagOption3
                        self.flagOption4 = glbFlagOption4
                        self.flagImageFile = glbFlagImageFile
                        self.flagCorrectAnswer = glbFlagCorrectAnswer
                        
                    }

                }
            }
            
        }
        
    }
    
    func showPopup(Score: Int, oldRecord: Int) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
        popOverVC.scoreWin = Score
        popOverVC.totalScore = oldRecord
        popOverVC.isFlagOutput = true
        popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        let popUpSize = self.view.bounds.width*0.9
        
        let centerY = self.view.bounds.height/2 - popUpSize/2
        let centerX = self.view.bounds.width/2 - popUpSize/2
        
        popOverVC.view.frame = CGRect(x: centerX, y: centerY, width: popUpSize, height: popUpSize)//self.view.bounds
        popOverVC.view.backgroundColor = UIColor(rgb: 0xDDD6F2)
        popOverVC.view.layer.cornerRadius = 20
        
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
    }
    
    func SendCloseInfo() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        
        if score > glbFlagScore {
            let userScoreQuery = PFQuery(className: "UserScore")
            userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            userScoreQuery.findObjectsInBackground {[unowned self] (objects, error) in
                if let score = objects?.first {
                    
                    score["flagScore"] = String(self.score)
                    score.saveInBackground()
                    glbFlagScore = self.score
                    self.score = 0
                    self.scoreLabel.text = "Score: \(self.score)"
                }
            }
        }
        else {
            score = 0
            scoreLabel.text = "Score: \(self.score)"
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
