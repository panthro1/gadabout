//
//  PostViewController.swift
//  gadabout
//
//  Created by Ahmet on 22.07.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse


class PostViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var imageToPost: UIImageView!
    
    @IBOutlet weak var engDescription: UITextField!
    
    @IBOutlet weak var trDescription: UITextField!
    
    @IBOutlet weak var alternative1: UITextField!
    
    @IBOutlet weak var alternative2: UITextField!
    
    @IBOutlet weak var alternative3: UITextField!
    
    @IBOutlet weak var alternative4: UITextField!
    
    @IBOutlet weak var correctAlternative: UITextField!
    
    @IBOutlet weak var placesSwitch: UISwitch!
    
    @IBOutlet weak var foodSwitch: UISwitch!
    
    
    @IBAction func chooseImageTapped(_ sender: Any) {
    }
    
    
    @IBAction func postTapped(_ sender: Any) {
        
        if placesSwitch.isOn {
            print("Places switch is on")
        }
        else {
            print("Places switch is off")
        }
        
        if foodSwitch.isOn {
            print("Food switch is on")
        }
        else {
            print("Food switch is off")
        }
    }
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "postBackSegue", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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
