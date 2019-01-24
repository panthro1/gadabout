//
//  scorePopUpViewController.swift
//  gadabout
//
//  Created by Ahmet on 29.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

protocol scorePopupDelegate {
    func SendCloseInfo()
}




class scorePopUpViewController: UIViewController {
    
    public var scoreWin = Int()
    public var totalScore = Int()
    public var isFlagOutput = Bool()
    public var isScoreSummary = Bool()

    
    @IBOutlet weak var scoreWinLabel: UILabel!
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    @IBOutlet weak var scoreHeader: UILabel!
    
    @IBOutlet weak var scoreImage: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate: scorePopupDelegate?

    @IBAction func closeTapped(_ sender: Any) {
        
        closeButton.pulsate()
        
        delegate?.SendCloseInfo()
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.black.cgColor
        
        
        if isScoreSummary {
            
            scoreHeader.text = "Summary"
            applyBoldText(text1: "Total Score", text2: "Flag Record")
            
        }
        else {
            if isFlagOutput {
                if scoreWin == 0 {
                    scoreHeader.text = "Unfortunately!!"
                    applyBoldText(text1: "Score", text2: "Record")
                }
                else {
                    if scoreWin > totalScore {
                        scoreHeader.text = "New Record!!"
                        applyBoldText(text1: "Score", text2: "Old Record")
                    }
                    else {
                        scoreHeader.text = "Congratulations"
                        applyBoldText(text1: "Score", text2: "Record")
                    }
                }
            }
            else {
                if scoreWin == 0 {
                    scoreHeader.text = "Unfortunately!!"
                    scoreWinLabel.text = "You have not won any points"
                }
                else {
                    scoreHeader.text = "Congratulations"
                    scoreWinLabel.text = "You have won \(scoreWin) points"
                }
                totalScoreLabel.text = "Total Score : \(totalScore) points"
            }
        }
        
        
        self.showAnimate()

        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        self.view.removeFromSuperview()
    }
    
    func applyBoldText (text1: String, text2: String) {
        let boldText  = text1 + ": "
        let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString = NSMutableAttributedString(string:boldText, attributes:attrs)
        
        let normalText = "\(scoreWin) points"
        let normalString = NSMutableAttributedString(string:normalText)
        
        attributedString.append(normalString)
        scoreWinLabel.attributedText = attributedString
        
        let boldText2  = text2 + ": "
        let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 20)]
        let attributedString2 = NSMutableAttributedString(string:boldText2, attributes:attrs2)
        
        let normalText2 = "\(totalScore) points"
        let normalString2 = NSMutableAttributedString(string:normalText2)
        
        attributedString2.append(normalString2)
        totalScoreLabel.attributedText = attributedString2
        //totalScoreLabel.text = "Flag Challenge Record: \(totalScore)"
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
