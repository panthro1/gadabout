//
//  MainPageViewController.swift
//  gadabout
//
//  Created by Ahmet on 7.07.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import CoreData
import Parse

var glbPlcImageFile = [PFFile]() // Global place variables
var glbPlcOption1 = [String]()
var glbPlcOption2 = [String]()
var glbPlcOption3 = [String]()
var glbPlcOption4 = [String]()
var glbPlcCorrectAnswer = [String]()
var glbPlcDescriptionEng = [String]()
var glbPlcObjectId = [String]()

var glbFdImageFile = [PFFile]() // Global food variables
var glbFdOption1 = [String]()
var glbFdOption2 = [String]()
var glbFdOption3 = [String]()
var glbFdOption4 = [String]()
var glbFdCorrectAnswer = [String]()
var glbFdDescriptionEng = [String]()
var glbFdObjectId = [String]()


class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isEnglish = true
    var questionSeenBefore = [String]()


    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBOutlet weak var mainPageTableView: UITableView!
    
    @IBOutlet weak var mailLogin: UIBarButtonItem!
    
    
    @IBAction func mailLoginTapped(_ sender: Any) {
        
        let loginPopupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPopUpID") as! ViewController
        self.addChildViewController(loginPopupVC)
        loginPopupVC.view.frame = self.view.bounds//self.view.frame
        self.view.addSubview(loginPopupVC.view)
        loginPopupVC.didMove(toParentViewController: self)
        
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        /*PFUser.logOutInBackground { (error) in
            
            if error != nil {
                print("logout fail")
                print(error) }
            else {
                print("logout success")
            }
        }*/
        
        PFUser.logOut()
        
        //dismiss(animated: true, completion: nil)

        performSegue(withIdentifier: "logoutSegue", sender: self)
        

    }
    
    @objc func isRotated() {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
                print("Landscape left")
        case .landscapeRight:
                print("Landscape right")
        case .portrait:
                print("Portrait")
        case .portraitUpsideDown:
                print("Portrait upside down")
        case .unknown:
            print("unknown")
        case .faceUp:
            print("face up")
        case .faceDown:
            print("face down")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //super.viewDidLoad()
        
        self.mainPageTableView.delegate = self
        self.mainPageTableView.dataSource = self
        self.mainPageTableView.allowsSelection = true
        
        self.mainPageTableView.rowHeight = 100
        
        NotificationCenter.default.addObserver(self, selector: #selector(isRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if  PFUser.current() != nil {
            
            print("Username: \(PFUser.current()?.email), objectId: \(PFUser.current()?.objectId)")
        }
        else {
            PFAnonymousUtils.logIn { (user, error) in
                if error != nil || user == nil {
                    print("Anonymous login failed")
                }
                else {
                    print("Anoymous user logged in")
                    print("Username: \(PFUser.current()?.email), objectId: \(PFUser.current()?.objectId)")
                }
            }
        }
        
        // New Code
        if glbPlcObjectId.count < 5 {
            questionSeenBefore.removeAll()
            let questionCoveredQuery = PFQuery(className: "placesCoveredBefore")
            questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            questionCoveredQuery.findObjectsInBackground { (objects, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let places = objects {
                        for place in places {
                            //print("\(place["questionId"])")
                            self.questionSeenBefore.append(place["questionId"] as! String)
                        }
                    }
                }
                
                if glbPlcObjectId.count > 0 {
                    for indx in 0 ..< glbPlcObjectId.count {
                        self.questionSeenBefore.append(glbPlcObjectId[indx])
                    }
                }
                
                let placesQuery = PFQuery(className: "Places")
                placesQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                placesQuery.findObjectsInBackground { (objects, error) in
                    if let places = objects {
                        
                        for place in places {
                            
                            glbPlcOption1.append(place["alternative1"] as! String)
                            glbPlcOption2.append(place["alternative2"] as! String)
                            glbPlcOption3.append(place["alternative3"] as! String)
                            glbPlcOption4.append(place["alternative4"] as! String)
                            glbPlcImageFile.append(place["imageFile"] as! PFFile)
                            glbPlcCorrectAnswer.append(place["correctAlternative"] as! String)
                            glbPlcDescriptionEng.append(place["engDescription"] as! String)
                            
                            if let question = place.objectId {
                                glbPlcObjectId.append(question)
                            }
                        }
                    }
                    
                }
                
            }
        }
        
        if glbFdObjectId.count < 5 {
            
            questionSeenBefore.removeAll()
            let foodsCoveredQuery = PFQuery(className: "foodsCoveredBefore")
            foodsCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            foodsCoveredQuery.findObjectsInBackground { (objects, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let places = objects {
                        for place in places {
                            //print("\(place["questionId"])")
                            self.questionSeenBefore.append(place["questionId"] as! String)
                        }
                    }
                }
                let foodsQuery = PFQuery(className: "Foods")
                foodsQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                foodsQuery.findObjectsInBackground { (objects, error) in
                    if let foods = objects {
                        
                        for food in foods {
                            
                            glbFdOption1.append(food["alternative1"] as! String)
                            glbFdOption2.append(food["alternative2"] as! String)
                            glbFdOption3.append(food["alternative3"] as! String)
                            glbFdOption4.append(food["alternative4"] as! String)
                            glbFdImageFile.append(food["imageFile"] as! PFFile)
                            glbFdCorrectAnswer.append(food["correctAlternative"] as! String)
                            glbFdDescriptionEng.append(food["engDescription"] as! String)
                            
                            if let question = food.objectId {
                                glbFdObjectId.append(question)
                            }
                            
                        }
                    }
                    
                }
                
            }
        }

        


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mainPageCell")
        
        cell.layer.cornerRadius=10 //set corner radius here
        cell.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 100).cgColor //logout.tintColor?.cgColor//UIColor.lightGray.cgColor  // set cell border color here
        cell.layer.borderWidth = 2 // set border width here
        
        cell.textLabel?.font = UIFont(name: "Avenir", size: 32)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "    Places"
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "    Foods"
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = "    Puzzle"
        }
        else if indexPath.row == 5 {
            cell.textLabel?.text = "    Post"
        }
        else if indexPath.row == 4 {
            cell.textLabel?.text = "    To Do List"
        }
        else if indexPath.row == 3 {
            cell.textLabel?.text = "    Lucky Strike"
        }
        
        return cell
    }

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            print("Places selected")
            performSegue(withIdentifier: "placesSegue", sender: self)
        }
        else if indexPath.row == 1 {
            print("Food selected")
            performSegue(withIdentifier: "foodsSegue", sender: self)
        }
        else if indexPath.row == 2 {
            print("Map puzzle selected")
            performSegue(withIdentifier: "puzzleMapSegue", sender: self)

        }
        else if indexPath.row == 5 {
            print("Post selected")
            performSegue(withIdentifier: "postSegue", sender: self)
        }
        else if indexPath.row == 4 {
            print("To Do List selected")
            performSegue(withIdentifier: "toDoListSegue", sender: self)
        }
        else if indexPath.row == 3 {
            print("Lucky Strike selected")
            performSegue(withIdentifier: "luckyStrikeSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        let src = self
        let transition: CATransition = CATransition()
        let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        transition.duration = 0.3
        transition.timingFunction = timeFunc
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        
        src.view.window?.layer.add(transition, forKey: nil)
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
