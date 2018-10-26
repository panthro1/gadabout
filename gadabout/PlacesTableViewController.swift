//
//  PlacesTableViewController.swift
//  gadabout
//
//  Created by Ahmet on 22.07.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse
import CoreData


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
    var questionSeenBefore = [String]()
    var questionCompleted = [String]()
    var nofPlaceInstances: Int32 = 0
    
    var detailCellRow: Int = 0
    
    var answer:[Int] = []
    var questionNo:[Int] = []
    
    var isCompleted = false
    var status: Int = -1
    var selected: Int = -1
    var mustBeSelected: Int = -1
    
    var detailText: String = ""
    var userRecord = [Bool]()
    

    @IBOutlet weak var back: UIBarButtonItem!
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "placesBackSegue", sender: self)

    }
    
    @IBOutlet weak var complete: UIBarButtonItem!

    
    
    @IBAction func didCompleteTapped(_ sender: Any) {
        
        let sectionNo = 0
        
        if isCompleted == false {
            isCompleted = true
            let nofQuestions = correctAnswer.count


            for rowNo in 0...nofQuestions-1 {
                
                let rowToSelect: IndexPath = IndexPath(row: rowNo, section: sectionNo)
                self.tableView.reloadRows(at: [rowToSelect], with: .fade)
            }
        }
        var indx = 0
        for question in questionCompleted {
            
            if userRecord[indx] == true {
                let needToSaveData = PFObject(className: "placesCoveredBefore")
                needToSaveData["userId"] = PFUser.current()?.objectId
                needToSaveData["questionId"] = question
                needToSaveData.saveInBackground(block: { (success, error) in
                    
                    if success {
                        print("Current user is saved in place record")
                    }
                    else {
                        print("Could not saved")
                    }
                    
                })
            }
            indx = indx + 1
        }

        
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.tableView.rowHeight = 380
        
        //questionSeenBefore.removeAll()
        
        let nofInstanceQuery = PFQuery(className: "Places")
        nofInstanceQuery.countObjectsInBackground { (count, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.nofPlaceInstances = count
                print("Total place instances: \(count)")
                let questionCoveredQuery = PFQuery(className: "placesCoveredBefore")
                questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
                questionCoveredQuery.findObjectsInBackground { (objects, error) in
                    
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        if let places = objects {
                            for place in places {
                                //print("\(place["questionId"])")
                                self.questionSeenBefore.append(place["questionId"] as! String)
                            }
                        }
                    }
                    let questionLimit = 2
                    var randomIndexArr = [Int]()
                    for _ in 0 ..< questionLimit {
                        let placesQuery = PFQuery(className: "Places")
                        
                        var randomIndex = Int(arc4random_uniform(UInt32(self.nofPlaceInstances)))
                        print("Random Index: \(randomIndex)")
                        
                        while true {
                            
                            if let rIndex = randomIndexArr.index(of: randomIndex) {
                                print("Same instance")
                                randomIndex = Int(arc4random_uniform(UInt32(self.nofPlaceInstances)))
                                print("Random Index: \(randomIndex)")
                            }
                            else {
                                randomIndexArr.append(randomIndex)
                                break
                            }
                        }
                            
                        placesQuery.skip = randomIndex

                        placesQuery.limit = 1
                        placesQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                        
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
                                    
                                    
                                    if let question = place.objectId {
                                        self.questionCompleted.append(question)
                                        self.userRecord.append(false)
                                    }
                                }
                            }
                            
                        }
                        
                    }
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
        
        cell.toDoListButton.layer.cornerRadius = 5
        cell.toDoListButton.layer.borderWidth = 1
        cell.toDoListButton.layer.borderColor = UIColor.black.cgColor
        
        cell.detailsButton.backgroundColor = .clear
        cell.detailsButton.layer.cornerRadius = 5
        cell.detailsButton.layer.borderWidth = 1
        cell.detailsButton.layer.borderColor = UIColor.black.cgColor
        
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
            
            
            cell.markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            cell.markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            cell.markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            cell.markOption4.setImage(UIImage(named: "uncheck.png"), for: [])

            let questionIndex = questionNo.index(of: indexPath.row)
            
            if let qIndex = questionIndex {
                let answerIndex = answer[qIndex]
                if answerIndex == 1 {
                    cell.markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
                }
                else if answerIndex == 2 {
                    cell.markOption2.setImage(UIImage(named: "check.png"), for: [])
                }
                else if answerIndex == 3 {
                    cell.markOption3.setImage(UIImage(named: "check.png"), for: [])
                }
                else if answerIndex == 4 {
                    cell.markOption4.setImage(UIImage(named: "check.png"), for: [])
                }
            }

        
            cell.detailsButton.isHidden = true
        
            if (isCompleted == true) {
                

                cell.detailsButton.isHidden = false
                cell.toDoListButton.isHidden = false
                
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
                        print("Row No: \(indexPath.row) selected: \(selected)")
                        if answer[qIndex] == correctAnswerInt {
                            status = 1 // correct answer
                            userRecord[indexPath.row] = true
                        }
                        else {
                            status = 0 // wrong answer
             
                        }
                    }
                    else {
                        selected = -1
                        status = 0 // wrong answer
                    }
                }
                else {
                    status = -1 // no valid string
                }

                if status == 1 {

                    if selected == 1 {

                        cell.markOption1.setImage(UIImage(named: "correct2.png"), for: [])

                    }
                    else if selected == 2 {

                        cell.markOption2.setImage(UIImage(named: "correct2.png"), for: [])

                    }
                    else if selected == 3 {

                        cell.markOption3.setImage(UIImage(named: "correc2t.png"), for: [])

                    }
                    else if selected == 4 {

                        cell.markOption4.setImage(UIImage(named: "correct2.png"), for: [])

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
        
        if let questionIndex = questionNo.index(of: (tappedIndexPath?.row)!) {
            if let selectedQuestion = tappedIndexPath?.row {
                questionNo[questionIndex] = selectedQuestion
                answer[questionIndex] = selectedIndex
            }
        }
        else {
            if let selectedQuestion = tappedIndexPath?.row {
                questionNo.append(selectedQuestion)
            }
            
            answer.append(selectedIndex)
        }
        
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
    
    func appendToDoList(sender: PlacesTableViewCell) {
        
        UIButton.animate(withDuration: 0.2,
         animations: {
         sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
         },
         completion: { finish in
         UIButton.animate(withDuration: 0.2, animations: {
         sender.transform = CGAffineTransform.identity
         })
         })
        
        let itemsObjectDescription = UserDefaults.standard.object(forKey: "toDoItemDescription")
        
        let itemsObjectName = UserDefaults.standard.object(forKey: "toDoItem")
        
        var itemsDescription = [String]()
        
        var itemsName = [String]()
        
        if let tappedIndexPath = tableView.indexPath(for: sender) {
            
            if let tempItemsDescription = itemsObjectDescription {
                if let tempItemsName = itemsObjectName {
                    itemsDescription = tempItemsDescription as! [String]
                    itemsName = tempItemsName as! [String]
                    
                    itemsDescription.append(self.descriptionEng[tappedIndexPath.row])
                    if let correctAnsInt = Int(correctAnswer[tappedIndexPath.row]) {
                        
                        if correctAnsInt == 1 {
                            itemsName.append(self.option1[tappedIndexPath.row])
                        }
                        else if correctAnsInt == 2 {
                            itemsName.append(self.option2[tappedIndexPath.row])
                        }
                        else if correctAnsInt == 3 {
                            itemsName.append(self.option3[tappedIndexPath.row])
                        }
                        else if correctAnsInt == 4 {
                            itemsName.append(self.option4[tappedIndexPath.row])
                        }
                    }
                }
                else {
                    
                    if let correctAnsInt = Int(correctAnswer[tappedIndexPath.row]) {
                        itemsDescription.append(self.descriptionEng[tappedIndexPath.row])
                        
                        if correctAnsInt == 1 {
                            itemsName.append(self.option1[tappedIndexPath.row])
                        }
                        else if correctAnsInt == 2 {
                            itemsName.append(self.option2[tappedIndexPath.row])
                        }
                        else if correctAnsInt == 3 {
                            itemsName.append(self.option3[tappedIndexPath.row])
                        }
                        else if correctAnsInt == 4 {
                            itemsName.append(self.option4[tappedIndexPath.row])
                        }
                    }
                }
                
            }
            else {
                itemsDescription.append(self.descriptionEng[tappedIndexPath.row])
                
                if let correctAnsInt = Int(correctAnswer[tappedIndexPath.row]) {
                    if correctAnsInt == 1 {
                        itemsName.append(self.option1[tappedIndexPath.row])
                    }
                    else if correctAnsInt == 2 {
                        itemsName.append(self.option2[tappedIndexPath.row])
                    }
                    else if correctAnsInt == 3 {
                        itemsName.append(self.option3[tappedIndexPath.row])
                    }
                    else if correctAnsInt == 4 {
                        itemsName.append(self.option4[tappedIndexPath.row])
                    }
                }
            }
        }
        print("itemsName : \(itemsName)")
        print("itemsDescription: \(itemsDescription)")

        UserDefaults.standard.set(itemsName, forKey: "toDoItem")
        UserDefaults.standard.set(itemsDescription, forKey: "toDoItemDescription")
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
