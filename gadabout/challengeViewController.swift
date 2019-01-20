//
//  challengeViewController.swift
//  gadabout
//
//  Created by Ahmet on 20.01.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit
import GoogleMobileAds

class challengeViewController: UIViewController {

    @IBOutlet weak var bannerView: GADBannerView!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())


        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "challengeBackSegue", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "challengeBackSegue" {
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
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
