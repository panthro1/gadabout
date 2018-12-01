//
//  ToDoImageDisplayViewController.swift
//  gadabout
//
//  Created by Ahmet on 22.11.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import GoogleMobileAds

class ToDoImageDisplayViewController: UIViewController {

    @IBOutlet weak var toDoImage: UIImageView!
    
    @IBOutlet weak var toDoHeader: UILabel!
    
    @IBOutlet weak var closeButton: UIButton!
    
    @IBOutlet weak var toDoDescription: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    var header = ""
    var desc = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        

        // Do any additional setup after loading the view.
        
        closeButton.layer.cornerRadius = 5
        closeButton.layer.borderWidth = 1
        closeButton.layer.borderColor = UIColor.black.cgColor
        
        toDoHeader.text = header
        toDoDescription.text = desc
        toDoDescription.sizeToFit()
        toDoDescription.numberOfLines = 0
        
        
        self.view.backgroundColor = UIColor.white
        
        self.showAnimate()
    }
    

    @IBAction func closeTapped(_ sender: Any) {
        self.removeAnimate()
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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
