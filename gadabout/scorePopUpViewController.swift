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

    
    @IBOutlet weak var scoreWinLabel: UILabel!
    
    @IBOutlet weak var totalScoreLabel: UILabel!
    
    @IBOutlet weak var scoreHeader: UILabel!
    
    @IBOutlet weak var scoreImage: UIImageView!
    
    @IBOutlet weak var closeButton: UIButton!
    
    var delegate: scorePopupDelegate?

    @IBAction func closeTapped(_ sender: Any) {
        
        delegate?.SendCloseInfo()
        self.removeAnimate()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.black.cgColor
        
        if scoreWin == 0 {
            scoreHeader.text = "Unfortunately!!"
            scoreWinLabel.text = "You have not won any points"
            
            //scoreImage.image = UIImage(named: "disappointed.png")
        }
        else {
            scoreHeader.text = "Congratulations"
            scoreWinLabel.text = "You have won \(scoreWin) points"
        }
        totalScoreLabel.text = "Your total score : \(totalScore) points"
        
        self.view.backgroundColor = UIColor.white
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
