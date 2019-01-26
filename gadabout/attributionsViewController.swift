//
//  attributionsViewController.swift
//  gadabout
//
//  Created by Ahmet on 23.01.2019.
//  Copyright © 2019 Ahmet. All rights reserved.
//

import UIKit
import GoogleMobileAds

class attributionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    
    @IBOutlet weak var attributionsTableView: UITableView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    let rowHeight: CGFloat = 50
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        attributionsTableView.rowHeight = rowHeight
        // Do any additional setup after loading the view.
    }
    

    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "attributionBackSegue", sender: self)
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
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 13
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (UIScreen.main.bounds.height*0.01)
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
        
        
        let rowImageSize = Double(rowHeight)*0.6
        
        if indexPath.section == 0 {
            cell.accessoryView = UIImageView(image: UIImage(named: "gadabout_launch.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 1 {
            cell.accessoryView = UIImageView(image: UIImage(named: "scoring.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 2 {
            cell.accessoryView = UIImageView(image: UIImage(named: "breakfast.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 3 {
            cell.accessoryView = UIImageView(image: UIImage(named: "users.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 4 {
            cell.accessoryView = UIImageView(image: UIImage(named: "hot-air-balloon.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 5 {
            cell.accessoryView = UIImageView(image: UIImage(named: "slot-machine.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 6 {
            cell.accessoryView = UIImageView(image: UIImage(named: "puzzle.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 7 {
            cell.accessoryView = UIImageView(image: UIImage(named: "back-button.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 8 {
            cell.accessoryView = UIImageView(image: UIImage(named: "rightArrow.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 9 {
            cell.accessoryView = UIImageView(image: UIImage(named: "list.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 10 {
            cell.accessoryView = UIImageView(image: UIImage(named: "outlook.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 11 {
            cell.accessoryView = UIImageView(image: UIImage(named: "email.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 12 {
            cell.accessoryView = UIImageView(image: UIImage(named: "lock.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }

        
        
        if indexPath.section == 0 {
            cell.textLabel?.text = "Icon made by Freepik from www.flaticon.com"
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = "Icon made by Eucalyp from www.flaticon.com"
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = "Icon made by photo3idea_studio from www.flaticon.com"
        }
        else if indexPath.section == 3 {
            cell.textLabel?.text = "Icon made by Smashicons from www.flaticon.com"
        }
        else if indexPath.section == 4 {
            cell.textLabel?.text = "Icon made by Payungkead from www.flaticon.com"
        }
        else if indexPath.section == 5 {
            cell.textLabel?.text = "Icon made by Smashicons from www.flaticon.com"
        }
        else if indexPath.section == 6 {
            cell.textLabel?.text = "Icon made by Becris from www.flaticon.com"
        }
        else if indexPath.section == 7 {
            cell.textLabel?.text = "Icon made by Google from www.flaticon.com"
        }
        else if indexPath.section == 8 {
            cell.textLabel?.text = "Icon made by Freepik from www.flaticon.com"
        }
        else if indexPath.section == 9 {
            cell.textLabel?.text = "Icon made by Freepik from www.flaticon.com"
        }
        else if indexPath.section == 10 {
            cell.textLabel?.text = "Icon made by Pixel perfect from www.flaticon.com"
        }
        else if indexPath.section == 11 {
            cell.textLabel?.text = "Icon made by Freepik from www.flaticon.com"
        }
        else if indexPath.section == 12 {
            cell.textLabel?.text = "Icon made by Those Icons from www.flaticon.com"
        }

        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        
        return cell
        
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
