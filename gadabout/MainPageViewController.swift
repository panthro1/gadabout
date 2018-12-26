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
import GoogleMobileAds
import Reachability

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

var glbToDoItemNames = [String]()
var glbToDoItemDescriptions = [String]()
var glbToDoItemImageFile = [PFFile]()
var glbToDoItemIDs = [String]()
var glbToDoItemCompleted = [Bool]()
var glbToDoItemPlaceOrFood = [String]()
var glbUserScore: Int = -1
var glbFlagScore: Int = -1


class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, scorePopupDelegate  {
    
    var isEnglish = true
    var questionSeenBefore = [String]()

    
    @IBOutlet weak var mainPageTableView: UITableView!
    
    @IBOutlet weak var mailLogin: UIBarButtonItem!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var navigationBar: UINavigationBar!
    
    var interstitial: GADInterstitial!
    
    var rowHeight = 100
    
    //let network: NetworkManager = NetworkManager.sharedInstance
    let reachability = Reachability()!
    
    @IBOutlet weak var mainTableView: UITableView!
    /*override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }*/
    
    
    
    @IBAction func mailLoginTapped(_ sender: Any) {
        
        let loginPopupVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loginPopUpID") as! ViewController
        self.addChildViewController(loginPopupVC)
        loginPopupVC.view.frame = self.view.bounds//self.view.frame
        self.view.addSubview(loginPopupVC.view)
        loginPopupVC.didMove(toParentViewController: self)
        
    }

    
    @IBAction func scoreTapped(_ sender: Any) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
        popOverVC.scoreWin = glbUserScore
        popOverVC.totalScore = glbFlagScore
        popOverVC.isFlagOutput = false
        popOverVC.isScoreSummary = true
        popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.bounds//self.view.frame
        //complete.isEnabled = false
        //back.isEnabled = false
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
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
        
        AppDelegate.AppUtility.lockOrientation(.portrait)
        
        /*NetworkManager.isUnreachable { [unowned self]_ in
            print("OFFLINE")
            DispatchQueue.main.async(){
                self.performSegue(withIdentifier: "offlineSegue", sender: self)
            }
        }*/
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)
        
        self.mainPageTableView.delegate = self
        self.mainPageTableView.dataSource = self
        self.mainPageTableView.allowsSelection = true
        
        let screenSize = UIScreen.main.bounds
        
        let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
        
        rowHeight = Int((Int(screenSize.height) - upperOffset - Int(bannerView.frame.height)) / 6)
        self.mainPageTableView.rowHeight = CGFloat(rowHeight)//100
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        

        
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
        
        if glbPlcObjectId.count < 5 {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
            activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            
            questionSeenBefore.removeAll()
            let questionCoveredQuery = PFQuery(className: "placesCoveredBefore")
            questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            questionCoveredQuery.findObjectsInBackground { [unowned self] (objects, error) in
                
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
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()

                    
                }
                
            }
        }
        
        if glbFdObjectId.count < 5 {
            
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
            activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            
            questionSeenBefore.removeAll()
            let foodsCoveredQuery = PFQuery(className: "foodsCoveredBefore")
            foodsCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            foodsCoveredQuery.findObjectsInBackground { [unowned self] (objects, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let foods = objects {
                        for food in foods {
                            //print("\(place["questionId"])")
                            self.questionSeenBefore.append(food["questionId"] as! String)
                        }
                    }
                }
                
                if glbFdObjectId.count > 0 {
                    for indx in 0 ..< glbFdObjectId.count {
                        self.questionSeenBefore.append(glbFdObjectId[indx])
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
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()

                    
                }
                
            }
        }
        
        // New code
        if glbToDoItemIDs.count == 0 {
            let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
            activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
            activityIndicator.center = self.view.center
            activityIndicator.hidesWhenStopped = true
            activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
            view.addSubview(activityIndicator)
            activityIndicator.startAnimating()
            UIApplication.shared.beginIgnoringInteractionEvents()

            
            var completed = [String]()
            var localItemIDs = [String]()
            let toDoListItemQuery = PFQuery(className: "ToDoList")
            toDoListItemQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            toDoListItemQuery.findObjectsInBackground { (objects, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let items = objects {
                        for item in items {
                            localItemIDs.append(item["item"] as! String)
                            glbToDoItemPlaceOrFood.append(item["PlaceOrFood"] as! String)
                            completed.append(item["Completed"] as! String)
                            
                        }
                    }
                }
                
                var indx = 0
                var placeItems = [String]()
                var foodItems = [String]()
                
                for itemId in localItemIDs {
                    if glbToDoItemPlaceOrFood[indx] == "Place" {
                        placeItems.append(itemId)
                    }
                    else {
                        foodItems.append(itemId)
                    }
                    indx = indx + 1
                }
                print("Place IDs: \(placeItems)")
                print("Food IDs: \(foodItems)")
                
                if placeItems.count > 0 {
                    print("place items count : \(placeItems.count)")
                    let placeQuery = PFQuery(className: "Places")
                    placeQuery.whereKey("objectId", containedIn: placeItems)
                    placeQuery.findObjectsInBackground(block: { (objects, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            if let places = objects {
                                for place in places {
                                    if let correctAnsInt = Int(place["correctAlternative"] as! String) {
                                        if correctAnsInt == 1 {
                                            glbToDoItemNames.append(place["alternative1"] as! String)
                                        }
                                        else if correctAnsInt == 2 {
                                            glbToDoItemNames.append(place["alternative2"] as! String)
                                        }
                                        else if correctAnsInt == 3 {
                                            glbToDoItemNames.append(place["alternative3"] as! String)
                                        }
                                        else if correctAnsInt == 4 {
                                            glbToDoItemNames.append(place["alternative4"] as! String)
                                        }
                                    }
                                    glbToDoItemDescriptions.append(place["engDescription"] as! String)
                                    glbToDoItemImageFile.append(place["imageFile"] as! PFFile)
                                    
                                    
                                    if let plcObjId = place.objectId {
                                        let arrIndx = localItemIDs.firstIndex(of: plcObjId)
                                        if let indx = arrIndx {
                                            if completed[indx] == "YES" {
                                                glbToDoItemCompleted.append(true)
                                            }
                                            else {
                                                glbToDoItemCompleted.append(false)
                                            }
                                        }
                                        else {
                                            glbToDoItemCompleted.append(false)
                                        }
                                        glbToDoItemIDs.append(plcObjId)
                                    }
                                    
                                }
                            }
                        }
                        if foodItems.count > 0 {
                            let foodQuery = PFQuery(className: "Foods")
                            foodQuery.whereKey("objectId", containedIn: foodItems)
                            foodQuery.findObjectsInBackground(block: { (objects, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                else {
                                    if let foods = objects {
                                        for food in foods {
                                            if let correctAnsInt = Int(food["correctAlternative"] as! String) {
                                                if correctAnsInt == 1 {
                                                    glbToDoItemNames.append(food["alternative1"] as! String)
                                                }
                                                else if correctAnsInt == 2 {
                                                    glbToDoItemNames.append(food["alternative2"] as! String)
                                                }
                                                else if correctAnsInt == 3 {
                                                    glbToDoItemNames.append(food["alternative3"] as! String)
                                                }
                                                else if correctAnsInt == 4 {
                                                    glbToDoItemNames.append(food["alternative4"] as! String)
                                                }
                                            }
                                            glbToDoItemDescriptions.append(food["engDescription"] as! String)
                                            glbToDoItemImageFile.append(food["imageFile"] as! PFFile)
                                            
                                            if let fdObjId = food.objectId {
                                                let arrIndx = localItemIDs.firstIndex(of: fdObjId)
                                                if let indx = arrIndx {
                                                    if completed[indx] == "YES" {
                                                        glbToDoItemCompleted.append(true)
                                                    }
                                                    else {
                                                        glbToDoItemCompleted.append(false)
                                                    }
                                                }
                                                else {
                                                    glbToDoItemCompleted.append(false)
                                                }
                                                glbToDoItemIDs.append(fdObjId)
                                            }
                                        }
                                    }
                                }
                                activityIndicator.stopAnimating()
                                UIApplication.shared.endIgnoringInteractionEvents()

                            })
                            
                        }
                        else {
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                        }
                    })
                }
                else if foodItems.count > 0 {
                    let foodQuery = PFQuery(className: "Foods")
                    foodQuery.whereKey("objectId", containedIn: foodItems)
                    foodQuery.findObjectsInBackground(block: { (objects, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            if let foods = objects {
                                for food in foods {
                                    if let correctAnsInt = Int(food["correctAlternative"] as! String) {
                                        if correctAnsInt == 1 {
                                            glbToDoItemNames.append(food["alternative1"] as! String)
                                        }
                                        else if correctAnsInt == 2 {
                                            glbToDoItemNames.append(food["alternative2"] as! String)
                                        }
                                        else if correctAnsInt == 3 {
                                            glbToDoItemNames.append(food["alternative3"] as! String)
                                        }
                                        else if correctAnsInt == 4 {
                                            glbToDoItemNames.append(food["alternative4"] as! String)
                                        }
                                    }
                                    glbToDoItemDescriptions.append(food["engDescription"] as! String)
                                    glbToDoItemImageFile.append(food["imageFile"] as! PFFile)
                                    
                                    if let fdObjId = food.objectId {
                                        let arrIndx = localItemIDs.firstIndex(of: fdObjId)
                                        if let indx = arrIndx {
                                            if completed[indx] == "YES" {
                                                glbToDoItemCompleted.append(true)
                                            }
                                            else {
                                                glbToDoItemCompleted.append(false)
                                            }
                                        }
                                        else {
                                            glbToDoItemCompleted.append(false)
                                        }
                                        glbToDoItemIDs.append(fdObjId)
                                    }
                                }
                            }
                        }
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()

                    })
                }
                else {
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()

                }
            }
        }
        
        if glbUserScore < 0 {
            let userScoreQuery = PFQuery(className: "UserScore")
            userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            userScoreQuery.findObjectsInBackground { (objects, error) in
                if let score = objects?.first {
                    if let totalScore = Int(score["score"] as! String) {
                        glbUserScore = totalScore
                    }
                    else {
                        glbUserScore = 0
                    }
                    
                    if let strScore = score["flagScore"] {
                        if let flagScore = Int(strScore as! String) {
                            glbFlagScore = flagScore
                        }
                        else {
                            glbFlagScore = 0
                        }
                    }
                    else {
                        glbFlagScore = 0
                    }
                }
                else {
                    glbUserScore = 0
                    glbFlagScore = 0
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
        
        return 7
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mainPageCell")
        
        cell.layer.cornerRadius=10 //set corner radius here
        cell.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 100).cgColor //logout.tintColor?.cgColor//UIColor.lightGray.cgColor  // set cell border color here
        cell.layer.borderWidth = 2 // set border width here
        
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
        
        if indexPath.row == 0 {
            cell.accessoryView = UIImageView(image: UIImage(named: "balloon.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.row == 1 {
            cell.accessoryView = UIImageView(image: UIImage(named: "egg.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.row == 2 {
            cell.accessoryView = UIImageView(image: UIImage(named: "puzzle.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)

        }
        else if indexPath.row == 3 {
            cell.accessoryView = UIImageView(image: UIImage(named: "slot.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.row == 4 {
            cell.accessoryView = UIImageView(image: UIImage(named: "list.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.row == 5 {
            cell.accessoryView = UIImageView(image: UIImage(named: "Flag_icon.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        
        //cell.righ.image = UIImage(named: "world.png")
        
        if indexPath.row == 0 {
            cell.textLabel?.text = " Places"
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = " Foods"
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = " Puzzle"
        }
        else if indexPath.row == 6 {
            cell.textLabel?.text = "  Post"
        }
        else if indexPath.row == 4 {
            cell.textLabel?.text = " To Do List"
        }
        else if indexPath.row == 3 {
            cell.textLabel?.text = " Lucky Strike"
        }
        else if indexPath.row == 5 {
            cell.textLabel?.text = " Flag Challenge"
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
        else if indexPath.row == 6 {
            print("Post selected")
            performSegue(withIdentifier: "postSegue", sender: self)
        }
        else if indexPath.row == 5 {
            print("Post selected")
            performSegue(withIdentifier: "flagSegue", sender: self)
        }
        else if indexPath.row == 4 {
            print("To Do List selected")
            performSegue(withIdentifier: "toDoListSegue", sender: self)
        }
        else if indexPath.row == 3 {
            print("Lucky Strike selected")
            performSegue(withIdentifier: "luckyStrikeSegue", sender: self)
        }
        
        tableView.deselectRow(at: indexPath, animated: true)
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
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)

        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
        case .cellular:
            print("Reachable via Cellular")
        case .none:
            print("Network not reachable")
            self.performSegue(withIdentifier: "offlineSegue", sender: self)
            //showOfflinePopup()
            
        }
    }

    func showOfflinePopup() {
        
        /*self.navigationController?.setNavigationBarHidden(true, animated: false)
        mainTableView.isScrollEnabled = false
        let rowToSelect: IndexPath = IndexPath(row: 0, section: 0)
        mainTableView.scrollToRow(at: rowToSelect, at: .top, animated: false)*/
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "offlinePopUpID") as! OfflineViewController
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.bounds//self.view.frame
        //complete.isEnabled = false
        //back.isEnabled = false
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
        
    }
    
    
    func SendCloseInfo() {
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
    }
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
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
