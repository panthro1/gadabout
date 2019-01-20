//
//  challengeViewController.swift
//  gadabout
//
//  Created by Ahmet on 20.01.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit
import GoogleMobileAds

class challengeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var challengeTableView: UITableView!
    
    var rowHeight = 100
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        self.challengeTableView.delegate = self
        self.challengeTableView.dataSource = self
        self.challengeTableView.allowsSelection = true
        
        let screenSize = UIScreen.main.bounds
        
        let topSafeArea = UIApplication.shared.windows[0].safeAreaInsets.top
        print("Top safe area: \(topSafeArea)")
        
        let bottomSafeArea = UIApplication.shared.windows[0].safeAreaInsets.bottom
        print("Bottom safe area: \(bottomSafeArea)")
        
        
        let navBarHeight = self.navigationBar.frame.size.height//UIApplication.shared.statusBarFrame.height
        let upperOffset = /*Int(screenSize.height*0.01) + */Int(navBarHeight) + Int(topSafeArea)
        rowHeight = Int((Int(screenSize.height*0.58) - upperOffset - Int(bannerView.frame.height) - Int(bottomSafeArea) - Int(screenSize.height*0.06)) / 3)
        
        self.challengeTableView.rowHeight = CGFloat(rowHeight)



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
        else if segue.identifier == "placesSegue" {
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)
        }
        else if segue.identifier == "foodsSegue" {
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            
            src.view.window?.layer.add(transition, forKey: nil)
        }
        else if segue.identifier == "flagSegue" {
            
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
            cell.accessoryView = UIImageView(image: UIImage(named: "hot-air-balloon.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 1 {
            cell.accessoryView = UIImageView(image: UIImage(named: "breakfast.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 2 {
            cell.accessoryView = UIImageView(image: UIImage(named: "Flag_icon.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
            
        }

        
        if indexPath.section == 0 {
            cell.textLabel?.text = " Places"
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = " Foods"
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = " Flags"
        }

        
        return cell

    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("Places selected")
            performSegue(withIdentifier: "placesSegue", sender: self)
        }
        else if indexPath.section == 1 {
            print("Foods selected")
            performSegue(withIdentifier: "foodsSegue", sender: self)
        }
        else if indexPath.section == 2 {
            print("Flag selected")
            performSegue(withIdentifier: "flagSegue", sender: self)
            
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
