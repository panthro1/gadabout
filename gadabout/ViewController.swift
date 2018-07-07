//
//  ViewController.swift
//  gadabout
//
//  Created by Ahmet on 7.07.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse
import CoreData

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var enterPassLabel: UILabel!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    
    @IBOutlet weak var logIn: UIButton!
    
    var isEnglish = true
    
    func SaveLanguageSelection(English: Bool) {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLanguageSelection")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    result.setValue(English, forKey: "isEnglish")
                    
                    do {
                        try context.save()
                        print("Saved")
                    } catch {
                        print("There was error in Core Data save")
                    }
                    
                }
            }
            else {
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "Users", into: context)
                
                newUser.setValue(English, forKey: "isEnglish")
                
                do {
                    try context.save()
                    print("Saved")
                } catch {
                    print("There was error in Core Data save")
                }
            }
        } catch {
            
         // Catch code
            
        }
    }
    
    func SetLabelLanguages(English: Bool) {
        
        print("Set Label Languages: \(English)")
        
        if English {
            
            
            enterPassLabel.text = "Enter your email and password!"
            usernameTextField.placeholder = "Username"
            passwordTextField.placeholder = "Password"
            logIn.setTitle("Login", for: [])
            signIn.setTitle("Sign In", for: [])
            haveAnAccountLabel.text = "Do not have an account?"
            
        } else {
            print("inside else")
            
            
            enterPassLabel.text = "Email ve şifrenizi giriniz!"
            usernameTextField.placeholder = "Kullanıcı adı"
            passwordTextField.placeholder = "Şifre"
            logIn.setTitle("Giriş", for: [])
            signIn.setTitle("Kaydol", for: [])
            haveAnAccountLabel.text = "Kaydolmadınız mı?"
            
        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello World")
        
        let gameScore = PFObject(className:"GameScore")
        gameScore["score"] = 1337
        gameScore["playerName"] = "Sean Plott"
        gameScore["cheatMode"] = false
        gameScore.saveInBackground {
            (success: Bool, error: Error?) in
            if (success) {
                print("The object has been saved.")
            } else {
                print("There was a problem, check error.description")
            }
        }

    }
    
    
    @IBAction func SetTurkish(_ sender: Any) {
        
        SetLabelLanguages(English: isEnglish)
        SaveLanguageSelection(English: isEnglish)

    }
    
    
    @IBAction func SetEnglish(_ sender: Any) {
        
        isEnglish = true
        
        SetLabelLanguages(English: isEnglish)
        SaveLanguageSelection(English: isEnglish)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }



}

