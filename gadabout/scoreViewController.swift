//
//  scoreViewController.swift
//  gadabout
//
//  Created by Ahmet on 22.01.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit
import GoogleMobileAds

class scoreViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    @IBOutlet weak var flagRecordLabel: UILabel!
    
    
    @IBOutlet weak var puzzleScoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        applyBoldText(text1: "Quiz", text2: "Flag", text3: "Puzzle")

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "scoreBackSegue", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDoBackSegue" {
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
    
    func applyBoldText (text1: String, text2: String, text3: String) {
        let boldText  = text1 + ": "
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "\(glbCorrectAnswer)  / \(glbTotalQuestion)"
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        totalScoreLabel.attributedText = attributedString
        
        let boldText2  = text2 + ": "
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25)]
        let attributedString2 = NSMutableAttributedString(string:boldText2, attributes:attrs2)
        
        let normalText2 = "\(glbFlagScore) points"
        let normalString2 = NSMutableAttributedString(string:normalText2)
        
        attributedString2.append(normalString2)
        flagRecordLabel.attributedText = attributedString2
        //totalScoreLabel.text = "Flag Challenge Record: \(totalScore)"
        let boldText3  = text3 + ": "
        let attrs3 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 25)]
        let attributedString3 = NSMutableAttributedString(string:boldText3, attributes:attrs3)
        
        let normalText3 = "\(glbPuzzleScore) points"
        let normalString3 = NSMutableAttributedString(string:normalText3)
        
        attributedString3.append(normalString3)
        puzzleScoreLabel.attributedText = attributedString3
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
