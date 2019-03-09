//
//  luckyInfoPopupViewController.swift
//  gadabout
//
//  Created by Ahmet on 8.03.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit
protocol LuckyInfoPopupDelegate {
    func LuckyInfoClosed()
}


class luckyInfoPopupViewController: UIViewController {
    
    var delegate: LuckyInfoPopupDelegate?

    @IBOutlet weak var okButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        okButton.layer.cornerRadius = 5
        okButton.layer.borderWidth = 1
        okButton.layer.borderColor = UIColor.black.cgColor


        // Do any additional setup after loading the view.
    }
    

    @IBAction func OkTapped(_ sender: Any) {
        
        okButton.pulsate()
        
        delegate?.LuckyInfoClosed()
        removeAnimate()
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
