//
//  foodsTableViewController.swift
//  gadabout
//
//  Created by Ahmet on 17.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse
import CoreData
import GoogleMobileAds

class foodsTableViewController: UITableViewController, foodsTableViewCellDelegate, scorePopupDelegate {

    var option1 = [String]()
    var option2 = [String]()
    var option3 = [String]()
    var option4 = [String]()
    var descriptionEng = [String]()
    var descriptionTr = [String]()
    var correctAnswer = [String]()
    var imageArr = [UIImage]()
    var showDetail = [Bool]()
    var questionSeenBefore = [String]()
    var questionCompleted = [String]()
    var nofFoodInstances: Int32 = 0
    
    var detailCellRow: Int = 0
    
    var answer:[Int] = []
    var questionNo:[Int] = []
    
    var isCompleted = false
    var status: Int = -1
    var selected: Int = -1
    var mustBeSelected: Int = -1
    
    var detailText: String = ""
    var userRecord = [Bool]()

    @IBOutlet weak var complete: UIBarButtonItem!
    
    var timeRemaining = 15
    let totalTime = 15
    
    var progressLayer: CAShapeLayer!
    var timer = Timer()
    var scorePoint = 0
    var totalScoreAfterTest = 0
    var timeLabel = UILabel()

    @IBOutlet weak var back: UIBarButtonItem!
    
    var interstitial: GADInterstitial!
    
    var cache = NSCache<AnyObject, AnyObject>()
    
    @IBAction func backTapped(_ sender: Any) {

        timer.invalidate()
        performSegue(withIdentifier: "foodsBackSegue", sender: self)
        
    }
    
    
    
    @IBAction func didCompleteTapped(_ sender: Any) {
        
        if isCompleted == false {
            isCompleted = true
            complete.title = "Next"
            
            tableView.reloadData()
            
            var indx = 0
            getQuizScore()
            for question in questionCompleted {
                if userRecord[indx] == true {
                    let needToSaveData = PFObject(className: "foodsCoveredBefore")
                    needToSaveData["userId"] = PFUser.current()?.objectId
                    needToSaveData["questionId"] = question
                    needToSaveData.saveInBackground(block: { (success, error) in
                        
                        if success {
                            print("Current objects are saved in food record")
                        }
                        else {
                            print("Could not saved")
                        }
                        
                    })
                }
                indx = indx + 1
            }
            
            glbCorrectAnswer = glbCorrectAnswer + scorePoint
            glbTotalQuestion = glbTotalQuestion + option1.count
            showPopup(Score: scorePoint, totalScore: option1.count)
            
            timer.invalidate()
        }
        else {
            complete.title = "Complete"
            isCompleted = false
            timeRemaining = 15
            progressLayer.strokeEnd = 0
            timeLabel.text = "\(timeRemaining)"
            timeLabel.font = UIFont.boldSystemFont(ofSize: 25)
            timeLabel.textColor = UIColor.black
            
            pullQuizItems()
            /*timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCount), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)*/
        }

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.allowsSelection = true
        
        self.tableView.rowHeight = 380
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)
        
        scorePoint = 0

        
        // New code
        if glbFdObjectId.count < 4 {
            questionSeenBefore.removeAll()
            let questionCoveredQuery = PFQuery(className: "foodsCoveredBefore")
            questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            questionCoveredQuery.findObjectsInBackground { [unowned self] (objects, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let foods = objects {
                        for food in foods {
                            //print("\(place["questionId"])")
                            self.questionSeenBefore.append(food["questionId"] as! String)
                        }
                    }
                }
                
                if glbFdObjectId.count > 0 {
                    for indx in 0 ..< glbFdObjectId.count {
                        if self.questionSeenBefore.firstIndex(of: glbFdObjectId[indx]) == nil {
                            self.questionSeenBefore.append(glbFdObjectId[indx])
                        }
                    }
                }
                print("Question Seen Before: \(self.questionSeenBefore)")
                
                let foodsQuery = PFQuery(className: "Foods")
                foodsQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                foodsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                    if let foods = objects {
                        
                        for food in foods {
                            
                            //Caching update
                            let fdImg = food["imageFile"] as! PFFile
                            fdImg.getDataInBackground { [unowned self] (data, error) in
                                
                                if let imageData = data {
                                    
                                    if let imageToDisplay = UIImage(data: imageData) {
                                        
                                        let imageCache = imageToDisplay
                                        
                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                        
                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                            
                                            glbFdImgs.append(cacheimg)
                                            glbFdOption1.append(food["alternative1"] as! String)
                                            glbFdOption2.append(food["alternative2"] as! String)
                                            glbFdOption3.append(food["alternative3"] as! String)
                                            glbFdOption4.append(food["alternative4"] as! String)
                                            glbFdCorrectAnswer.append(food["correctAlternative"] as! String)
                                            glbFdDescriptionEng.append(food["engDescription"] as! String)
                                            
                                            if let question = food.objectId {
                                                glbFdObjectId.append(question)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if glbFdObjectId.count < 4 {
                        let allFoodsQuery = PFQuery(className: "Foods")
                        allFoodsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                            if let foods = objects {
                                
                                for food in foods {
                                    
                                    if let question = food.objectId {
                                        if glbFdObjectId.firstIndex(of: question) == nil {
                                            
                                            //Caching update
                                            let fdImg = food["imageFile"] as! PFFile
                                            fdImg.getDataInBackground { [unowned self] (data, error) in
                                                
                                                if let imageData = data {
                                                    
                                                    if let imageToDisplay = UIImage(data: imageData) {
                                                        
                                                        let imageCache = imageToDisplay
                                                        
                                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                        
                                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                            
                                                            glbFdImgs.append(cacheimg)
                                                            glbFdObjectId.append(question)
                                                            glbFdOption1.append(food["alternative1"] as! String)
                                                            glbFdOption2.append(food["alternative2"] as! String)
                                                            glbFdOption3.append(food["alternative3"] as! String)
                                                            glbFdOption4.append(food["alternative4"] as! String)
                                                            glbFdCorrectAnswer.append(food["correctAlternative"] as! String)
                                                            glbFdDescriptionEng.append(food["engDescription"] as! String)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            var questionLimit = 4
                            
                            if glbFdObjectId.count < questionLimit {
                                questionLimit = glbPlcObjectId.count
                            }
                            
                            for _ in 0 ..< questionLimit {
                                
                                let randomIndex = Int(arc4random_uniform(UInt32(glbFdObjectId.count)))
                                
                                self.option1.append(glbFdOption1[randomIndex])
                                self.option2.append(glbFdOption2[randomIndex])
                                self.option3.append(glbFdOption3[randomIndex])
                                self.option4.append(glbFdOption4[randomIndex])
                                self.imageArr.append(glbFdImgs[randomIndex])
                                self.correctAnswer.append(glbFdCorrectAnswer[randomIndex])
                                self.descriptionEng.append(glbFdDescriptionEng[randomIndex])
                                self.questionCompleted.append(glbFdObjectId[randomIndex])
                                
                                self.showDetail.append(false)
                                self.userRecord.append(false)
                                
                                glbFdOption1.remove(at: randomIndex)
                                glbFdOption2.remove(at: randomIndex)
                                glbFdOption3.remove(at: randomIndex)
                                glbFdOption4.remove(at: randomIndex)
                                glbFdImgs.remove(at: randomIndex)
                                glbFdCorrectAnswer.remove(at: randomIndex)
                                glbFdDescriptionEng.remove(at: randomIndex)
                                glbFdObjectId.remove(at: randomIndex)
                            }
                            self.tableView.reloadData()
                            
                        }
                        
                    }
                        
                    else {
                        var questionLimit = 4
                        
                        if glbFdObjectId.count < questionLimit {
                            questionLimit = glbFdObjectId.count
                        }
                        
                        for _ in 0 ..< questionLimit {
                            
                            let randomIndex = Int(arc4random_uniform(UInt32(glbFdObjectId.count)))
                            
                            self.option1.append(glbFdOption1[randomIndex])
                            self.option2.append(glbFdOption2[randomIndex])
                            self.option3.append(glbFdOption3[randomIndex])
                            self.option4.append(glbFdOption4[randomIndex])
                            self.imageArr.append(glbFdImgs[randomIndex])
                            self.correctAnswer.append(glbFdCorrectAnswer[randomIndex])
                            self.descriptionEng.append(glbFdDescriptionEng[randomIndex])
                            self.questionCompleted.append(glbFdObjectId[randomIndex])
                            
                            self.showDetail.append(false)
                            self.userRecord.append(false)
                            
                            glbFdOption1.remove(at: randomIndex)
                            glbFdOption2.remove(at: randomIndex)
                            glbFdOption3.remove(at: randomIndex)
                            glbFdOption4.remove(at: randomIndex)
                            glbFdImgs.remove(at: randomIndex)
                            glbFdCorrectAnswer.remove(at: randomIndex)
                            glbFdDescriptionEng.remove(at: randomIndex)
                            glbFdObjectId.remove(at: randomIndex)
                        }
                        self.tableView.reloadData()
                    }
                }
            }
            
        }
        else {
            var questionLimit = 4
            
            if glbFdObjectId.count < questionLimit {
                questionLimit = glbFdObjectId.count
            }
            
            for _ in 0 ..< questionLimit {
                
                let randomIndex = Int(arc4random_uniform(UInt32(glbFdObjectId.count)))
                
                option1.append(glbFdOption1[randomIndex])
                option2.append(glbFdOption2[randomIndex])
                option3.append(glbFdOption3[randomIndex])
                option4.append(glbFdOption4[randomIndex])
                imageArr.append(glbFdImgs[randomIndex])
                correctAnswer.append(glbFdCorrectAnswer[randomIndex])
                descriptionEng.append(glbFdDescriptionEng[randomIndex])
                questionCompleted.append(glbFdObjectId[randomIndex])
                
                showDetail.append(false)
                userRecord.append(false)
                
                glbFdOption1.remove(at: randomIndex)
                glbFdOption2.remove(at: randomIndex)
                glbFdOption3.remove(at: randomIndex)
                glbFdOption4.remove(at: randomIndex)
                glbFdImgs.remove(at: randomIndex)
                glbFdCorrectAnswer.remove(at: randomIndex)
                glbFdDescriptionEng.remove(at: randomIndex)
                glbFdObjectId.remove(at: randomIndex)
            }
            tableView.reloadData()
        }
        createProgressBar()


    }
    
    @objc func timeCount() {
        
        if timeRemaining == 1 {
            self.tableView.isScrollEnabled = false
        }
        timeRemaining = timeRemaining - 1
        
        if timeRemaining <= 0 {
            timer.invalidate()
            timeLabel.text = "\(0)"
            quizCompleted()
            
            glbCorrectAnswer = glbCorrectAnswer + scorePoint
            glbTotalQuestion = glbTotalQuestion + option1.count
            showPopup(Score: scorePoint, totalScore: option1.count)
            
            progressLayer.strokeEnd = 1
            
        }
        else {
            if timeRemaining > 5 {
                timeLabel.textColor = UIColor.black
                timeLabel.text = "\(timeRemaining)"
            }
            else {
                timeLabel.textColor = UIColor.red
                UIView.animate(withDuration: 0.2, animations: { [unowned self] in
                    self.timeLabel.alpha = 0.0
                }) { [unowned self] (bool) in
                    self.timeLabel.alpha = 1.0
                    self.timeLabel.text = "\(self.timeRemaining)"
                }
            }
            UIView.animate(withDuration: 1) { [unowned self] in
                self.progressLayer.strokeEnd = (CGFloat(self.totalTime) - CGFloat(self.timeRemaining))/CGFloat(self.totalTime)
            }
        }
    }
    
    func showPopup(Score: Int, totalScore: Int) {
        
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.tableView.isScrollEnabled = false
        if option1.count > 0 {
            let rowToSelect: IndexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: rowToSelect, at: .top, animated: false)
        }
        
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
        popOverVC.scoreWin = Score
        popOverVC.totalScore = totalScore
        popOverVC.isFlagOutput = false
        popOverVC.isPuzzleOutput = false
        popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        
        let popUpSize = self.view.bounds.width*0.9
        
        let centerY = self.view.bounds.height/2 - popUpSize/2
        let centerX = self.view.bounds.width/2 - popUpSize/2
        
        popOverVC.view.frame = CGRect(x: centerX, y: centerY, width: popUpSize, height: popUpSize)//self.view.bounds
        popOverVC.view.backgroundColor = UIColor(rgb: 0xDDD6F2)
        popOverVC.view.layer.cornerRadius = 20
        
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)

        

    }
    
    func quizCompleted() {
        let sectionNo = 0
        complete.title = "Next"
        
        if isCompleted == false {
            isCompleted = true
            let nofQuestions = correctAnswer.count
            
            if nofQuestions > 0 {
                for rowNo in 0...nofQuestions-1 {
                    
                    let rowToSelect: IndexPath = IndexPath(row: rowNo, section: sectionNo)
                    self.tableView.reloadRows(at: [rowToSelect], with: .fade)
                }
            }
        }
        var indx = 0
        getQuizScore()
        for question in questionCompleted {
            
            if userRecord[indx] == true {
                let needToSaveData = PFObject(className: "foodsCoveredBefore")
                needToSaveData["userId"] = PFUser.current()?.objectId
                needToSaveData["questionId"] = question
                needToSaveData.saveInBackground(block: { (success, error) in
                    
                    if success {
                        print("Current user is saved in food record")
                    }
                    else {
                        print("Could not saved")
                    }
                    
                })
            }
            indx = indx + 1
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "foodsIdentifier", for: indexPath) as! foodsTableViewCell
        cell.delegate = self
        
        
        cell.toDoListButton.layer.cornerRadius = 5
        cell.toDoListButton.layer.borderWidth = 1
        cell.toDoListButton.layer.borderColor = UIColor.black.cgColor
        
        let spacing: CGFloat = 5 // the amount of spacing to appear between image and title
        cell.markOption1.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption1.setTitleColor(UIColor.black, for: .normal)
        cell.markOption1.layer.borderWidth = 0
        
        cell.markOption1.titleLabel?.numberOfLines = 1
        cell.markOption1.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.markOption1.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        cell.markOption2.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption2.setTitleColor(UIColor.black, for: .normal)
        cell.markOption2.layer.borderWidth = 0
        
        cell.markOption2.titleLabel?.numberOfLines = 1
        cell.markOption2.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.markOption2.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping
        
        cell.markOption3.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption3.setTitleColor(UIColor.black, for: .normal)
        cell.markOption3.layer.borderWidth = 0
        
        cell.markOption3.titleLabel?.numberOfLines = 1
        cell.markOption3.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.markOption3.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping

        cell.markOption4.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption4.setTitleColor(UIColor.black, for: .normal)
        cell.markOption4.layer.borderWidth = 0

        cell.markOption4.titleLabel?.numberOfLines = 1
        cell.markOption4.titleLabel?.adjustsFontSizeToFitWidth = true
        cell.markOption4.titleLabel?.lineBreakMode = NSLineBreakMode.byClipping

        let screenSize = UIScreen.main.bounds
        
        if screenSize.width < 350 {
            cell.toDoListButton.titleLabel?.font = .systemFont(ofSize: 15)
        }
        else if screenSize.width < 400 {
            cell.toDoListButton.titleLabel?.font = .systemFont(ofSize: 16)
        }
        else {
            cell.toDoListButton.titleLabel?.font = .systemFont(ofSize: 17)
        }
        
        cell.layer.cornerRadius = 20 //set corner radius here
        cell.layer.borderColor = UIColor.lightGray.cgColor  // set cell border color here
        cell.layer.borderWidth = 2 // set border width here

        
        //print("Row: \(indexPath.row) showDetail: \(showDetail) Completed: \(isCompleted)")
        
        if (showDetail[indexPath.row] == true)/* && (detailCellRow == indexPath.row)*/ {
            
            //cell.placeImage.isHidden = true

            cell.markOption1.isHidden = true
            cell.markOption2.isHidden = true
            cell.markOption3.isHidden = true
            cell.markOption4.isHidden = true
            
            cell.optionALabel.isHidden = true
            cell.optionBLabel.isHidden = true
            cell.optionCLabel.isHidden = true
            cell.optionDLabel.isHidden = true
            
            cell.detailsButton.isHidden = false
            cell.toDoListButton.isHidden = false
            cell.detailsButton.setTitle("Back", for: [])
            
            let newDescription = NSString(string: descriptionEng[indexPath.row])
            let components = newDescription.components(separatedBy: "Photo licensed under")
            if components.count == 2 {
                cell.photoCredit.text = "Photo licensed under" + components[1]
                cell.detailText.text = components[0]
                cell.photoCredit.isHidden = false
            }
            else{
                cell.photoCredit.isHidden = true
                cell.detailText.text = descriptionEng[indexPath.row]
            }
            
            cell.detailText.isHidden = false
            cell.detailText.sizeToFit()
            cell.detailText.numberOfLines = 0
            
            cell.foodImage.image = imageArr[indexPath.row]
            
        }
        else {
            
            cell.detailsButton.setTitle("Details", for: [])
            cell.foodImage.image = imageArr[indexPath.row]
            
            cell.markOption1.isHidden = false
            cell.markOption2.isHidden = false
            cell.markOption3.isHidden = false
            cell.markOption4.isHidden = false
            
            cell.optionALabel.isHidden = false
            cell.optionBLabel.isHidden = false
            cell.optionCLabel.isHidden = false
            cell.optionDLabel.isHidden = false

            cell.detailText.isHidden = true
            cell.photoCredit.isHidden = true
            
            cell.markOption1.setTitle(option1[indexPath.row], for: [])
            cell.markOption2.setTitle(option2[indexPath.row], for: [])
            cell.markOption3.setTitle(option3[indexPath.row], for: [])
            cell.markOption4.setTitle(option4[indexPath.row], for: [])
            
            cell.markOption1.backgroundColor = UIColor.clear
            cell.markOption2.backgroundColor = UIColor.clear
            cell.markOption3.backgroundColor = UIColor.clear
            cell.markOption4.backgroundColor = UIColor.clear

            
            let questionIndex = questionNo.index(of: indexPath.row)
            
            if let qIndex = questionIndex {
                let answerIndex = answer[qIndex]
                if answerIndex == 1 {
                    
                    cell.markOption1.layer.cornerRadius = 10
                    cell.markOption1.backgroundColor = UIColor(rgb: 0x7E9BE6)

                }
                else if answerIndex == 2 {
                    
                    cell.markOption2.layer.cornerRadius = 10
                    cell.markOption2.backgroundColor = UIColor(rgb: 0x7E9BE6)

                }
                else if answerIndex == 3 {
                    
                    cell.markOption3.layer.cornerRadius = 10
                    cell.markOption3.backgroundColor = UIColor(rgb: 0x7E9BE6)

                }
                else if answerIndex == 4 {
                    
                    cell.markOption4.layer.cornerRadius = 10
                    cell.markOption4.backgroundColor = UIColor(rgb: 0x7E9BE6)

                }
            }
            
            
            cell.detailsButton.isHidden = true
            cell.toDoListButton.isHidden = true
            
            cell.markOption1.isEnabled = true
            cell.markOption2.isEnabled = true
            cell.markOption3.isEnabled = true
            cell.markOption4.isEnabled = true

            if (isCompleted == true) {
                
                
                cell.detailsButton.isHidden = false
                cell.toDoListButton.isHidden = false
                
                cell.markOption1.setTitle(option1[indexPath.row], for: [])
                cell.markOption2.setTitle(option2[indexPath.row], for: [])
                cell.markOption3.setTitle(option3[indexPath.row], for: [])
                cell.markOption4.setTitle(option4[indexPath.row], for: [])
                
                cell.markOption1.backgroundColor = UIColor.clear
                cell.markOption2.backgroundColor = UIColor.clear
                cell.markOption3.backgroundColor = UIColor.clear
                cell.markOption4.backgroundColor = UIColor.clear

                
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
                        }
                        else {
                            status = 0 // wrong answer
                            
                            if correctAnswerInt == 1 {
                                
                                cell.markOption1.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                                cell.markOption1.layer.borderWidth = 2
                                cell.markOption1.layer.cornerRadius = 10
                                
                            }
                            else if correctAnswerInt == 2 {
                                
                                cell.markOption2.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                                cell.markOption2.layer.borderWidth = 2
                                cell.markOption2.layer.cornerRadius = 10
                                
                            }
                            else if correctAnswerInt == 3 {
                                
                                cell.markOption3.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                                cell.markOption3.layer.borderWidth = 2
                                cell.markOption3.layer.cornerRadius = 10
                                
                            }
                            else {
                                
                                cell.markOption4.layer.borderColor = UIColor(rgb: 0x039D18).cgColor
                                cell.markOption4.layer.borderWidth = 2
                                cell.markOption4.layer.cornerRadius = 10
                                
                            }
                            
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
                        
                        cell.markOption1.backgroundColor = UIColor(rgb: 0x29D3AE)
                    }
                    else if selected == 2 {
                        
                        cell.markOption2.backgroundColor = UIColor(rgb: 0x29D3AE)
                    }
                    else if selected == 3 {

                        cell.markOption2.backgroundColor = UIColor(rgb: 0x29D3AE)
                    }
                    else if selected == 4 {
                        
                        cell.markOption2.backgroundColor = UIColor(rgb: 0x29D3AE)

                    }
                    
                }
                else if status == 0 {
                    
                    if selected == 1 {
                        
                        cell.markOption1.backgroundColor = UIColor(rgb: 0xE9375D)

                        
                    }
                    else if selected == 2 {
                        
                        cell.markOption2.backgroundColor = UIColor(rgb: 0xE9375D)

                        
                        
                    }
                    else if selected == 3 {
                        
                        cell.markOption3.backgroundColor = UIColor(rgb: 0xE9375D)

                        
                    }
                    else if selected == 4 {
                        
                        cell.markOption4.backgroundColor = UIColor(rgb: 0xE9375D)

                        
                    }
                }
                else {
                    print("Unexpected")
                    
                }
            }
        }
        
        return cell
    }
    

    func didAlternativeSelected(sender: foodsTableViewCell, selectedIndex: Int){
        
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
    
    func isDetailButtonTapped(sender: foodsTableViewCell) {
        
        
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
    
    func appendToDoList(sender: foodsTableViewCell) {
        
        UIButton.animate(withDuration: 0.2,
                         animations: {
                            sender.transform = CGAffineTransform(scaleX: 0.975, y: 0.96)
        },
                         completion: { finish in
                            UIButton.animate(withDuration: 0.2, animations: {
                                sender.transform = CGAffineTransform.identity
                            })
        })
        
        if let tappedIndexPath = tableView.indexPath(for: sender) {
            
            if glbToDoItemIDs.firstIndex(of: questionCompleted[tappedIndexPath.row]) == nil {
                glbToDoItemPlaceOrFood.append("Food")
                glbToDoItemCompleted.append(false)
                glbToDoItemDescriptions.append(descriptionEng[tappedIndexPath.row])
                glbToDoItemImg.append(imageArr[tappedIndexPath.row])
                glbToDoItemIDs.append(questionCompleted[tappedIndexPath.row])
                
                if let correctAnsInt = Int(correctAnswer[tappedIndexPath.row]) {
                    if correctAnsInt == 1 {
                        glbToDoItemNames.append(self.option1[tappedIndexPath.row])
                    }
                    else if correctAnsInt == 2 {
                        glbToDoItemNames.append(self.option2[tappedIndexPath.row])
                    }
                    else if correctAnsInt == 3 {
                        glbToDoItemNames.append(self.option3[tappedIndexPath.row])
                    }
                    else if correctAnsInt == 4 {
                        glbToDoItemNames.append(self.option4[tappedIndexPath.row])
                    }
                }
                
                let toDoItem = PFObject(className: "ToDoList")
                
                toDoItem["item"] = questionCompleted[tappedIndexPath.row]
                toDoItem["userId"] = PFUser.current()?.objectId
                toDoItem["PlaceOrFood"] = "Food"
                toDoItem["Completed"] = "No"
                
                toDoItem.saveInBackground { (success, error) in
                    
                    if success {
                        print("Entity saved successfully")
                    }
                    else { // success
                        
                        print("Entity could not be saved")
                        print(error?.localizedDescription)
                    }
                }
            }
        }
    }

    func pullQuizItems() {
        tableView.alpha = 0.5
        
        questionSeenBefore.removeAll()
        option1.removeAll()
        option2.removeAll()
        option3.removeAll()
        option4.removeAll()
        imageArr.removeAll()
        correctAnswer.removeAll()
        descriptionEng.removeAll()
        descriptionTr.removeAll()
        showDetail.removeAll()
        questionCompleted.removeAll()
        userRecord.removeAll()
        answer.removeAll()
        questionNo.removeAll()
        scorePoint = 0
        

        if glbFdObjectId.count < 4 {
            questionSeenBefore.removeAll()
            let questionCoveredQuery = PFQuery(className: "foodsCoveredBefore")
            questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            questionCoveredQuery.findObjectsInBackground { [unowned self] (objects, error) in
                
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let foods = objects {
                        for food in foods {
                            //print("\(place["questionId"])")
                            self.questionSeenBefore.append(food["questionId"] as! String)
                        }
                    }
                }
                
                if glbFdObjectId.count > 0 {
                    for indx in 0 ..< glbFdObjectId.count {
                        self.questionSeenBefore.append(glbFdObjectId[indx])
                    }
                }
                print("Question Seen Before: \(self.questionSeenBefore)")
                
                let foodsQuery = PFQuery(className: "Foods")
                foodsQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                foodsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                    if let foods = objects {
                        
                        for food in foods {
                            
                            //Caching update
                            let fdImg = food["imageFile"] as! PFFile
                            fdImg.getDataInBackground { [unowned self] (data, error) in
                                
                                if let imageData = data {
                                    
                                    if let imageToDisplay = UIImage(data: imageData) {
                                        
                                        let imageCache = imageToDisplay
                                        
                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                        
                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                            
                                            glbFdImgs.append(cacheimg)
                                            glbFdOption1.append(food["alternative1"] as! String)
                                            glbFdOption2.append(food["alternative2"] as! String)
                                            glbFdOption3.append(food["alternative3"] as! String)
                                            glbFdOption4.append(food["alternative4"] as! String)
                                            glbFdCorrectAnswer.append(food["correctAlternative"] as! String)
                                            glbFdDescriptionEng.append(food["engDescription"] as! String)
                                            
                                            if let question = food.objectId {
                                                glbFdObjectId.append(question)
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
                    if glbFdObjectId.count < 4 {
                        let allFoodsQuery = PFQuery(className: "Foods")
                        allFoodsQuery.findObjectsInBackground { [unowned self] (objects, error) in
                            if let foods = objects {
                                
                                for food in foods {
                                    
                                    if let question = food.objectId {
                                        if glbFdObjectId.firstIndex(of: question) == nil {
                                            
                                            //Caching update
                                            let fdImg = food["imageFile"] as! PFFile
                                            fdImg.getDataInBackground { [unowned self] (data, error) in
                                                
                                                if let imageData = data {
                                                    
                                                    if let imageToDisplay = UIImage(data: imageData) {
                                                        
                                                        let imageCache = imageToDisplay
                                                        
                                                        self.cache.setObject(imageCache, forKey: "cacheImg" as AnyObject)
                                                        
                                                        if let cacheimg = self.cache.object(forKey: "cacheImg" as AnyObject) as? UIImage {
                                                            
                                                            glbFdImgs.append(cacheimg)
                                                            glbFdObjectId.append(question)
                                                            glbFdOption1.append(food["alternative1"] as! String)
                                                            glbFdOption2.append(food["alternative2"] as! String)
                                                            glbFdOption3.append(food["alternative3"] as! String)
                                                            glbFdOption4.append(food["alternative4"] as! String)
                                                            glbFdCorrectAnswer.append(food["correctAlternative"] as! String)
                                                            glbFdDescriptionEng.append(food["engDescription"] as! String)
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                    
                                }
                            }
                            
                            var questionLimit = 4
                            
                            if glbFdObjectId.count < questionLimit {
                                questionLimit = glbFdObjectId.count
                            }
                            
                            for _ in 0 ..< questionLimit {
                                
                                let randomIndex = Int(arc4random_uniform(UInt32(glbFdObjectId.count)))
                                
                                self.option1.append(glbFdOption1[randomIndex])
                                self.option2.append(glbFdOption2[randomIndex])
                                self.option3.append(glbFdOption3[randomIndex])
                                self.option4.append(glbFdOption4[randomIndex])
                                self.imageArr.append(glbFdImgs[randomIndex])
                                self.correctAnswer.append(glbFdCorrectAnswer[randomIndex])
                                self.descriptionEng.append(glbFdDescriptionEng[randomIndex])
                                self.questionCompleted.append(glbFdObjectId[randomIndex])
                                
                                self.showDetail.append(false)
                                self.userRecord.append(false)
                                
                                glbFdOption1.remove(at: randomIndex)
                                glbFdOption2.remove(at: randomIndex)
                                glbFdOption3.remove(at: randomIndex)
                                glbFdOption4.remove(at: randomIndex)
                                glbFdImgs.remove(at: randomIndex)
                                glbFdCorrectAnswer.remove(at: randomIndex)
                                glbFdDescriptionEng.remove(at: randomIndex)
                                glbFdObjectId.remove(at: randomIndex)
                            }
                            self.tableView.reloadData()
                            self.tableView.alpha = 1
                            self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
                            RunLoop.main.add(self.timer, forMode: .commonModes)
                            
                        }
                        
                    }
                    else {
                        var questionLimit = 4
                        
                        if glbFdObjectId.count < questionLimit {
                            questionLimit = glbFdObjectId.count
                        }

                        for _ in 0 ..< questionLimit {
                            
                            let randomIndex = Int(arc4random_uniform(UInt32(glbFdObjectId.count)))
                            
                            self.option1.append(glbFdOption1[randomIndex])
                            self.option2.append(glbFdOption2[randomIndex])
                            self.option3.append(glbFdOption3[randomIndex])
                            self.option4.append(glbFdOption4[randomIndex])
                            self.imageArr.append(glbFdImgs[randomIndex])
                            self.correctAnswer.append(glbFdCorrectAnswer[randomIndex])
                            self.descriptionEng.append(glbFdDescriptionEng[randomIndex])
                            self.questionCompleted.append(glbFdObjectId[randomIndex])
                            
                            self.showDetail.append(false)
                            self.userRecord.append(false)
                            
                            glbFdOption1.remove(at: randomIndex)
                            glbFdOption2.remove(at: randomIndex)
                            glbFdOption3.remove(at: randomIndex)
                            glbFdOption4.remove(at: randomIndex)
                            glbFdImgs.remove(at: randomIndex)
                            glbFdCorrectAnswer.remove(at: randomIndex)
                            glbFdDescriptionEng.remove(at: randomIndex)
                            glbFdObjectId.remove(at: randomIndex)
                        }
                        self.tableView.reloadData()
                        self.tableView.alpha = 1
                        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timeCount), userInfo: nil, repeats: true)
                        RunLoop.main.add(self.timer, forMode: .commonModes)
                    }
                }
            }
        }
        else {
            var questionLimit = 4
            
            if glbFdObjectId.count < questionLimit {
                questionLimit = glbFdObjectId.count
            }
            
            for _ in 0 ..< questionLimit {
                
                let randomIndex = Int(arc4random_uniform(UInt32(glbFdObjectId.count)))
                
                option1.append(glbFdOption1[randomIndex])
                option2.append(glbFdOption2[randomIndex])
                option3.append(glbFdOption3[randomIndex])
                option4.append(glbFdOption4[randomIndex])
                imageArr.append(glbFdImgs[randomIndex])
                correctAnswer.append(glbFdCorrectAnswer[randomIndex])
                descriptionEng.append(glbFdDescriptionEng[randomIndex])
                questionCompleted.append(glbFdObjectId[randomIndex])
                
                showDetail.append(false)
                userRecord.append(false)
                
                glbFdOption1.remove(at: randomIndex)
                glbFdOption2.remove(at: randomIndex)
                glbFdOption3.remove(at: randomIndex)
                glbFdOption4.remove(at: randomIndex)
                glbFdImgs.remove(at: randomIndex)
                glbFdCorrectAnswer.remove(at: randomIndex)
                glbFdDescriptionEng.remove(at: randomIndex)
                glbFdObjectId.remove(at: randomIndex)
            }
            tableView.reloadData()
            tableView.alpha = 1
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCount), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
        }

        
    }
    
    func getQuizScore() {
        for indx in 0 ..< option1.count{
            let questionIndex = questionNo.index(of: indx)
            if let correctAnsInt = Int(correctAnswer[indx]) {
                let correctAnswerInt = correctAnsInt
                mustBeSelected = correctAnswerInt
                if let qIndex = questionIndex {
                    selected = answer[qIndex]
                    if answer[qIndex] == correctAnswerInt {
                        scorePoint = scorePoint + 1
                        userRecord[indx] = true
                    }
                }
            }
        }
    }
    
    func SendCloseInfo() {
        print("Popup closed")
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        tableView.isScrollEnabled = true
        
        if interstitial.isReady {
            interstitial.present(fromRootViewController: self)
        } else {
            print("Ad wasn't ready")
        }
        
        // Ad id
        // interstitial = GADInterstitial(adUnitID: "ca-app-pub-5745243428784846~5277829027")
        
        // Test ad
        interstitial = GADInterstitial(adUnitID: "ca-app-pub-3940256099942544/4411468910")
        let adRequest = GADRequest()
        interstitial.load(adRequest)
        
        let userScoreQuery = PFQuery(className: "UserScore")
        userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
        userScoreQuery.findObjectsInBackground { (objects, error) in
            if let score = objects?.first {
                
                score["correctAnswer"] = String(glbCorrectAnswer)
                score["totalQuestion"] = String(glbTotalQuestion)
                score.saveInBackground()
            }
            else {
                
                let score = PFObject(className: "UserScore")
                score["correctAnswer"] = String(glbCorrectAnswer)
                score["totalQuestion"] = String(glbTotalQuestion)
                score["userId"] = PFUser.current()?.objectId
                score.saveInBackground()
            }
        }
    }
    
    func createProgressBar() {
        
        if let navigationBar = self.navigationController?.navigationBar {
            let timeFrame = CGRect(x: 0, y: 0, width: navigationBar.frame.width, height: navigationBar.frame.height)
            
            timeLabel = UILabel(frame: timeFrame)
            timeLabel.text = "\(timeRemaining)"
            timeLabel.textAlignment = .center
            timeLabel.font = UIFont.boldSystemFont(ofSize: 25)
            
            navigationBar.addSubview(timeLabel)
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCount), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
            
            
            let circularPath = UIBezierPath(arcCenter: navigationBar.center, radius: navigationBar.frame.height*0.4, startAngle: -CGFloat.pi/2, endAngle: CGFloat.pi/2*3, clockwise: true)
            
            progressLayer = CAShapeLayer()
            progressLayer.path = circularPath.cgPath
            progressLayer.lineWidth = 5
            progressLayer.lineCap = kCALineCapRound
            progressLayer.fillColor = nil
            progressLayer.strokeColor = complete.tintColor?.cgColor //UIColor.red.cgColor
            progressLayer.strokeEnd = 0.0
            
            navigationBar.layer.addSublayer(progressLayer)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "foodsBackSegue" {
            let src = self
            let transition: CATransition = CATransition()
            let timeFunc : CAMediaTimingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            transition.duration = 0.3
            transition.timingFunction = timeFunc
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromLeft
            
            
            src.view.window?.layer.add(transition, forKey: nil)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        timer.invalidate()
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
