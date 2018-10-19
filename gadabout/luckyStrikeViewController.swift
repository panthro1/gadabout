//
//  luckyStrikeViewController.swift
//  gadabout
//
//  Created by Ahmet on 18.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

class luckyStrikeViewController: UIViewController {
    
    
    var option1: String = ""
    var option2: String = ""
    var option3: String = ""
    var option4: String = ""
    var descriptionEng: String = ""
    var descriptionTr: String = ""
    var correctAnswer : String = ""
    var imageFile: PFFile

    
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var headerLabel: UILabel!
    
    @IBOutlet weak var descriptionText: UITextView!
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "luckyStrikeBackSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        let placesQuery = PFQuery(className: "Places")
        
        //print("After....")
        //print("++++++\(self.questionSeenBefore),  \(self.questionSeenBefore.count)")
        
        placesQuery.limit = 2
        placesQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
        
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
                    self.descriptionTr.append(place["trDescription"] as! String)
                    
                    
                    if let question = place.objectId {
                        self.questionCompleted.append(question)
                    }
                }
            }
            
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
