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
    var descriptionEng = [String]()
    var descriptionTr = [String]()
    var correctAnswer = [String]()
    var imageFile = [PFFile]()
    var imageArr = [UIImage]()
    var showDetail = [Bool]()
    
    var detailCellRow: Int = 0
    
    var answer:[Int] = []
    var questionNo:[Int] = []
    
    var isCompleted = false
    var status: Int = -1
    var selected: Int = -1
    var mustBeSelected: Int = -1
    
    var detailText: String = ""
    

    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backTapped(_ sender: Any) {
        performSegue(withIdentifier: "placesBackSegue", sender: self)

    }
    
    @IBOutlet weak var complete: UIBarButtonItem!

    
    
    @IBAction func didCompleteTapped(_ sender: Any) {
        
        let sectionNo = 0
        
        if isCompleted == false {
            isCompleted = true
            let nofQuestions = questionNo.count


            for rowNo in 0...nofQuestions-1 {
                
                let rowToSelect: IndexPath = IndexPath(row: rowNo, section: sectionNo)
                self.tableView.reloadRows(at: [rowToSelect], with: .fade)
            }
        }
        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.tableView.rowHeight = 380
        

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
                    self.descriptionEng.append(place["engDescription"] as! String)
                    self.descriptionTr.append(place["trDescription"] as! String)
                    self.showDetail.append(false)
                    
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
        
        //print("Row: \(indexPath.row) showDetail: \(showDetail) Completed: \(isCompleted)")
        
        if (showDetail[indexPath.row] == true)/* && (detailCellRow == indexPath.row)*/ {

            //cell.placeImage.isHidden = true
            cell.option1.isHidden = true
            cell.option2.isHidden = true
            cell.option3.isHidden = true
            cell.option4.isHidden = true
            cell.markOption1.isHidden = true
            cell.markOption2.isHidden = true
            cell.markOption3.isHidden = true
            cell.markOption4.isHidden = true
            cell.detailsButton.isHidden = false
            cell.detailsButton.setTitle("Back", for: [])
            
            cell.detailTextInfo.isHidden = false
            cell.detailTextInfo.text = descriptionEng[indexPath.row]

            imageFile[indexPath.row].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        cell.placeImage.image = imageToDisplay
                        
                    }
                }
            }


        }
        else {
            
            cell.detailsButton.setTitle("Details", for: [])
            imageFile[indexPath.row].getDataInBackground { (data, error) in
            
                if let imageData = data {
                
                    if let imageToDisplay = UIImage(data: imageData) {
                    
                        cell.placeImage.image = imageToDisplay
                    
                    }
                }
            
            }
            
            cell.option1.isHidden = false
            cell.option2.isHidden = false
            cell.option3.isHidden = false
            cell.option4.isHidden = false
            cell.markOption1.isHidden = false
            cell.markOption2.isHidden = false
            cell.markOption3.isHidden = false
            cell.markOption4.isHidden = false
        
            cell.detailTextInfo.isHidden = true
            cell.option1.text = option1[indexPath.row]
            cell.option2.text = option2[indexPath.row]
            cell.option3.text = option3[indexPath.row]
            cell.option4.text = option4[indexPath.row]
        
            cell.detailsButton.isHidden = true
        
            if (isCompleted == true) {
                

                cell.detailsButton.isHidden = false
            
                cell.markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
                cell.markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
                cell.markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
                cell.markOption4.setImage(UIImage(named: "uncheck.png"), for: [])
            
                cell.markOption1.isEnabled = false
                cell.markOption2.isEnabled = false
                cell.markOption3.isEnabled = false
                cell.markOption4.isEnabled = false
            
                let questionIndex = questionNo.index(of: indexPath.row)
            
                if let correctAnsInt = Int(correctAnswer[indexPath.row]) {
                    let correctAnswerInt = correctAnsInt
                    mustBeSelected = correctAnswerInt
                    if let qIndex = questionIndex {
                        selected = answer[qIndex]
                        if answer[qIndex] == correctAnswerInt {
                            status = 1 // correct answer
                        }
                        else {
                            status = 0 // wrong answer
             
                        }
                    }
                    else {
                        status = 0 // wrong answer
                    }
                }
                else {
                    status = -1 // no valid string
                }

                if status == 1 {

                    if selected == 1 {

                        cell.markOption1.setImage(UIImage(named: "correct.png"), for: [])

                    }
                    else if selected == 2 {

                        cell.markOption2.setImage(UIImage(named: "correct.png"), for: [])

                    }
                    else if selected == 3 {

                        cell.markOption3.setImage(UIImage(named: "correct.png"), for: [])

                    }
                    else if selected == 4 {

                        cell.markOption4.setImage(UIImage(named: "correct.png"), for: [])

                    }
                
                }
                else if status == 0 {

                    if selected == 1 {
                    
                        cell.markOption1.setImage(UIImage(named: "wrong.gif"), for: [])
                    
                    }
                    else if selected == 2 {
                    
                        cell.markOption2.setImage(UIImage(named: "wrong.gif"), for: [])
                    
                    }
                    else if selected == 3 {
                    
                        cell.markOption3.setImage(UIImage(named: "wrong.gif"), for: [])
                    
                    }
                    else if selected == 4 {
                    
                        cell.markOption4.setImage(UIImage(named: "wrong.gif"), for: [])
                    
                    }
                }
                else {
                    print("Unexpected")
                
                }
            }
        }

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

    }
    
    func isDetailButtonTapped(sender: PlacesTableViewCell) {
        
        
        /*let tappedIndexPath = tableView.indexPath(for: sender)
        
        if let selectedQuestion = tappedIndexPath?.row {
            if self.descriptionEng[selectedQuestion].count > 0 {
                detailText = self.descriptionEng[selectedQuestion]
                print(detailText)
                performSegue(withIdentifier: "placesDetailSegue", sender: self)
            }
        }*/
        let sectionNo = 0
        var rowNo = 1
        
        let tappedIndexPath = tableView.indexPath(for: sender)
        
        if let selectedQuestion = tappedIndexPath?.row {
            rowNo = selectedQuestion
        }
        
        let rowToSelect: IndexPath = IndexPath(row: rowNo, section: sectionNo)
        
        
        if self.showDetail[rowNo] == false {
            self.showDetail[rowNo] = true
        }
        else {
            self.showDetail[rowNo] = false
        }
        //self.detailCellRow = rowToSelect.row
        self.tableView.reloadRows(at: [rowToSelect], with: .fade)
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
