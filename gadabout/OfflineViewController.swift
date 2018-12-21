//
//  OfflineViewController.swift
//  gadabout
//
//  Created by Ahmet on 21.12.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

class OfflineViewController: UIViewController {
    
    let network = NetworkManager.sharedInstance

    override func viewDidLoad() {
        super.viewDidLoad()
        
        network.reachability.whenReachable = { [unowned self]_ in
            
            print("ONLINE AGAIN")
        }

        // Do any additional setup after loading the view.
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
