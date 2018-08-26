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


class MainPageViewController: UIViewController {
    
    var isEnglish = true
    
    @IBOutlet weak var logout: UIBarButtonItem!
    
    
    @IBOutlet weak var places: UIButton!
    
    
    
    @IBAction func postTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "postSegue", sender: self)
    }
    
    @IBAction func placesTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "placesSegue", sender: self)
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        PFUser.logOut()
        
        performSegue(withIdentifier: "logoutSegue", sender: self)

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
        
        super.viewDidLoad()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appDelegate.persistentContainer.viewContext
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "UserLanguageSelection")
        
        request.returnsObjectsAsFaults = false
        
        do {
            let results = try context.fetch(request)
            
            if results.count > 0 {
                
                for result in results as! [NSManagedObject] {
                    
                    if let isEnglishBool = result.value(forKey: "isEnglish") as? Bool {
                        isEnglish = isEnglishBool
                        print("After login isEnglish: \(isEnglish)")
                        
                    }
                }
            }
            else {
                print("No results")
            }
        } catch {
            
            print("Couldn't fetch the results")
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(isRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        if places.imageView != nil {
            
            places.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (places.imageView?.frame.width)!)
            places.imageEdgeInsets = UIEdgeInsets(top: 5, left: places.frame.width - 100, bottom: 5, right: 0)
        }


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
