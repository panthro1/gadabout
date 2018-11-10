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
    
    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var nextButton: UIButton!
    
    @IBOutlet weak var toDoListButton: UIButton!
    
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
        
        let itemsObjectDescription = UserDefaults.standard.object(forKey: "toDoItemDescription")
        
        let itemsObjectName = UserDefaults.standard.object(forKey: "toDoItem")
        
        var itemsDescription = [String]()
        
        var itemsName = [String]()
        
        if let tempItemsDescription = itemsObjectDescription {
            if let tempItemsName = itemsObjectName {
                itemsDescription = tempItemsDescription as! [String]
                itemsName = tempItemsName as! [String]
                
                if let descText = descriptionText.text {
                    if let nameText = headerLabel.text {
                        itemsDescription.append(descText)
                        itemsName.append(nameText)
                    }
                }
            }
            else {
                
                if let descText = descriptionText.text {
                    if let nameText = headerLabel.text {
                        itemsDescription.append(descText)
                        itemsName.append(nameText)
                    }
                }
            }
            
        }
        else {
            if let descText = descriptionText.text {
                if let nameText = headerLabel.text {
                    itemsDescription.append(descText)
                    itemsName.append(nameText)
                }
            }
        }
        print("itemsName : \(itemsName)")
        print("itemsDescription: \(itemsDescription)")
        
        UserDefaults.standard.set(itemsName, forKey: "toDoItem")
        UserDefaults.standard.set(itemsDescription, forKey: "toDoItemDescription")
        
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.shake()
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        /*placeFoodSelection = arc4random_uniform(2)
         print("Random Index: \(placeFoodSelection)")
         
         if placeFoodSelection == 0 {
         
         let placesQuery = PFQuery(className: "Places")
         
         placesQuery.limit = 1000
         self.imageFile.removeAll()
         
         placesQuery.findObjectsInBackground { (objects, error) in
         
         
         if let places = objects {
         
         for place in places {
         
         self.option1 = place["alternative1"] as! String
         self.option2 = place["alternative2"] as! String
         self.option3 = place["alternative3"] as! String
         self.option4 = place["alternative4"] as! String
         self.imageFile.append(place["imageFile"] as! PFFile)
         
         self.imageFile[0].getDataInBackground { (data, error) in
         
         if let imageData = data {
         
         if let imageToDisplay = UIImage(data: imageData) {
         
         self.image.image = imageToDisplay
         }
         }
         
         }
         
         activityIndicator.stopAnimating()
         UIApplication.shared.endIgnoringInteractionEvents()
         
         self.correctAnswer = place["correctAlternative"] as! String
         self.descriptionEng = place["engDescription"] as! String
         self.descriptionTr = place["trDescription"] as! String
         
         }
         }
         
         if let correctAnsInt = Int(self.correctAnswer) {
         
         if correctAnsInt == 1 {
         self.headerLabel.text = self.option1
         }
         else if correctAnsInt == 2 {
         self.headerLabel.text = self.option2
         }
         else if correctAnsInt == 3 {
         self.headerLabel.text = self.option3
         }
         else if correctAnsInt == 4 {
         self.headerLabel.text = self.option4
         }
         }
         self.descriptionText.text = self.descriptionEng
         self.descriptionText.isHidden = false
         self.headerLabel.isHidden = false
         self.image.isHidden = false
         }
         }
         else {
         let randomIndex = Int(arc4random_uniform(UInt32(self.nofFoodInstances)))
         print("Random Index: \(randomIndex)")
         
         let placesQuery = PFQuery(className: "Foods")
         
         placesQuery.limit = 1
         placesQuery.skip = randomIndex
         self.imageFile.removeAll()
         
         placesQuery.findObjectsInBackground { (objects, error) in
         
         
         if let places = objects {
         
         for place in places {
         
         self.option1 = place["alternative1"] as! String
         self.option2 = place["alternative2"] as! String
         self.option3 = place["alternative3"] as! String
         self.option4 = place["alternative4"] as! String
         self.imageFile.append(place["imageFile"] as! PFFile)
         
         self.imageFile[0].getDataInBackground { (data, error) in
         
         if let imageData = data {
         
         if let imageToDisplay = UIImage(data: imageData) {
         
         self.image.image = imageToDisplay
         
         }
         }
         }
         activityIndicator.stopAnimating()
         UIApplication.shared.endIgnoringInteractionEvents()
         
         self.correctAnswer = place["correctAlternative"] as! String
         self.descriptionEng = place["engDescription"] as! String
         self.descriptionTr = place["trDescription"] as! String
         
         }
         }
         
         if let correctAnsInt = Int(self.correctAnswer) {
         
         if correctAnsInt == 1 {
         self.headerLabel.text = self.option1
         }
         else if correctAnsInt == 2 {
         self.headerLabel.text = self.option2
         }
         else if correctAnsInt == 3 {
         self.headerLabel.text = self.option3
         }
         else if correctAnsInt == 4 {
         self.headerLabel.text = self.option4
         }
         }
         self.descriptionText.text = self.descriptionEng
         self.descriptionText.isHidden = false
         self.headerLabel.isHidden = false
         self.image.isHidden = false
         }
         
         }*/
        
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
                        }
                    }
                }
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count - 1)))
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
                
                self.descriptionText.text = self.descriptionEng[randomIndex]
                self.descriptionText.isHidden = false
                self.headerLabel.isHidden = false
                self.image.isHidden = false
                
                self.option1.remove(at: randomIndex)
                self.option2.remove(at: randomIndex)
                self.option3.remove(at: randomIndex)
                self.option4.remove(at: randomIndex)
                self.imageFile.remove(at: randomIndex)
                self.correctAnswer.remove(at: randomIndex)
                self.descriptionEng.remove(at: randomIndex)
            }
        }
        else {
            
            let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count - 1)))
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
            
            
            self.descriptionText.text = self.descriptionEng[randomIndex]
            self.descriptionText.isHidden = false
            self.headerLabel.isHidden = false
            self.image.isHidden = false
            
            self.option1.remove(at: randomIndex)
            self.option2.remove(at: randomIndex)
            self.option3.remove(at: randomIndex)
            self.option4.remove(at: randomIndex)
            self.imageFile.remove(at: randomIndex)
            self.correctAnswer.remove(at: randomIndex)
            self.descriptionEng.remove(at: randomIndex)
            
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        nextButton.backgroundColor = .clear
        nextButton.layer.cornerRadius = 5
        nextButton.layer.borderWidth = 1
        nextButton.layer.borderColor = UIColor.black.cgColor
        
        toDoListButton.layer.cornerRadius = 5
        toDoListButton.layer.borderWidth = 1
        toDoListButton.layer.borderColor = UIColor.black.cgColor
        
        
        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())
        
        
        // New code starts from here
        
        for indx in 0 ..< glbImageFile.count {
            
            self.option1.append(glbOption1[indx])
            self.option2.append(glbOption2[indx])
            self.option3.append(glbOption3[indx])
            self.option4.append(glbOption4[indx])
            self.imageFile.append(glbImageFile[indx])
            self.correctAnswer.append(glbCorrectAnswer[indx])
            self.descriptionEng.append(glbDescriptionEng[indx])
            
            let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count - 1)))
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
            self.descriptionText.text = self.descriptionEng[randomIndex]
            self.descriptionText.isHidden = false
            self.headerLabel.isHidden = false
            self.image.isHidden = false
            
            self.option1.remove(at: randomIndex)
            self.option2.remove(at: randomIndex)
            self.option3.remove(at: randomIndex)
            self.option4.remove(at: randomIndex)
            self.imageFile.remove(at: randomIndex)
            self.correctAnswer.remove(at: randomIndex)
            self.descriptionEng.remove(at: randomIndex)

        }
        
        if glbImageFile.count < 5 {
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
                        }
                    }
                }
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count - 1)))
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
                self.descriptionText.text = self.descriptionEng[randomIndex]
                self.descriptionText.isHidden = false
                self.headerLabel.isHidden = false
                self.image.isHidden = false
                
                self.option1.remove(at: randomIndex)
                self.option2.remove(at: randomIndex)
                self.option3.remove(at: randomIndex)
                self.option4.remove(at: randomIndex)
                self.imageFile.remove(at: randomIndex)
                self.correctAnswer.remove(at: randomIndex)
                self.descriptionEng.remove(at: randomIndex)
                
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
                                }
                            }
                        }
                        
                        let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count - 1)))
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
                        
                        self.descriptionText.text = self.descriptionEng[randomIndex]
                        self.descriptionText.isHidden = false
                        self.headerLabel.isHidden = false
                        self.image.isHidden = false
                        
                        self.option1.remove(at: randomIndex)
                        self.option2.remove(at: randomIndex)
                        self.option3.remove(at: randomIndex)
                        self.option4.remove(at: randomIndex)
                        self.imageFile.remove(at: randomIndex)
                        self.correctAnswer.remove(at: randomIndex)
                        self.descriptionEng.remove(at: randomIndex)
                        
                        
                    }
                }
                else {
                    
                    let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count - 1)))
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
                    
                    
                    self.descriptionText.text = self.descriptionEng[randomIndex]
                    self.descriptionText.isHidden = false
                    self.headerLabel.isHidden = false
                    self.image.isHidden = false
                    
                    self.option1.remove(at: randomIndex)
                    self.option2.remove(at: randomIndex)
                    self.option3.remove(at: randomIndex)
                    self.option4.remove(at: randomIndex)
                    self.imageFile.remove(at: randomIndex)
                    self.correctAnswer.remove(at: randomIndex)
                    self.descriptionEng.remove(at: randomIndex)
                    
                    
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
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
