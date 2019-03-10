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
import UserNotifications

//var glbPlcImageFile = [PFFile]() // Global place variables
var glbPlcOption1 = [String]()
var glbPlcOption2 = [String]()
var glbPlcOption3 = [String]()
var glbPlcOption4 = [String]()
var glbPlcCorrectAnswer = [String]()
var glbPlcDescriptionEng = [String]()
var glbPlcObjectId = [String]()
var glbPlcImgs = [UIImage]()

//var glbFdImageFile = [PFFile]() // Global food variables
var glbFdOption1 = [String]()
var glbFdOption2 = [String]()
var glbFdOption3 = [String]()
var glbFdOption4 = [String]()
var glbFdCorrectAnswer = [String]()
var glbFdDescriptionEng = [String]()
var glbFdObjectId = [String]()
var glbFdImgs = [UIImage]()

var glbToDoItemNames = [String]()
var glbToDoItemDescriptions = [String]()
var glbToDoItemImg = [UIImage]()
var glbToDoItemIDs = [String]()
var glbToDoItemCompleted = [Bool]()
var glbToDoItemPlaceOrFood = [String]()

var glbFlagScore: Int = -1
var glbCorrectAnswer: Int = -1
var glbTotalQuestion: Int = -1
var glbPuzzleScore: Int = -1



class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isEnglish = true
    var questionSeenBefore = [String]()
    var cache = NSCache<AnyObject, AnyObject>()

    
    @IBOutlet weak var mainPageTableView: UITableView!
    
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
        
        /*let center = UNUserNotificationCenter.current()
        center.removeAllDeliveredNotifications() // To remove all delivered notifications
        center.removeAllPendingNotificationRequests()*/
        
        UNUserNotificationCenter.current().getPendingNotificationRequests { [unowned self ] (requests) in
            print("Recorded requests count \(requests.count)")
            
            if requests.count == 0 {
                print("Record notification request")
                self.registerUserNotification()
            }
        }
        
        
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
        
        let topSafeArea = UIApplication.shared.windows[0].safeAreaInsets.top
        print("Top safe area: \(topSafeArea)")
        
        let bottomSafeArea = UIApplication.shared.windows[0].safeAreaInsets.bottom
        print("Bottom safe area: \(bottomSafeArea)")
        
        
        let navBarHeight = self.navigationBar.frame.size.height//UIApplication.shared.statusBarFrame.height
        let upperOffset = /*Int(screenSize.height*0.01) + */Int(navBarHeight) + Int(topSafeArea)
        rowHeight = Int((Int(screenSize.height*0.70) - upperOffset - Int(bannerView.frame.height) - Int(bottomSafeArea) - Int(screenSize.height*0.08)) / 4)
        
        print("nav bar height: \(navigationBar.frame.size.height)" )
        print("screen height: \(screenSize.height)" )
        print("table height: \(mainTableView.frame.height)" )
        print("status bar height: \(UIApplication.shared.statusBarFrame.height)" )


        self.mainPageTableView.rowHeight = CGFloat(rowHeight)
        
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
        
        if glbPlcObjectId.count < 4 {
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
                placesQuery.limit = 50
                placesQuery.findObjectsInBackground { [unowned self] (objects, error) in
                    if let places = objects {
                        
                        for place in places {
                            
                            //Caching update
                            let plcImg = place["imageFile"] as! PFFile
                            plcImg.getDataInBackground { [unowned self] (data, error) in
                                
                                if let imageData = data {
                                    
                                    if let imageToDisplay = UIImage(data: imageData) {
                                        
                                        let imageCache = imageToDisplay
                                        
                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                        
                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                            
                                            glbPlcImgs.append(cacheimg)
                                            
                                            glbPlcOption1.append(place["alternative1"] as! String)
                                            glbPlcOption2.append(place["alternative2"] as! String)
                                            glbPlcOption3.append(place["alternative3"] as! String)
                                            glbPlcOption4.append(place["alternative4"] as! String)
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
                    }
                    
                    if glbPlcObjectId.count < 4 {
                        let allPlacesQuery = PFQuery(className: "Places")
                        allPlacesQuery.limit = 50
                        allPlacesQuery.findObjectsInBackground { [unowned self] (objects, error) in
                            if let places = objects {
                                
                                for place in places {
                                    
                                    if let question = place.objectId {
                                        if glbPlcObjectId.firstIndex(of: question) == nil {
                                            
                                            //Caching update
                                            let plcImg = place["imageFile"] as! PFFile
                                            plcImg.getDataInBackground { [unowned self] (data, error) in
                                                
                                                if let imageData = data {
                                                    
                                                    if let imageToDisplay = UIImage(data: imageData) {
                                                        
                                                        let imageCache = imageToDisplay
                                                        
                                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                        
                                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                            
                                                            glbPlcImgs.append(cacheimg)
                                                            
                                                            glbPlcObjectId.append(question)
                                                            glbPlcOption1.append(place["alternative1"] as! String)
                                                            glbPlcOption2.append(place["alternative2"] as! String)
                                                            glbPlcOption3.append(place["alternative3"] as! String)
                                                            glbPlcOption4.append(place["alternative4"] as! String)
                                                            glbPlcCorrectAnswer.append(place["correctAlternative"] as! String)
                                                            glbPlcDescriptionEng.append(place["engDescription"] as! String)

                                                        }
                                                    }
                                                }
                                            }

                                        }
                                    }
                                }
                            }
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        }
                    }
                    else {
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
                }
                
            }
        }
        
        if glbFdObjectId.count < 4 {
            
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
                foodsQuery.limit = 50
                foodsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                    if let foods = objects {
                        
                        for food in foods {
                            
                            //Caching update
                            let fdImg = food["imageFile"] as! PFFile
                            fdImg.getDataInBackground { [unowned self] (data, error) in
                                
                                if let imageData = data {
                                    
                                    if let imageToDisplay = UIImage(data: imageData) {
                                        
                                        let imageCache = imageToDisplay
                                        
                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                        
                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                            
                                            glbFdImgs.append(cacheimg)
                                            glbFdOption1.append(food["alternative1"] as! String)
                                            glbFdOption2.append(food["alternative2"] as! String)
                                            glbFdOption3.append(food["alternative3"] as! String)
                                            glbFdOption4.append(food["alternative4"] as! String)
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
                    }
                    
                    if glbFdObjectId.count < 4 {
                        let allFoodsQuery = PFQuery(className: "Foods")
                        allFoodsQuery.limit = 50
                        allFoodsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                            if let foods = objects {
                                
                                for food in foods {
                                    
                                    if let question = food.objectId {
                                        if glbFdObjectId.firstIndex(of: question) == nil {
                                            
                                            //Caching update
                                            let fdImg = food["imageFile"] as! PFFile
                                            fdImg.getDataInBackground { [unowned self] (data, error) in
                                                
                                                if let imageData = data {
                                                    
                                                    if let imageToDisplay = UIImage(data: imageData) {
                                                        
                                                        let imageCache = imageToDisplay
                                                        
                                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                        
                                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                            
                                                            glbFdImgs.append(cacheimg)
                                                            glbFdObjectId.append(question)
                                                            glbFdOption1.append(food["alternative1"] as! String)
                                                            glbFdOption2.append(food["alternative2"] as! String)
                                                            glbFdOption3.append(food["alternative3"] as! String)
                                                            glbFdOption4.append(food["alternative4"] as! String)
                                                            glbFdCorrectAnswer.append(food["correctAlternative"] as! String)
                                                            glbFdDescriptionEng.append(food["engDescription"] as! String)

                                                        }
                                                    }
                                                }
                                            }

                                        }
                                        
                                    }
                                }
                            }
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                        }
                    }
                    else {
                        activityIndicator.stopAnimating()
                        UIApplication.shared.endIgnoringInteractionEvents()
                    }
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
            toDoListItemQuery.findObjectsInBackground { [unowned self] (objects, error) in
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
                    placeQuery.findObjectsInBackground(block: { [unowned self] (objects, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            if let places = objects {
                                for place in places {
                                    
                                    //Caching update
                                    let todoImg = place["imageFile"] as! PFFile
                                    todoImg.getDataInBackground { [unowned self] (data, error) in
                                        
                                        if let imageData = data {
                                            
                                            if let imageToDisplay = UIImage(data: imageData) {
                                                
                                                let imageCache = imageToDisplay
                                                
                                                self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                
                                                if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                    
                                                    glbToDoItemImg.append(cacheimg)
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

                                                }
                                            }
                                        }
                                    }
                                    
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
                            foodQuery.findObjectsInBackground(block: { [unowned self] (objects, error) in
                                if let error = error {
                                    print(error.localizedDescription)
                                }
                                else {
                                    if let foods = objects {
                                        for food in foods {
                                            
                                            //Caching update
                                            let todoImg = food["imageFile"] as! PFFile
                                            todoImg.getDataInBackground { [unowned self] (data, error) in
                                                
                                                if let imageData = data {
                                                    
                                                    if let imageToDisplay = UIImage(data: imageData) {
                                                        
                                                        let imageCache = imageToDisplay
                                                        
                                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                        
                                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                            
                                                            glbToDoItemImg.append(cacheimg)
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

                                                        }
                                                    }
                                                }
                                            }
                                            
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
                    foodQuery.findObjectsInBackground(block: { [unowned self] (objects, error) in
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        else {
                            if let foods = objects {
                                for food in foods {
                                    //Caching update
                                    let todoImg = food["imageFile"] as! PFFile
                                    todoImg.getDataInBackground { [unowned self] (data, error) in
                                        
                                        if let imageData = data {
                                            
                                            if let imageToDisplay = UIImage(data: imageData) {
                                                
                                                let imageCache = imageToDisplay
                                                
                                                self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                
                                                if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                    
                                                    glbToDoItemImg.append(cacheimg)
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

                                                }
                                            }
                                        }
                                    }
                                    
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
        
        if (glbFlagScore < 0) || (glbPuzzleScore < 0) || (glbCorrectAnswer < 0) || (glbTotalQuestion < 0) {
            let userScoreQuery = PFQuery(className: "UserScore")
            userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            userScoreQuery.findObjectsInBackground { (objects, error) in
                if let score = objects?.first {
                    if let strTotalQuestion = score["totalQuestion"] {
                        if let totalQuestion = Int(strTotalQuestion as! String) {
                            glbTotalQuestion = totalQuestion
                        }
                        else {
                            glbTotalQuestion = 0
                        }
                    }
                    else {
                        glbTotalQuestion = 0
                    }
                    
                    if let strCorrectAnswer = score["correctAnswer"] {
                        if let correctAnswer = Int(strCorrectAnswer as! String) {
                            glbCorrectAnswer = correctAnswer
                        }
                        else {
                            glbCorrectAnswer = 0
                        }
                    }
                    else {
                        glbCorrectAnswer = 0
                    }

                    if let strPuzzleScore = score["score"] {
                        if let puzzleScore = Int(strPuzzleScore as! String) {
                            glbPuzzleScore = puzzleScore
                        }
                        else {
                            glbPuzzleScore = 0
                        }
                    }
                    else {
                        glbPuzzleScore = 0
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
                    glbCorrectAnswer = 0
                    glbTotalQuestion = 0
                    glbFlagScore = 0
                    glbPuzzleScore = 0
                    
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
        
        return 1
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return (UIScreen.main.bounds.height*0.02)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let v = UIView()
        v.backgroundColor = UIColor.clear
        return v
    }
    
    
    

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mainPageCell")
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        cell.layer.cornerRadius=10 //set corner radius here
        cell.layer.borderColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 100).cgColor //logout.tintColor?.cgColor//UIColor.lightGray.cgColor  // set cell border color here
        cell.layer.borderWidth = 2 // set border width here
        cell.backgroundColor = UIColor.clear
        
        let screenSize = UIScreen.main.bounds
        
        if screenSize.width < 350 {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 28) //
        }
        else if screenSize.width < 400 {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 30)
        }
        else {
            cell.textLabel?.font = UIFont(name: "Avenir", size: 32)
        }
        
        let rowImageSize = Double(rowHeight)*0.8
        
        if indexPath.section == 0 {
            cell.accessoryView = UIImageView(image: UIImage(named: "scoring.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 1 {
            cell.accessoryView = UIImageView(image: UIImage(named: "slot-machine.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }
        else if indexPath.section == 2 {
            cell.accessoryView = UIImageView(image: UIImage(named: "puzzle.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)

        }
        else if indexPath.section == 3 {
            cell.accessoryView = UIImageView(image: UIImage(named: "users.png"))
            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: rowImageSize, height: rowImageSize)
        }

        
        //cell.righ.image = UIImage(named: "world.png")
        
        if indexPath.section == 0 {
            cell.textLabel?.text = " Challenges"
            
            cell.detailTextLabel?.text = "   Quizzes with images"
            cell.detailTextLabel?.textColor = UIColor.darkGray
            
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = " Lucky Strike"

            cell.detailTextLabel?.text = "   Randomly picked images"
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = " Puzzle"

            cell.detailTextLabel?.text = "   Sliding image puzzle"
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        else if indexPath.section == 3 {
            cell.textLabel?.text = " Profile"

            cell.detailTextLabel?.text = "   To Do list, mail login"
            cell.detailTextLabel?.textColor = UIColor.darkGray
        }
        
        return cell
    }

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            print("Challenges selected")
            performSegue(withIdentifier: "challengeSegue", sender: self)
        }
        else if indexPath.section == 1 {
            print("Food selected")
            performSegue(withIdentifier: "luckyStrikeSegue", sender: self)
        }
        else if indexPath.section == 2 {
            print("Map puzzle selected")
            performSegue(withIdentifier: "puzzleMapSegue", sender: self)

        }
        else if indexPath.section == 3 {
            print("Profile selected")
            performSegue(withIdentifier: "profileSegue", sender: self)
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
    
    

    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func registerUserNotification() {
        let center = UNUserNotificationCenter.current()
        
        let content = UNMutableNotificationContent()
        content.title = "Waiting for you"
        content.body = "New things to explore from all over the world !!"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default()
        
        var dateComponents = DateComponents()
        dateComponents.hour = 11
        dateComponents.minute = 20
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
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
