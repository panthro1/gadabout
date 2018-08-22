//
//  PlacesTableViewController.swift
//  gadabout
//
//  Created by Ahmet on 22.07.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse



class PlacesTableViewController: UITableViewController, placesTableViewCellDelegate {
    
    
    var option1 = [String]()
    var option2 = [String]()
    var option3 = [String]()
    var option4 = [String]()
    var correctAnswer = [String]()
    var imageFile = [PFFile]()
    
    var answer:[Int] = []
    var questionNo:[Int] = []
    

    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "placesBackSegue", sender: self)

    }
    
    @IBOutlet weak var complete: UIBarButtonItem!
    
    @IBAction func didCompleteTapped(_ sender: Any) {
        
        let rowToSelect: IndexPath = IndexPath(row: 1, section: 1)

        
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesIdentifier", for: rowToSelect) as! PlacesTableViewCell
        cell.delegate = self
        
        cell.markOption1.setImage(UIImage(named: "wrong.gif"), for: [])
        print("TEST!!!!!")
        
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.tableView.rowHeight = 220

        let placesQuery = PFQuery(className: "Places")
        
        placesQuery.findObjectsInBackground { (objects, error) in
            
            if let places = objects {
                
                for place in places {
                    
                    self.option1.append(place["alternative1"] as! String)
                    self.option2.append(place["alternative2"] as! String)
                    self.option3.append(place["alternative3"] as! String)
                    self.option4.append(place["alternative4"] as! String)
                    self.imageFile.append(place["imageFile"] as! PFFile)
                    self.correctAnswer.append(place["correctAlternative"] as! String)

                    self.tableView.reloadData()
                    
                }
            }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return option1.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placesIdentifier", for: indexPath) as! PlacesTableViewCell
        cell.delegate = self
        
        
        imageFile[indexPath.row].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    cell.placeImage.image = imageToDisplay
                    
                }
            }
            
        }
        
        cell.option1.text = option1[indexPath.row]
        cell.option2.text = option2[indexPath.row]
        cell.option3.text = option3[indexPath.row]
        cell.option4.text = option4[indexPath.row]

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        print("Hell Yeah")


    }
    
    func didAlternativeSelected(sender: PlacesTableViewCell, selectedIndex: Int){
        let tappedIndexPath = tableView.indexPath(for: sender)
        
        if let selectedQuestion = tappedIndexPath?.row {
            questionNo.append(selectedQuestion)
        }
        
        answer.append(selectedIndex)
        
        print(questionNo)
        print(answer)
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
