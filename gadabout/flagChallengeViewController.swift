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

var glbFlagImgs = [UIImage]() // Global food variables
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
    
    
    @IBOutlet weak var optionALabel: UILabel!
    
    @IBOutlet weak var optionBLabel: UILabel!
    
    @IBOutlet weak var optionCLabel: UILabel!
    
    @IBOutlet weak var optionDLabel: UILabel!
    
    var interstitial: GADInterstitial!
    
    @IBOutlet weak var tryAgainButton: UIButton!
    
    @IBOutlet weak var loadingView: UIView!
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    var randomIndex = 0
    
    var score = 0
    
    var correctAnsInt = 1
    
    @IBOutlet weak var nextButton: UIButton!
    var flagImgs = [UIImage]() // Global food variables
    var flagOption1 = [String]()
    var flagOption2 = [String]()
    var flagOption3 = [String]()
    var flagOption4 = [String]()
    var flagCorrectAnswer = [String]()
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "flagBackSegue", sender: self)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        nextButton.isHidden = true
        
        option1.isEnabled = true
        option2.isEnabled = true
        option3.isEnabled = true
        option4.isEnabled = true
        
        option1.layer.borderColor = UIColor.clear.cgColor
        option1.layer.borderWidth = 0

        option2.layer.borderColor = UIColor.clear.cgColor
        option2.layer.borderWidth = 0

        option3.layer.borderColor = UIColor.clear.cgColor
        option3.layer.borderWidth = 0

        option4.layer.borderColor = UIColor.clear.cgColor
        option4.layer.borderWidth = 0

        prepareNextQuestion()
        
    }
    
    
    @IBAction func option1Tapped(_ sender: Any) {
        
        option1.isEnabled = false
        option2.isEnabled = false
        option3.isEnabled = false
        option4.isEnabled = false
        
        print("Option 1 tapped")
        print("Correct answer: \(correctAnsInt)")
        

        
        if correctAnsInt == 1 {
            option1.pulsate()
            option1.backgroundColor = UIColor(rgb: 0x29D3AE)
            
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            nextButton.alpha = 0
            nextButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.nextButton.alpha = 1
            }, completion : nil)

            //prepareNextQuestion()
            
        }
        else {
            print("Incorrect")
            
            option1.shake()
            
            option1.backgroundColor = UIColor(rgb: 0xE9375D)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                
            }
            if score >= glbFlagScore {
                showPopup(Score: score, oldRecord: glbFlagScore)
            }

            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImgs = glbFlagImgs
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
            
        }

    }
    
    @IBAction func tryAgainTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.pulsate()
        
        score = 0
        scoreLabel.text = "Score: \(self.score)"
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)

        
        tryAgainButton.isHidden = true
        
        option1.isEnabled = true
        option2.isEnabled = true
        option3.isEnabled = true
        option4.isEnabled = true

        prepareNextQuestion()
    }
    
    
    @IBAction func option2Tapped(_ sender: Any) {
        
        option1.isEnabled = false
        option2.isEnabled = false
        option3.isEnabled = false
        option4.isEnabled = false
        
        print("Option 2 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 2 {
            option2.pulsate()
            option2.backgroundColor = UIColor(rgb: 0x29D3AE)
            
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            nextButton.alpha = 0
            nextButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.nextButton.alpha = 1
            }, completion : nil)
            
            //prepareNextQuestion()
        }
        else {
            print("Incorrect")
            
            option2.shake()
            
            option2.backgroundColor = UIColor(rgb: 0xE9375D)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                
            }

            
            if score >= glbFlagScore {
                showPopup(Score: score, oldRecord: glbFlagScore)
            }

            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImgs = glbFlagImgs
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
        }
    }
    
    @IBAction func option3Tapped(_ sender: Any) {
        
        option1.isEnabled = false
        option2.isEnabled = false
        option3.isEnabled = false
        option4.isEnabled = false
        
        print("Option 3 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 3 {
            option3.pulsate()
            option3.backgroundColor = UIColor(rgb: 0x29D3AE)
            
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            nextButton.alpha = 0
            nextButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.nextButton.alpha = 1
            }, completion : nil)
            
            //prepareNextQuestion()
        }
        else {
            print("Incorrect")
            
            option3.shake()
            
            option3.backgroundColor = UIColor(rgb: 0xE9375D)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                
            }

            
            if score >= glbFlagScore {
                showPopup(Score: score, oldRecord: glbFlagScore)
            }

            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImgs = glbFlagImgs
            flagCorrectAnswer = glbFlagCorrectAnswer
            
            tryAgainButton.isHidden = false
        }
    }
    
    @IBAction func option4Tapped(_ sender: Any) {
        
        option1.isEnabled = false
        option2.isEnabled = false
        option3.isEnabled = false
        option4.isEnabled = false
        
        print("Option 4 tapped")
        print("Correct answer: \(correctAnsInt)")
        
        if correctAnsInt == 4 {
            option4.pulsate()
            option4.backgroundColor = UIColor(rgb: 0x29D3AE)
            
            print("Correct")
            score += 1
            scoreLabel.text = "Score: \(score)"
            
            nextButton.alpha = 0
            nextButton.isHidden = false
            UIView.animate(withDuration: 0.3, animations: {
                self.nextButton.alpha = 1
            }, completion : nil)
            
            //prepareNextQuestion()
        }
        else {
            print("Incorrect")
            
            option4.shake()
            
            option4.backgroundColor = UIColor(rgb: 0xE9375D)
            
            if correctAnsInt  == 1 {
                
                option1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option1.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 2 {
                
                option2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option2.layer.borderWidth = 2
                
            }
            else if correctAnsInt  == 3 {
                
                option3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option3.layer.borderWidth = 2
                
            }
            else {
                
                option4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                option4.layer.borderWidth = 2
                
            }
            
            if score >= glbFlagScore {
                showPopup(Score: score, oldRecord: glbFlagScore)
            }
            
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImgs = glbFlagImgs
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
        
        optionALabel.isHidden = true
        optionBLabel.isHidden = true
        optionCLabel.isHidden = true
        optionDLabel.isHidden = true

        option1.layer.cornerRadius = 10
        option2.layer.cornerRadius = 10
        option3.layer.cornerRadius = 10
        option4.layer.cornerRadius = 10
        
        option1.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        option2.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        option3.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);
        option4.titleEdgeInsets = UIEdgeInsetsMake(5, 5, 5, 5);

        tryAgainButton.isHidden = true
        nextButton.isHidden = true
        
        /*tryAgainButton.backgroundColor = .clear
        tryAgainButton.layer.cornerRadius = 5
        tryAgainButton.layer.borderWidth = 1
        tryAgainButton.layer.borderColor = UIColor.black.cgColor*/
        
        tryAgainButton.imageEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -10);
        
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())


        option1.setTitleColor(UIColor.black, for: .normal)
        option1.layer.borderWidth = 0

        option2.setTitleColor(UIColor.black, for: .normal)
        option2.layer.borderWidth = 0

        option3.setTitleColor(UIColor.black, for: .normal)
        option3.layer.borderWidth = 0

        option4.setTitleColor(UIColor.black, for: .normal)
        option4.layer.borderWidth = 0
        
        
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
                    var indx = 0
                    for flag in flags {
                        
                        let flgImg = flag["imageFile"] as! PFFile
                        flgImg.getDataInBackground { [unowned self] (data, error) in
                            indx += 1
                            if let imageData = data {
                                
                                if let imageToDisplay = UIImage(data: imageData) {
                                    
                                    let imageCache = imageToDisplay
                                    
                                    self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                    
                                    if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                        
                                        glbFlagImgs.append(cacheimg)
                                        glbFlagOption1.append(flag["option1"] as! String)
                                        glbFlagOption2.append(flag["option2"] as! String)
                                        glbFlagOption3.append(flag["option3"] as! String)
                                        glbFlagOption4.append(flag["option4"] as! String)
                                        glbFlagCorrectAnswer.append(flag["correctAnswer"] as! String)
                        
                                        self.flagOption1.append(flag["option1"] as! String)
                                        self.flagOption2.append(flag["option2"] as! String)
                                        self.flagOption3.append(flag["option3"] as! String)
                                        self.flagOption4.append(flag["option4"] as! String)
                                        self.flagImgs.append(cacheimg)
                                        self.flagCorrectAnswer.append(flag["correctAnswer"] as! String)
                                        
                                    }
                                }
                            }
                            
                            if indx ==  flags.count {
                                activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()
                                self.prepareNextQuestion()
                                self.loadingView.alpha = 0
                            }
                        }
                    }

                }

            }
        }
        else {
            
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImgs = glbFlagImgs
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
        
        
        option1.backgroundColor = UIColor.clear
        option2.backgroundColor = UIColor.clear
        option3.backgroundColor = UIColor.clear
        option4.backgroundColor = UIColor.clear
        
        option1.layer.borderColor = UIColor.clear.cgColor
        option1.layer.borderWidth = 0
        
        option1.titleLabel?.numberOfLines = 1
        option1.titleLabel?.adjustsFontSizeToFitWidth = true
        option1.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        option2.layer.borderColor = UIColor.clear.cgColor
        option2.layer.borderWidth = 0
        
        option2.titleLabel?.numberOfLines = 1
        option2.titleLabel?.adjustsFontSizeToFitWidth = true
        option2.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        option3.layer.borderColor = UIColor.clear.cgColor
        option3.layer.borderWidth = 0
        
        option3.titleLabel?.numberOfLines = 1
        option3.titleLabel?.adjustsFontSizeToFitWidth = true
        option3.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        option4.layer.borderColor = UIColor.clear.cgColor
        option4.layer.borderWidth = 0
        
        option4.titleLabel?.numberOfLines = 1
        option4.titleLabel?.adjustsFontSizeToFitWidth = true
        option4.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        randomIndex = Int(arc4random_uniform(UInt32(flagOption1.count)))
        print("Random Index: \(randomIndex)")
        
        image.image = flagImgs[randomIndex]
        option1.setTitle(flagOption1[randomIndex], for: [])
        option2.setTitle(flagOption2[randomIndex], for: [])
        option3.setTitle(flagOption3[randomIndex], for: [])
        option4.setTitle(flagOption4[randomIndex], for: [])
        
        if let temp = Int(flagCorrectAnswer[randomIndex]) {
            correctAnsInt = temp
        }
        
        image.isHidden = false
        option1.isHidden = false
        option2.isHidden = false
        option3.isHidden = false
        option4.isHidden = false
        
        optionALabel.isHidden = false
        optionBLabel.isHidden = false
        optionCLabel.isHidden = false
        optionDLabel.isHidden = false
        
        
        flagOption1.remove(at: randomIndex)
        flagOption2.remove(at: randomIndex)
        flagOption3.remove(at: randomIndex)
        flagOption4.remove(at: randomIndex)
        flagImgs.remove(at: randomIndex)
        flagCorrectAnswer.remove(at: randomIndex)
        
        if flagOption1.count == 0 {
            
            flagOption1 = glbFlagOption1
            flagOption2 = glbFlagOption2
            flagOption3 = glbFlagOption3
            flagOption4 = glbFlagOption4
            flagImgs = glbFlagImgs
            flagCorrectAnswer = glbFlagCorrectAnswer
            
        }
        
    }
    
    func showPopup(Score: Int, oldRecord: Int) {
        tryAgainButton.isEnabled = false
        
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
        
        tryAgainButton.isEnabled = true
        
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
                }
            }
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
