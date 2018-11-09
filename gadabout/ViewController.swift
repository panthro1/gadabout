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
import GoogleMobileAds

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var welcomeLabel: UILabel!
    
    @IBOutlet weak var enterPassLabel: UILabel!

    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var signIn: UIButton!
    
    @IBOutlet weak var haveAnAccountLabel: UILabel!
    
    @IBOutlet weak var logIn: UIButton!
    
    var interstitial: GADInterstitial!

        
    var isEnglish = true
    
    var oldUserID = ""
    var isAnonymous = true
    
    
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
                let newUser = NSEntityDescription.insertNewObject(forEntityName: "UserLanguageSelection", into: context)
                
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
        
        
        if English {
            
            
            enterPassLabel.text = "Enter your email and password!"
            usernameTextField.placeholder = "Email"
            passwordTextField.placeholder = "Password"
            logIn.setTitle("Login", for: [])
            signIn.setTitle("Sign Up", for: [])
            haveAnAccountLabel.text = "Do not have an account?"
            welcomeLabel.text = "Welcome to Gadabout"
            
        } else {
            
            enterPassLabel.text = "Email ve şifrenizi giriniz!"
            usernameTextField.placeholder = "Email"
            passwordTextField.placeholder = "Şifre"
            logIn.setTitle("Giriş", for: [])
            signIn.setTitle("Kaydol", for: [])
            haveAnAccountLabel.text = "Kaydolmadınız mı?"
            welcomeLabel.text = "Gadabout'a Hoşgeldiniz"

        }
    }


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)
        
        // Do any additional setup after loading the view, typically from a nib.
        print("Hello World")
        
        signIn.backgroundColor = .clear
        signIn.layer.cornerRadius = 5
        signIn.layer.borderWidth = 1
        signIn.layer.borderColor = UIColor.black.cgColor
        
        logIn.layer.cornerRadius = 5
        logIn.layer.borderWidth = 1
        logIn.layer.borderColor = UIColor.black.cgColor

        self.view.backgroundColor = UIColor.white
        
        self.showAnimate()
        
        if let userID = PFUser.current()?.objectId {
            oldUserID = userID
        }
        else {
            oldUserID = ""
        }
        
        if PFUser.current()?.email != nil {
            isAnonymous = false
        }
        else {
            isAnonymous = true
        }

        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLanguageSelection")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let isEnglishBool = result.value(forKey: "isEnglish") as? Bool {
                        SetLabelLanguages(English: isEnglishBool)
                        isEnglish = isEnglishBool
                        
                    }
                    /*context.delete(result)
                     
                     do {
                     try context.save()
                     print("Saved")
                     } catch {
                     print("There was error in Core Data save")
                     }*/
                    
                }
            }
            else {
                print("No results")
            }
        } catch {
            
            print("Couldn't fetch the results")
        }
        

        
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
    
        
        /*if  PFUser.current() != nil {
            
            print("viewDidAppear")
            
            performSegue(withIdentifier: "loginSegue", sender: self)
            
        }
        else {
            PFAnonymousUtils.logIn { (user, error) in
                if error != nil || user == nil {
                    print("Anonymous login failed")
                }
                else {
                    print("Anoymous user logged in")
                    self.performSegue(withIdentifier: "loginSegue", sender: self)
                }
            }
        }*/
    }
    
    @IBAction func SignInButtonTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.pulsate()
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        print("Signing up...")
        
        let user = PFUser()
        
        user.username = usernameTextField.text
        user.password = passwordTextField.text
        user.email = usernameTextField.text
        
        user.signUpInBackground { (success, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            if let error = error {
                
                self.displayAlert(title: "Could not sign you up", message: error.localizedDescription)

            }
            else {
                
                print("signed up")
                
                let userScoreQuery = PFQuery(className: "UserScore")
                userScoreQuery.whereKey("userId", equalTo: self.oldUserID)
                userScoreQuery.findObjectsInBackground { (objects, error) in
                    if let score = objects?.first {
                        score["userId"] = PFUser.current()?.objectId
                        score.saveInBackground()
                    }
                    else {
                        let userScoreData = PFObject(className: "UserScore")
                        userScoreData["userId"] = PFUser.current()?.objectId
                        userScoreData["score"] = String(0)
                        userScoreData.saveInBackground(block: { (success, error) in
                            
                            if success {
                                print("User score is initialized")
                            }
                            else {
                                print("User score COULD NOT be initialized")
                            }
                            
                        })
                        
                    }
                    
                }
                
                print("Current user after login: \(PFUser.current()?.objectId)")
                self.removeAnimate()

                //self.performSegue(withIdentifier: "loginSegue", sender: self)
            }
        }
        


        
    }
    
    
    @IBAction func LoginButtonTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.pulsate()
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()
        
        PFUser.logInWithUsername(inBackground: usernameTextField.text!, password: passwordTextField.text!) { (user, error) in
            
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
            
            var errorText = "Unknown error: Please try again"
            
            if error != nil {
                
                if let err = error {
                    let errorText = err.localizedDescription
                    print(errorText)
                    self.displayAlert(title: "Could not log in", message: errorText)
                    
                }
            }
            else {
                if user != nil
                {
                    //self.performSegue(withIdentifier: "loginSegue", sender: self)
                    
                    if self.isAnonymous == true {
                        let questionCoveredQuery = PFQuery(className: "placesCoveredBefore")
                        questionCoveredQuery.whereKey("userId", equalTo: self.oldUserID)
                        questionCoveredQuery.findObjectsInBackground { (objects, error) in
                            
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            else {
                                if let places = objects {
                                    for place in places {
                                        place["userId"] = PFUser.current()?.objectId
                                        place.saveInBackground()
                                    }
                                }
                            }
                        }
                        
                        let foodsCoveredQuery = PFQuery(className: "foodsCoveredBefore")
                        foodsCoveredQuery.whereKey("userId", equalTo: self.oldUserID)
                        foodsCoveredQuery.findObjectsInBackground { (objects, error) in
                            
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            else {
                                if let foods = objects {
                                    for food in foods {
                                        food["userId"] = PFUser.current()?.objectId
                                        food.saveInBackground()
                                    }
                                }
                            }
                        }
                        
                        let userScoreQuery = PFQuery(className: "UserScore")
                        userScoreQuery.whereKey("userId", equalTo: self.oldUserID)
                        userScoreQuery.findObjectsInBackground { (objects, error) in
                            if let score = objects?.first {
                                    score["userId"] = PFUser.current()?.objectId
                                    score.saveInBackground()
                            }
                        }

                    }

                    print("Current user after login: \(PFUser.current()?.objectId)")
                    self.removeAnimate()
                }
                else {
                
                    if let error = error {
                    
                        errorText = error.localizedDescription
                    
                    }
                    self.displayAlert(title: "Could not log in", message: errorText)
                }
            }
            
        }

        
    }
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        /*alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            self.dismiss(animated: true, completion: nil)
        }))*/

        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))

        self.present(alert, animated: true, completion: nil)
        
    }

    
    
    @IBAction func SetTurkish(_ sender: Any) {
        isEnglish = false
        
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

    func showAnimate() {
        
        self.view.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
        self.view.alpha = 0.0
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
    }
    
    func removeAnimate() {
        UIView.animate(withDuration: 0.25) {
            self.view.alpha = 1.0
            self.view.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
        }
        self.view.removeFromSuperview()
    }


}

