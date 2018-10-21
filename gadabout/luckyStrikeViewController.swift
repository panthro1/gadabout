//
//  luckyStrikeViewController.swift
//  gadabout
//
//  Created by Ahmet on 18.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse

class luckyStrikeViewController: UIViewController {
    
    
    var option1: String = ""
    var option2: String = ""
    var option3: String = ""
    var option4: String = ""
    var descriptionEng: String = ""
    var descriptionTr: String = ""
    var correctAnswer : String = ""
    var imageFile = [PFFile]()
    var totalInstances: Int32 = 0
    var nofPlaceInstances: Int32 = 0
    var nofFoodInstances: Int32 = 0
    var placeFoodSelection: UInt32 = 0

    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "luckyStrikeBackSegue", sender: self)
    }
    
    
    @IBAction func nextTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.shake()
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.nofPlaceInstances)))
        print("Random Index: \(randomIndex)")
        
        let placesQuery = PFQuery(className: "Places")
        
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
                    self.correctAnswer = place["correctAlternative"] as! String
                    self.descriptionEng = place["engDescription"] as! String
                    self.descriptionTr = place["trDescription"] as! String
                    
                }
            }
            
            self.imageFile[0].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        self.image.image = imageToDisplay
                        
                    }
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeFoodSelection = arc4random_uniform(2)
        
        print("Random Index: \(placeFoodSelection)")
        
        let nofInstancePlaceQuery = PFQuery(className: "Places")
        nofInstancePlaceQuery.countObjectsInBackground { (count, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.totalInstances = count
                self.nofPlaceInstances = count
                print("Total place instances: \(count)")
            }
            
            if self.placeFoodSelection == 0 {
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.totalInstances)))
                print("Random Index for Places: \(randomIndex)")
                
                let placesQuery = PFQuery(className: "Places")
                
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
                            self.correctAnswer = place["correctAlternative"] as! String
                            self.descriptionEng = place["engDescription"] as! String
                            self.descriptionTr = place["trDescription"] as! String
                            
                        }
                    }
                    
                    self.imageFile[0].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.image.image = imageToDisplay
                                
                            }
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
        }

        let nofInstanceFoodQuery = PFQuery(className: "Foods")
        nofInstanceFoodQuery.countObjectsInBackground { (count, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.totalInstances = count
                self.nofPlaceInstances = count
                print("Total place instances: \(count)")
            }
            
            if self.placeFoodSelection == 1 {
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.totalInstances)))
                print("Random Index for Foods: \(randomIndex)")
                
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
                            self.correctAnswer = place["correctAlternative"] as! String
                            self.descriptionEng = place["engDescription"] as! String
                            self.descriptionTr = place["trDescription"] as! String
                            
                        }
                    }
                    
                    self.imageFile[0].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.image.image = imageToDisplay
                                
                            }
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
        }

        
        
        
        
        let gesture = UIPanGestureRecognizer(target: self, action: #selector(wasDragged(gestureRecognizer:)))
        image.addGestureRecognizer(gesture)
    }

    @objc func wasDragged(gestureRecognizer: UIPanGestureRecognizer) {
        let imagePoint = gestureRecognizer.translation(in: view)
        image.center = CGPoint(x: view.bounds.width/2 + imagePoint.x, y: image.center.y)
        
        if gestureRecognizer.state == .ended {
            if image.center.x < (view.bounds.width/2 - 100) {
                print("Next Image")
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.nofPlaceInstances)))
                print("Random Index: \(randomIndex)")
                
                let placesQuery = PFQuery(className: "Places")
                
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
                            self.correctAnswer = place["correctAlternative"] as! String
                            self.descriptionEng = place["engDescription"] as! String
                            self.descriptionTr = place["trDescription"] as! String
                            
                        }
                    }
                    
                    self.imageFile[0].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.image.image = imageToDisplay
                                
                            }
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
                    self.image.center = CGPoint(x: self.view.bounds.width/2, y: self.image.center.y)
                }
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
