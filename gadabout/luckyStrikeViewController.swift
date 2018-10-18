//
//  luckyStrikeViewController.swift
//  gadabout
//
//  Created by Ahmet on 18.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

class luckyStrikeViewController: UIViewController {

    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "luckyStrikeBackSegue", sender: self)
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
