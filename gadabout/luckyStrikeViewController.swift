//
//  luckyStrikeViewController.swift
//  gadabout
//
//  Created by Ahmet on 18.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds

class luckyStrikeViewController: UIViewController {
    
    
    var option1 = [String]()
    var option2 = [String]()
    var option3 = [String]()
    var option4 = [String]()
    var descriptionEng = [String]()
    var correctAnswer = [String]()
    var imageFile = [PFFile]()
    var nofPlaceInstances: Int32 = 0
    var nofFoodInstances: Int32 = 0
    var placeFoodSelection: UInt32 = 0
    var currentObjectId = String()
    var isCurrentItemPlace = Bool()
    var currentImage = [PFFile]()
    var isPlace = [Bool]()
    var objectId = [String]()
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var toDoListButton: UIButton!
    
    @IBOutlet weak var descriptionLabel: UILabel!
    
    @IBOutlet weak var photoCredit: UILabel!
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "luckyStrikeBackSegue", sender: self)
    }
    
    
    @IBAction func toDoListTapped(_ sender: Any) {
        
        let button = view
        
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            button!.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                button!.transform = CGAffineTransform.identity
                            })
        })
        

        print("Current object: \(currentObjectId) isPlace: \(isCurrentItemPlace)")
        if glbToDoItemIDs.firstIndex(of: currentObjectId) == nil {
            if currentObjectId.count > 0  {
                let toDoItem = PFObject(className: "ToDoList")
                
                toDoItem["item"] = currentObjectId
                toDoItem["userId"] = PFUser.current()?.objectId
                if isCurrentItemPlace == true {
                    toDoItem["PlaceOrFood"] = "Place"
                }
                else {
                    toDoItem["PlaceOrFood"] = "Food"
                }
                toDoItem["Completed"] = "No"
                
                toDoItem.saveInBackground { (success, error) in
                    
                    if success {
                        print("Entity saved successfully")
                    }
                    else { // success
                        
                        print("Entity could not be saved")
                        print(error?.localizedDescription)
                    }
                }
                if let header = headerLabel.text {
                    if let description = descriptionLabel.text {
                        if let imgFile = currentImage.first {
                            
                            glbToDoItemIDs.append(currentObjectId)
                            glbToDoItemNames.append(header)
                            glbToDoItemDescriptions.append(description)
                            glbToDoItemCompleted.append(false)
                            glbToDoItemPlaceOrFood.append("Place")
                            glbToDoItemImageFile.append(imgFile)
                            
                        }
                    }
                }
            }
        }

        
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.pulsate()
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
        // New code
        
        if imageFile.count < 2 {
            
            let placesQuery = PFQuery(className: "Places")
            
            placesQuery.limit = 1000
            placesQuery.findObjectsInBackground { (objects, error) in
                
                
                if let places = objects {
                    
                    for place in places {
                        
                        self.option1.append(place["alternative1"] as! String)
                        self.option2.append(place["alternative2"] as! String)
                        self.option3.append(place["alternative3"] as! String)
                        self.option4.append(place["alternative4"] as! String)
                        self.imageFile.append(place["imageFile"] as! PFFile)
                        self.correctAnswer.append(place["correctAlternative"] as! String)
                        self.descriptionEng.append(place["engDescription"] as! String)
                        self.isPlace.append(true)
                        if let question = place.objectId {
                            self.objectId.append(question)
                        }
                        
                    }
                }
                
                let foodsQuery = PFQuery(className: "Foods")
                
                foodsQuery.limit = 1000
                foodsQuery.findObjectsInBackground { (objects, error) in
                    
                    
                    if let foods = objects {
                        
                        for food in foods {
                            
                            self.option1.append(food["alternative1"] as! String)
                            self.option2.append(food["alternative2"] as! String)
                            self.option3.append(food["alternative3"] as! String)
                            self.option4.append(food["alternative4"] as! String)
                            self.imageFile.append(food["imageFile"] as! PFFile)
                            self.correctAnswer.append(food["correctAlternative"] as! String)
                            self.descriptionEng.append(food["engDescription"] as! String)
                            self.isPlace.append(false)
                            if let question = food.objectId {
                                self.objectId.append(question)
                            }
                        }
                    }
                    let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count)))
                    print("Random Index: \(randomIndex)")
                    
                    self.imageFile[randomIndex].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.image.image = imageToDisplay

                            }
                        }
                        
                    }
                    if let correctAnsInt = Int(self.correctAnswer[randomIndex]) {
                        
                        if correctAnsInt == 1 {
                            self.headerLabel.text = self.option1[randomIndex]
                        }
                        else if correctAnsInt == 2 {
                            self.headerLabel.text = self.option2[randomIndex]
                        }
                        else if correctAnsInt == 3 {
                            self.headerLabel.text = self.option3[randomIndex]
                        }
                        else if correctAnsInt == 4 {
                            self.headerLabel.text = self.option4[randomIndex]
                        }
                    }
                    
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    self.currentObjectId = self.objectId[randomIndex]
                    self.isCurrentItemPlace = self.isPlace[randomIndex]
                    self.currentImage.removeAll()
                    self.currentImage.append(self.imageFile[randomIndex])
                    
                    //self.descriptionText.text = self.descriptionEng[randomIndex]
                    //self.descriptionText.isHidden = false
                    let newDescription = NSString(string: self.descriptionEng[randomIndex])
                    let components = newDescription.components(separatedBy: "Photo licensed under")
                    if components.count == 2 {
                        self.photoCredit.text = "Photo licensed under" + components[1]
                        self.photoCredit.isHidden = false
                        self.descriptionLabel.text = components[0]
                    }
                    else{
                        self.photoCredit.isHidden = true
                        self.descriptionLabel.text = self.descriptionEng[randomIndex]
                    }
                    self.descriptionLabel.isHidden = false
                    self.descriptionLabel.sizeToFit()
                    self.descriptionLabel.numberOfLines = 0
                    
                    self.headerLabel.isHidden = false
                    self.image.isHidden = false
                    
                    self.option1.remove(at: randomIndex)
                    self.option2.remove(at: randomIndex)
                    self.option3.remove(at: randomIndex)
                    self.option4.remove(at: randomIndex)
                    self.imageFile.remove(at: randomIndex)
                    self.correctAnswer.remove(at: randomIndex)
                    self.descriptionEng.remove(at: randomIndex)
                    self.isPlace.remove(at: randomIndex)
                    self.objectId.remove(at: randomIndex)

                }
                
            }
        }
        else{
            
            let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count)))
            print("Random Index: \(randomIndex)")
            
            self.imageFile[randomIndex].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        self.image.image = imageToDisplay
                        
                    }
                }
                
            }
            if let correctAnsInt = Int(self.correctAnswer[randomIndex]) {
                
                if correctAnsInt == 1 {
                    self.headerLabel.text = self.option1[randomIndex]
                }
                else if correctAnsInt == 2 {
                    self.headerLabel.text = self.option2[randomIndex]
                }
                else if correctAnsInt == 3 {
                    self.headerLabel.text = self.option3[randomIndex]
                }
                else if correctAnsInt == 4 {
                    self.headerLabel.text = self.option4[randomIndex]
                }
            }
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            currentObjectId = objectId[randomIndex]
            isCurrentItemPlace = isPlace[randomIndex]
            currentImage.removeAll()
            currentImage.append(imageFile[randomIndex])
            
            let newDescription = NSString(string: self.descriptionEng[randomIndex])
            let components = newDescription.components(separatedBy: "Photo licensed under")
            if components.count == 2 {
                self.photoCredit.text = "Photo licensed under" + components[1]
                self.photoCredit.isHidden = false
                self.descriptionLabel.text = components[0]
            }
            else{
                self.photoCredit.isHidden = true
                self.descriptionLabel.text = self.descriptionEng[randomIndex]
            }
            self.descriptionLabel.isHidden = false
            self.descriptionLabel.sizeToFit()
            self.descriptionLabel.numberOfLines = 0
            
            self.headerLabel.isHidden = false
            self.image.isHidden = false
            
            self.option1.remove(at: randomIndex)
            self.option2.remove(at: randomIndex)
            self.option3.remove(at: randomIndex)
            self.option4.remove(at: randomIndex)
            self.imageFile.remove(at: randomIndex)
            self.correctAnswer.remove(at: randomIndex)
            self.descriptionEng.remove(at: randomIndex)
            self.isPlace.remove(at: randomIndex)
            self.objectId.remove(at: randomIndex)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        /*nextButton.backgroundColor = .clear
        nextButton.layer.cornerRadius = 5
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.black.cgColor*/
        
        toDoListButton.layer.cornerRadius = 5
        toDoListButton.layer.borderWidth = 1
        toDoListButton.layer.borderColor = UIColor.black.cgColor
        
        let screenSize = UIScreen.main.bounds
        
        if screenSize.width < 350 {
            toDoListButton.titleLabel?.font = .systemFont(ofSize: 15)
        }
        else if screenSize.width < 400 {
            toDoListButton.titleLabel?.font = .systemFont(ofSize: 16)
        }
        else {
            toDoListButton.titleLabel?.font = .systemFont(ofSize: 17)
        }
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        // New code starts from here
        
        for indx in 0 ..< glbPlcImageFile.count {
            
            option1.append(glbPlcOption1[indx])
            option2.append(glbPlcOption2[indx])
            option3.append(glbPlcOption3[indx])
            option4.append(glbPlcOption4[indx])
            imageFile.append(glbPlcImageFile[indx])
            correctAnswer.append(glbPlcCorrectAnswer[indx])
            descriptionEng.append(glbPlcDescriptionEng[indx])
            objectId.append(glbPlcObjectId[indx])
            isPlace.append(true)
        }

        for indx in 0 ..< glbFdImageFile.count {
            
            option1.append(glbFdOption1[indx])
            option2.append(glbFdOption2[indx])
            option3.append(glbFdOption3[indx])
            option4.append(glbFdOption4[indx])
            imageFile.append(glbFdImageFile[indx])
            correctAnswer.append(glbFdCorrectAnswer[indx])
            descriptionEng.append(glbFdDescriptionEng[indx])
            objectId.append(glbFdObjectId[indx])
            isPlace.append(false)
        }
        
        if imageFile.count > 5 {

            
            let randomIndex = Int(arc4random_uniform(UInt32(imageFile.count)))
            print("Random Index: \(randomIndex)")
            
            imageFile[randomIndex].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        self.image.image = imageToDisplay
                    }
                }
                
            }
            if let correctAnsInt = Int(correctAnswer[randomIndex]) {
                
                if correctAnsInt == 1 {
                    headerLabel.text = option1[randomIndex]
                }
                else if correctAnsInt == 2 {
                    headerLabel.text = option2[randomIndex]
                }
                else if correctAnsInt == 3 {
                    headerLabel.text = option3[randomIndex]
                }
                else if correctAnsInt == 4 {
                    headerLabel.text = option4[randomIndex]
                }
            }
            
            
            /*if let correctAnsInt = Int(correctAnswer[randomIndex]) {
                
                if correctAnsInt == 1 {
                    headerLabel.text = option1[randomIndex]
                    /*let str: String = option1[randomIndex]
                     let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22)]
                     let attributedString = NSMutableAttributedString(string:str, attributes:attrs)
                     
                     let normalText = "\n" + "testing"//descriptionEng[randomIndex]
                     let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
                     let normalString = NSMutableAttributedString(string:normalText, attributes:attrs2)
                     
                     attributedString.append(normalString)
                     headerLabel.attributedText = attributedString
                     headerLabel.sizeToFit()*/
                }
                else if correctAnsInt == 2 {
                    headerLabel.text = option2[randomIndex]
                    
                    /*let str: String = option2[randomIndex]
                     let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22)]
                     let attributedString = NSMutableAttributedString(string:str, attributes:attrs)
                     
                     let normalText = "\n" + "testing"//descriptionEng[randomIndex]
                     let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
                     let normalString = NSMutableAttributedString(string:normalText, attributes:attrs2)
                     
                     attributedString.append(normalString)
                     headerLabel.attributedText = attributedString
                     headerLabel.sizeToFit()*/
                }
                else if correctAnsInt == 3 {
                    headerLabel.text = option3[randomIndex]
                    
                    /*let str: String = option3[randomIndex]
                     let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22)]
                     let attributedString = NSMutableAttributedString(string:str, attributes:attrs)
                     
                     let normalText = "\n" + "testing"//descriptionEng[randomIndex]
                     let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
                     let normalString = NSMutableAttributedString(string:normalText, attributes:attrs2)
                     
                     attributedString.append(normalString)
                     headerLabel.attributedText = attributedString
                     headerLabel.sizeToFit()*/
                }
                else if correctAnsInt == 4 {
                    headerLabel.text = option4[randomIndex]
                    
                    /*let str: String = option4[randomIndex]
                     let attrs = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 22)]
                     let attributedString = NSMutableAttributedString(string:str, attributes:attrs)
                     
                     let normalText = "\n" + "testing"//descriptionEng[randomIndex]
                     let attrs2 = [NSAttributedStringKey.font : UIFont.systemFont(ofSize: 18)]
                     let normalString = NSMutableAttributedString(string:normalText, attributes:attrs2)
                     
                     attributedString.append(normalString)
                     headerLabel.attributedText = attributedString
                     headerLabel.sizeToFit()*/
                }
                
            }*/
            
            
            
            currentObjectId = objectId[randomIndex]
            isCurrentItemPlace = isPlace[randomIndex]
            currentImage.removeAll()
            currentImage.append(imageFile[randomIndex])
            
             let newDescription = NSString(string: descriptionEng[randomIndex])
             let components = newDescription.components(separatedBy: "Photo licensed under")
             if components.count == 2 {
                photoCredit.text = "Photo licensed under" + components[1]
                photoCredit.isHidden = false
                descriptionLabel.text = components[0]
             }
             else{
                photoCredit.isHidden = true
                descriptionLabel.text = descriptionEng[randomIndex]
             }
            
            descriptionLabel.isHidden = false
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()


            headerLabel.isHidden = false
            image.isHidden = false
            
            option1.remove(at: randomIndex)
            option2.remove(at: randomIndex)
            option3.remove(at: randomIndex)
            option4.remove(at: randomIndex)
            imageFile.remove(at: randomIndex)
            correctAnswer.remove(at: randomIndex)
            descriptionEng.remove(at: randomIndex)
            isPlace.remove(at: randomIndex)
            objectId.remove(at: randomIndex)

        }
        
        else {
            let placesQuery = PFQuery(className: "Places")
            
            placesQuery.limit = 1000
            placesQuery.findObjectsInBackground { (objects, error) in
                
                
                if let places = objects {
                    
                    for place in places {
                        
                        self.option1.append(place["alternative1"] as! String)
                        self.option2.append(place["alternative2"] as! String)
                        self.option3.append(place["alternative3"] as! String)
                        self.option4.append(place["alternative4"] as! String)
                        self.imageFile.append(place["imageFile"] as! PFFile)
                        self.correctAnswer.append(place["correctAlternative"] as! String)
                        self.descriptionEng.append(place["engDescription"] as! String)
                        self.isPlace.append(true)
                        if let question = place.objectId {
                            self.objectId.append(question)
                        }
                        
                    }
                }
                
                let foodsQuery = PFQuery(className: "Foods")
                
                foodsQuery.limit = 1000
                foodsQuery.findObjectsInBackground { (objects, error) in
                    
                    
                    if let foods = objects {
                        
                        for food in foods {
                            
                            self.option1.append(food["alternative1"] as! String)
                            self.option2.append(food["alternative2"] as! String)
                            self.option3.append(food["alternative3"] as! String)
                            self.option4.append(food["alternative4"] as! String)
                            self.imageFile.append(food["imageFile"] as! PFFile)
                            self.correctAnswer.append(food["correctAlternative"] as! String)
                            self.descriptionEng.append(food["engDescription"] as! String)
                            self.isPlace.append(false)
                            if let question = food.objectId {
                                self.objectId.append(question)
                            }
                        }
                    }
                    let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count)))
                    print("Random Index: \(randomIndex)")
                    
                    self.imageFile[randomIndex].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.image.image = imageToDisplay
                            }
                        }
                        
                    }
                    if let correctAnsInt = Int(self.correctAnswer[randomIndex]) {
                        
                        if correctAnsInt == 1 {
                            self.headerLabel.text = self.option1[randomIndex]
                        }
                        else if correctAnsInt == 2 {
                            self.headerLabel.text = self.option2[randomIndex]
                        }
                        else if correctAnsInt == 3 {
                            self.headerLabel.text = self.option3[randomIndex]
                        }
                        else if correctAnsInt == 4 {
                            self.headerLabel.text = self.option4[randomIndex]
                        }
                    }
                    self.currentObjectId = self.objectId[randomIndex]
                    self.isCurrentItemPlace = self.isPlace[randomIndex]
                    self.currentImage.removeAll()
                    self.currentImage.append(self.imageFile[randomIndex])
                    
                    let newDescription = NSString(string: self.descriptionEng[randomIndex])
                    let components = newDescription.components(separatedBy: "Photo licensed under")
                    if components.count == 2 {
                        self.photoCredit.text = "Photo licensed under" + components[1]
                        self.photoCredit.isHidden = false
                        self.descriptionLabel.text = components[0]
                    }
                    else{
                        self.photoCredit.isHidden = true
                        self.descriptionLabel.text = self.descriptionEng[randomIndex]
                    }
                    
                    self.descriptionLabel.isHidden = false
                    self.descriptionLabel.sizeToFit()
                    self.descriptionLabel.numberOfLines = 0
                    
                    self.headerLabel.isHidden = false
                    //self.image.isHidden = false
                    
                    self.option1.remove(at: randomIndex)
                    self.option2.remove(at: randomIndex)
                    self.option3.remove(at: randomIndex)
                    self.option4.remove(at: randomIndex)
                    self.imageFile.remove(at: randomIndex)
                    self.correctAnswer.remove(at: randomIndex)
                    self.descriptionEng.remove(at: randomIndex)
                    self.isPlace.remove(at: randomIndex)
                    self.objectId.remove(at: randomIndex)

                }
                
            }
            
        }
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        image.addGestureRecognizer(gesture)
    }
    
    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let imagePoint = gestureRecognizer.translation(in: view)
        image.center = CGPoint(x: view.bounds.width/2 + imagePoint.x, y: image.center.y)
        
        if gestureRecognizer.state == .ended {
            if image.center.x < (view.bounds.width/2 - 100) {
                
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.1)
                
                let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
                activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.shared.beginIgnoringInteractionEvents()

                
                if imageFile.count < 2 {
                    
                    let placesQuery = PFQuery(className: "Places")
                    
                    placesQuery.limit = 1000
                    placesQuery.findObjectsInBackground { (objects, error) in
                        
                        
                        if let places = objects {
                            
                            for place in places {
                                
                                self.option1.append(place["alternative1"] as! String)
                                self.option2.append(place["alternative2"] as! String)
                                self.option3.append(place["alternative3"] as! String)
                                self.option4.append(place["alternative4"] as! String)
                                self.imageFile.append(place["imageFile"] as! PFFile)
                                self.correctAnswer.append(place["correctAlternative"] as! String)
                                self.descriptionEng.append(place["engDescription"] as! String)
                                self.isPlace.append(true)
                                if let question = place.objectId {
                                    self.objectId.append(question)
                                }

                                
                            }
                        }
                        
                        let foodsQuery = PFQuery(className: "Foods")
                        
                        foodsQuery.limit = 1000
                        foodsQuery.findObjectsInBackground { (objects, error) in
                            
                            
                            if let foods = objects {
                                
                                for food in foods {
                                    
                                    self.option1.append(food["alternative1"] as! String)
                                    self.option2.append(food["alternative2"] as! String)
                                    self.option3.append(food["alternative3"] as! String)
                                    self.option4.append(food["alternative4"] as! String)
                                    self.imageFile.append(food["imageFile"] as! PFFile)
                                    self.correctAnswer.append(food["correctAlternative"] as! String)
                                    self.descriptionEng.append(food["engDescription"] as! String)
                                    self.isPlace.append(false)
                                    if let question = food.objectId {
                                        self.objectId.append(question)
                                    }

                                }
                            }
                            let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count)))
                            print("Random Index: \(randomIndex)")
                            
                            self.imageFile[randomIndex].getDataInBackground { (data, error) in
                                
                                if let imageData = data {
                                    
                                    if let imageToDisplay = UIImage(data: imageData) {
                                        
                                        self.image.image = imageToDisplay
                                    }
                                }
                                
                            }
                            if let correctAnsInt = Int(self.correctAnswer[randomIndex]) {
                                
                                if correctAnsInt == 1 {
                                    self.headerLabel.text = self.option1[randomIndex]
                                }
                                else if correctAnsInt == 2 {
                                    self.headerLabel.text = self.option2[randomIndex]
                                }
                                else if correctAnsInt == 3 {
                                    self.headerLabel.text = self.option3[randomIndex]
                                }
                                else if correctAnsInt == 4 {
                                    self.headerLabel.text = self.option4[randomIndex]
                                }
                            }
                            
                            activityIndicator.stopAnimating()
                            UIApplication.shared.endIgnoringInteractionEvents()
                            
                            self.currentObjectId = self.objectId[randomIndex]
                            self.isCurrentItemPlace = self.isPlace[randomIndex]
                            self.currentImage.removeAll()
                            self.currentImage.append(self.imageFile[randomIndex])

                            let newDescription = NSString(string: self.descriptionEng[randomIndex])
                            let components = newDescription.components(separatedBy: "Photo licensed under")
                            if components.count == 2 {
                                self.photoCredit.text = "Photo licensed under" + components[1]
                                self.photoCredit.isHidden = false
                                self.descriptionLabel.text = components[0]
                            }
                            else{
                                self.photoCredit.isHidden = true
                                self.descriptionLabel.text = self.descriptionEng[randomIndex]
                            }
                            self.descriptionLabel.isHidden = false
                            self.descriptionLabel.sizeToFit()
                            self.descriptionLabel.numberOfLines = 0
                            
                            self.headerLabel.isHidden = false
                            self.image.isHidden = false
                            
                            self.option1.remove(at: randomIndex)
                            self.option2.remove(at: randomIndex)
                            self.option3.remove(at: randomIndex)
                            self.option4.remove(at: randomIndex)
                            self.imageFile.remove(at: randomIndex)
                            self.correctAnswer.remove(at: randomIndex)
                            self.descriptionEng.remove(at: randomIndex)
                            self.isPlace.remove(at: randomIndex)
                            self.objectId.remove(at: randomIndex)

                        }
                    }
                }
                else {
                    
                    let randomIndex = Int(arc4random_uniform(UInt32(imageFile.count)))
                    print("Random Index: \(randomIndex)")
                    
                    imageFile[randomIndex].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.image.image = imageToDisplay
                                
                            }
                        }
                        
                    }
                    if let correctAnsInt = Int(correctAnswer[randomIndex]) {
                        
                        if correctAnsInt == 1 {
                            headerLabel.text = option1[randomIndex]
                        }
                        else if correctAnsInt == 2 {
                            headerLabel.text = option2[randomIndex]
                        }
                        else if correctAnsInt == 3 {
                            headerLabel.text = option3[randomIndex]
                        }
                        else if correctAnsInt == 4 {
                            headerLabel.text = option4[randomIndex]
                        }
                    }
                    activityIndicator.stopAnimating()
                    UIApplication.shared.endIgnoringInteractionEvents()
                    
                    currentObjectId = objectId[randomIndex]
                    isCurrentItemPlace = isPlace[randomIndex]
                    currentImage.removeAll()
                    currentImage.append(imageFile[randomIndex])

                    let newDescription = NSString(string: descriptionEng[randomIndex])
                    let components = newDescription.components(separatedBy: "Photo licensed under")
                    if components.count == 2 {
                        photoCredit.text = "Photo licensed under" + components[1]
                        photoCredit.isHidden = false
                        descriptionLabel.text = components[0]
                    }
                    else{
                        photoCredit.isHidden = true
                        descriptionLabel.text = descriptionEng[randomIndex]
                    }
                    descriptionLabel.isHidden = false
                    descriptionLabel.sizeToFit()
                    descriptionLabel.numberOfLines = 0
                    
                    headerLabel.isHidden = false
                    image.isHidden = false
                    
                    option1.remove(at: randomIndex)
                    option2.remove(at: randomIndex)
                    option3.remove(at: randomIndex)
                    option4.remove(at: randomIndex)
                    imageFile.remove(at: randomIndex)
                    correctAnswer.remove(at: randomIndex)
                    descriptionEng.remove(at: randomIndex)
                    isPlace.remove(at: randomIndex)
                    objectId.remove(at: randomIndex)
                    
                    
                }
                
                
                UIView.commitAnimations()
                
            }
            else {
                image.center = CGPoint(x: view.bounds.width/2, y: image.center.y)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "luckyStrikeBackSegue" {
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
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
