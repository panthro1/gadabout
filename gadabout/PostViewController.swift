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
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    
    
    @IBAction func chooseImageTapped(_ sender: Any) {
        
        let imagePicker = UIImagePickerController()
        
        imagePicker.delegate = self
        
        imagePicker.sourceType = UIImagePickerControllerSourceType.photoLibrary
        
        imagePicker.allowsEditing = false
        
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            imageToPost.image = image
        }
        
        self.dismiss(animated: true, completion: nil)
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
        
        if let image = imageToPost.image {
            
            if placesSwitch.isOn {
                
                if !(foodSwitch.isOn) {
                
                    let post = PFObject(className: "Places")
                    
                    if (engDescription.text?.count)! > 0 {
                        
                        post["engDescription"] = engDescription.text
                        
                        if (trDescription.text?.count)! > 0 {
                            
                            post["trDescription"] = trDescription.text
                            
                            if (alternative1.text?.count)! > 0 {
                                
                                post["alternative1"] = alternative1.text
                                
                                if (alternative2.text?.count)! > 0 {
                                    
                                    post["alternative2"] = alternative2.text
                                    
                                    if (alternative3.text?.count)! > 0 {
                                        
                                        post["alternative3"] = alternative3.text
                                        
                                        if (alternative4.text?.count)! > 0 {
                                            
                                            post["alternative4"] = alternative4.text
                                            
                                            if (correctAlternative.text?.count)! > 0 {
                                                
                                                post["correctAlternative"] = correctAlternative.text
                                                
                                                if let imageData = UIImagePNGRepresentation(image) {
                                                    
                                                    let imageFile = PFFile(name: "image.png", data: imageData)
                                                    
                                                    post["imageFile"] = imageFile
                                                    
                                                    post.saveInBackground { (success, error) in
                                                        
                                                        if success {
                                                            
                                                            self.displayAlert(title: "Entity saved", message: "Entity saved successfully")
                                                            
                                                            self.alternative1.text = ""
                                                            
                                                            self.alternative2.text = ""
                                                            
                                                            self.alternative3.text = ""
                                                            
                                                            self.alternative4.text = ""
                                                            
                                                            self.imageToPost.image = nil
                                                            
                                                            self.engDescription.text = ""
                                                            
                                                            self.trDescription.text = ""
                                                            
                                                            self.correctAlternative.text = ""
                                                        }
                                                        else { // success
                                                            
                                                            self.displayAlert(title: "Could not saved", message: "Entity could not be saved")
                                                        }
                                                    }
                                                } // imageData
                                                else { // correct alternative
                                                    
                                                    self.displayAlert(title: "Eksik veri", message: "Correct alternative alanina veri giriniz")
                                                    
                                                }

                                            }

                                        }
                                        else { // alternative 4
                                            self.displayAlert(title: "Eksik veri", message: "Alternative 4 alanina veri giriniz")
                                        }
                                    }
                                    else { // alternative 3
                                        self.displayAlert(title: "Eksik veri", message: "Alternative 3 alanina veri giriniz")
                                    }
                                }
                                else { // alternative 2
                                    self.displayAlert(title: "Eksik veri", message: "Alternative 2 alanina veri giriniz")
                                }
                            }
                            else { // alternative 1
                                self.displayAlert(title: "Eksik veri", message: "Alternative 1 alanina veri giriniz")
                            }
                        }
                        else { // tr description
                            self.displayAlert(title: "Eksik veri", message: "Tr Description alanina veri giriniz")
                        }
                    }
                    else { // eng description
                        
                        self.displayAlert(title: "Eksik veri", message: "Eng Description alanina veri giriniz")
                        
                        print("Eng description alani bos")
                    }
                } // food switch
            } // places switch
            else {
                if foodSwitch.isOn {
                    
                    if !(placesSwitch.isOn) {
                        
                        let post = PFObject(className: "Foods")
                        
                        if (engDescription.text?.count)! > 0 {
                            
                            post["engDescription"] = engDescription.text
                            
                            if (trDescription.text?.count)! > 0 {
                                
                                post["trDescription"] = trDescription.text
                                
                                if (alternative1.text?.count)! > 0 {
                                    
                                    post["alternative1"] = alternative1.text
                                    
                                    if (alternative2.text?.count)! > 0 {
                                        
                                        post["alternative2"] = alternative2.text
                                        
                                        if (alternative3.text?.count)! > 0 {
                                            
                                            post["alternative3"] = alternative3.text
                                            
                                            if (alternative4.text?.count)! > 0 {
                                                
                                                post["alternative4"] = alternative4.text
                                                
                                                if (correctAlternative.text?.count)! > 0 {
                                                    
                                                    post["correctAlternative"] = correctAlternative.text
                                                    
                                                    if let imageData = UIImagePNGRepresentation(image) {
                                                        
                                                        let imageFile = PFFile(name: "image.png", data: imageData)
                                                        
                                                        post["imageFile"] = imageFile
                                                        
                                                        post.saveInBackground { (success, error) in
                                                            
                                                            if success {
                                                                
                                                                self.displayAlert(title: "Entity saved", message: "Entity saved successfully")
                                                                
                                                                self.alternative1.text = ""
                                                                
                                                                self.alternative2.text = ""
                                                                
                                                                self.alternative3.text = ""
                                                                
                                                                self.alternative4.text = ""
                                                                
                                                                self.imageToPost.image = nil
                                                                
                                                                self.engDescription.text = ""
                                                                
                                                                self.trDescription.text = ""
                                                                
                                                                self.correctAlternative.text = ""
                                                            }
                                                            else { // success
                                                                
                                                                self.displayAlert(title: "Could not saved", message: "Entity could not be saved")
                                                            }
                                                        }
                                                    } // imageData
                                                    else { // correct alternative
                                                        
                                                        self.displayAlert(title: "Eksik veri", message: "Correct alternative alanina veri giriniz")
                                                        
                                                    }
                                                    
                                                }
                                                
                                            }
                                            else { // alternative 4
                                                self.displayAlert(title: "Eksik veri", message: "Alternative 4 alanina veri giriniz")
                                            }
                                        }
                                        else { // alternative 3
                                            self.displayAlert(title: "Eksik veri", message: "Alternative 3 alanina veri giriniz")
                                        }
                                    }
                                    else { // alternative 2
                                        self.displayAlert(title: "Eksik veri", message: "Alternative 2 alanina veri giriniz")
                                    }
                                }
                                else { // alternative 1
                                    self.displayAlert(title: "Eksik veri", message: "Alternative 1 alanina veri giriniz")
                                }
                            }
                            else { // tr description
                                self.displayAlert(title: "Eksik veri", message: "Tr Description alanina veri giriniz")
                            }
                        }
                        else { // eng description
                            
                            self.displayAlert(title: "Eksik veri", message: "Eng Description alanina veri giriniz")
                            
                            print("Eng description alani bos")
                        }
                    } // places switch

                }
            }
        }
        else {
            self.displayAlert(title: "Eksik veri", message: "Image yukleyiniz")
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
