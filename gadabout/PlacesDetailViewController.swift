//
//  PlacesDetailViewController.swift
//  gadabout
//
//  Created by Ahmet on 1.09.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

class PlacesDetailViewController: UIViewController {

    
    @IBOutlet weak var back: UIBarButtonItem!
    
    
    @IBOutlet weak var placeDetailTextView: UITextView!
    
    var detailText: String = ""
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "placesDetailBackSegue", sender: self)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        placeDetailTextView.text = detailText
        
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
