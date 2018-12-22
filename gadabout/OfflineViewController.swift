//
//  OfflineViewController.swift
//  gadabout
//
//  Created by Ahmet on 21.12.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Reachability

class OfflineViewController: UIViewController {
    let reachability = Reachability()!

    override func viewDidLoad() {
        super.viewDidLoad()
        print("Inside Offline View Controller")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        AppDelegate.AppUtility.lockOrientation(.portrait)
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do{
            try reachability.startNotifier()
        }catch{
            print("could not start reachability notifier")
        }
    }
    
    @objc func reachabilityChanged(note: Notification) {
        
        let reachability = note.object as! Reachability
        
        switch reachability.connection {
        case .wifi:
            print("Reachable via WiFi")
            self.performSegue(withIdentifier: "backToOnlineSegue", sender: self)
            
        case .cellular:
            print("Reachable via Cellular")
            self.performSegue(withIdentifier: "backToOnlineSegue", sender: self)
        case .none:
            print("Network not reachable")
            
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
