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



class MainPageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var isEnglish = true

    @IBOutlet weak var logout: UIBarButtonItem!
    
    @IBOutlet weak var mainPageTableView: UITableView!
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        /*PFUser.logOutInBackground { (error) in
            
            if error != nil {
                print("logout fail")
                print(error) }
            else {
                print("logout success")
            }
        }*/
        
        PFUser.logOut()
        
        //dismiss(animated: true, completion: nil)

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
        
        //super.viewDidLoad()
        
        self.mainPageTableView.delegate = self
        self.mainPageTableView.dataSource = self
        self.mainPageTableView.allowsSelection = true
        
        self.mainPageTableView.rowHeight = 100

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
        
        /*if places.imageView != nil {
            
            places.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (places.imageView?.frame.width)!)
            places.imageEdgeInsets = UIEdgeInsets(top: 5, left: places.frame.width - 100, bottom: 5, right: 0)
        }*/


        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 6
        
    }

    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "mainPageCell")
        
        cell.textLabel?.font = UIFont(name: "Avenir", size: 32)
        
        if indexPath.row == 0 {
            cell.textLabel?.text = "    Places"
        }
        else if indexPath.row == 1 {
            cell.textLabel?.text = "    Foods"
        }
        else if indexPath.row == 2 {
            cell.textLabel?.text = "    Puzzle"
        }
        else if indexPath.row == 5 {
            cell.textLabel?.text = "    Post"
        }
        else if indexPath.row == 4 {
            cell.textLabel?.text = "    To Do List"
        }
        else if indexPath.row == 3 {
            cell.textLabel?.text = "    Lucky Strike"
        }
        
        return cell
    }

    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row == 0 {
            print("Places selected")
            performSegue(withIdentifier: "placesSegue", sender: self)
        }
        else if indexPath.row == 1 {
            print("Food selected")
            performSegue(withIdentifier: "foodsSegue", sender: self)
        }
        else if indexPath.row == 2 {
            print("Map puzzle selected")
            performSegue(withIdentifier: "puzzleMapSegue", sender: self)

        }
        else if indexPath.row == 5 {
            print("Post selected")
            performSegue(withIdentifier: "postSegue", sender: self)
        }
        else if indexPath.row == 4 {
            print("To Do List selected")
            performSegue(withIdentifier: "toDoListSegue", sender: self)
        }
        else if indexPath.row == 3 {
            print("Lucky Strike selected")
            performSegue(withIdentifier: "luckyStrikeSegue", sender: self)
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
