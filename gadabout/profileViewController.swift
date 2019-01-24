//
//  profileViewController.swift
//  gadabout
//
//  Created by Ahmet on 20.01.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit
import GoogleMobileAds

class profileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, scorePopupDelegate  {

    @IBOutlet weak var bannerView: GADBannerView!
    
    var rowHeight = 100
    
    @IBOutlet weak var profileTableView: UITableView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var interstitial: GADInterstitial!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)
        
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.allowsSelection = true
        
        let screenSize = UIScreen.main.bounds
        
        let topSafeArea = UIApplication.shared.windows[0].safeAreaInsets.top
        print("Top safe area: \(topSafeArea)")
        
        let bottomSafeArea = UIApplication.shared.windows[0].safeAreaInsets.bottom
        print("Bottom safe area: \(bottomSafeArea)")
        
        
        let navBarHeight = self.navigationBar.frame.size.height//UIApplication.shared.statusBarFrame.height
        let upperOffset = /*Int(screenSize.height*0.01) + */Int(navBarHeight) + Int(topSafeArea)
        rowHeight = Int((Int(screenSize.height*0.58) - upperOffset - Int(bannerView.frame.height) - Int(bottomSafeArea) - Int(screenSize.height*0.06)) / 3)
        
        self.profileTableView.rowHeight = CGFloat(rowHeight)



        // Do any additional setup after loading the view.
    }
    
    @IBAction func backTapped(_ sender: Any) {

        performSegue(withIdentifier: "profileBackSegue", sender: self)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "profileBackSegue" {
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            
            
            src.view.window?.layer.add(transition, forKey: nil)
        }
        else if segue.identifier == "toDoListSegue" {

            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)

        }
        else if segue.identifier == "mailLoginSegue" {
            
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)
            
        }
        else if segue.identifier == "scoreSegue" {
            
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)
        }
        else if segue.identifier == "attributionSegue" {

            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)

        }
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (UIScreen.main.bounds.height*0.02)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mainPageCell")
        
        cell.layer.cornerRadius=10 //set corner radius here
        cell.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 100).cgColor //logout.tintColor?.cgColor//UIColor.lightGray.cgColor  // set cell border color here
        cell.layer.borderWidth = 2 // set border width here
        cell.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds
        
        if screenSize.width < 350 {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 28)
        }
        else if screenSize.width < 400 {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 30)
        }
        else {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 32)
        }
        
        let rowImageSize = Double(rowHeight)*0.8
        
        if indexPath.section == 0 {
            cell.accessoryView = UIImageView(image: UIImage(named: "list.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 1 {
            cell.accessoryView = UIImageView(image: UIImage(named: "score-icon.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 2 {
            cell.accessoryView = UIImageView(image: UIImage(named: "outlook.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
            
        }
        
        
        if indexPath.section == 0 {
            cell.textLabel?.text = " To Do List"
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = " Score"
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = " Mail Login"
        }
        
        
        return cell
        
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("To Do List selected")
            performSegue(withIdentifier: "toDoListSegue", sender: self)
        }
        else if indexPath.section == 1 {
            print("Score selected")
            /*let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
            popOverVC.scoreWin = glbUserScore
            popOverVC.totalScore = glbFlagScore
            popOverVC.isFlagOutput = false
            popOverVC.isScoreSummary = true
            popOverVC.delegate = self
            
            self.addChildViewController(popOverVC)
            let popUpSize = self.view.bounds.width*0.9
            
            let centerY = self.view.bounds.height/2 - popUpSize/2
            let centerX = self.view.bounds.width/2 - popUpSize/2
            
            popOverVC.view.frame = CGRect(x: centerX, y: centerY, width: popUpSize, height: popUpSize)
            popOverVC.view.backgroundColor = UIColor(rgb: 0xDDD6F2)
            popOverVC.view.layer.cornerRadius = 20
            
            //popOverVC.view.frame = self.view.bounds//self.view.frame
            
            self.view.addSubview(popOverVC.view)
            popOverVC.didMove(toParentViewController: self)*/
            performSegue(withIdentifier: "scoreSegue", sender: self)
            
        }
        else if indexPath.section == 2 {
            print("Flag selected")
            performSegue(withIdentifier: "mailLoginSegue", sender: self)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func SendCloseInfo() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }

    
    @IBAction func attributionsTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "attributionSegue", sender: self)
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
