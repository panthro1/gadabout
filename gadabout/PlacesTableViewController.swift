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
import GoogleMobileAds


class PlacesTableViewController: UITableViewController, placesTableViewCellDelegate, scorePopupDelegate {
    
    
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
    
    var timeRemaining = 15
    let totalTime = 15
    var timeLabel = UILabel()
    var timer = Timer()
    var scorePoint = 0
    var totalScoreAfterTest = 0
    
    
    var progressLayer: CAShapeLayer!
    
    var interstitial: GADInterstitial!


    @IBOutlet weak var back: UIBarButtonItem!
    
    override var shouldAutorotate: Bool {
        return false
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    @IBAction func backTapped(_ sender: Any) {
        timer.invalidate()
        performSegue(withIdentifier: "placesBackSegue", sender: self)

    }
    
    @IBOutlet weak var complete: UIBarButtonItem!

    
    
    @IBAction func didCompleteTapped(_ sender: Any) {

        
        if isCompleted == false {
            
            isCompleted = true
            complete.title = "Next"

            tableView.reloadData()
            
            var indx = 0
            getQuizScore()
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
            
            let userScoreQuery = PFQuery(className: "UserScore")
            userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            userScoreQuery.findObjectsInBackground { [unowned self] (objects, error) in
                if let score = objects?.first {
                    if let totalScore = Int(score["score"] as! String) {
                        self.totalScoreAfterTest = totalScore + self.scorePoint
                        self.showPopup(Score: self.scorePoint, totalScore: self.totalScoreAfterTest)
                        
                        score["userId"] = PFUser.current()?.objectId
                        score["score"] = String(self.totalScoreAfterTest)
                        score.saveInBackground()
                        
                    }
                    else {
                        self.totalScoreAfterTest = self.scorePoint
                        self.showPopup(Score: self.scorePoint, totalScore: self.totalScoreAfterTest)
                        
                        score["userId"] = PFUser.current()?.objectId
                        score["score"] = String(self.totalScoreAfterTest)
                        score.saveInBackground()
                    }
                }
                else {
                    self.totalScoreAfterTest = self.scorePoint
                    self.showPopup(Score: self.scorePoint, totalScore: self.totalScoreAfterTest)
                    
                    let score = PFObject(className: "UserScore")
                    score["userId"] = PFUser.current()?.objectId
                    score["score"] = String(self.totalScoreAfterTest)
                    score.saveInBackground()
                }
            }
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
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timeCount), userInfo: nil, repeats: true)
            RunLoop.main.add(timer, forMode: .commonModes)
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
        
        if glbPlcObjectId.count < 10 {
            questionSeenBefore.removeAll()
            let questionCoveredQuery = PFQuery(className: "placesCoveredBefore")
            questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            questionCoveredQuery.findObjectsInBackground { [unowned self] (objects, error) in
                
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
                
                if glbPlcObjectId.count > 0 {
                    for indx in 0 ..< glbPlcObjectId.count {
                        self.questionSeenBefore.append(glbPlcObjectId[indx])
                    }
                }
                print("Question Seen Before: \(self.questionSeenBefore)")
                
                let placesQuery = PFQuery(className: "Places")
                placesQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                placesQuery.findObjectsInBackground { [unowned self] (objects, error) in
                    if let places = objects {
                        
                        for place in places {
                            
                            glbPlcOption1.append(place["alternative1"] as! String)
                            glbPlcOption2.append(place["alternative2"] as! String)
                            glbPlcOption3.append(place["alternative3"] as! String)
                            glbPlcOption4.append(place["alternative4"] as! String)
                            glbPlcImageFile.append(place["imageFile"] as! PFFile)
                            glbPlcCorrectAnswer.append(place["correctAlternative"] as! String)
                            glbPlcDescriptionEng.append(place["engDescription"] as! String)
                            
                            if let question = place.objectId {
                                glbPlcObjectId.append(question)
                            }
                        }
                    }
                    print("Pulled objects: \(glbPlcObjectId)")
                    var questionLimit = 4
                    
                    if glbPlcObjectId.count < questionLimit {
                        questionLimit = glbPlcObjectId.count
                    }
                    
                    for _ in 0 ..< questionLimit {
                        
                        let randomIndex = Int(arc4random_uniform(UInt32(glbPlcObjectId.count - 1)))
                        
                        self.option1.append(glbPlcOption1[randomIndex])
                        self.option2.append(glbPlcOption2[randomIndex])
                        self.option3.append(glbPlcOption3[randomIndex])
                        self.option4.append(glbPlcOption4[randomIndex])
                        self.imageFile.append(glbPlcImageFile[randomIndex])
                        self.correctAnswer.append(glbPlcCorrectAnswer[randomIndex])
                        self.descriptionEng.append(glbPlcDescriptionEng[randomIndex])
                        self.questionCompleted.append(glbPlcObjectId[randomIndex])
                        
                        self.showDetail.append(false)
                        self.userRecord.append(false)
                        
                        glbPlcOption1.remove(at: randomIndex)
                        glbPlcOption2.remove(at: randomIndex)
                        glbPlcOption3.remove(at: randomIndex)
                        glbPlcOption4.remove(at: randomIndex)
                        glbPlcImageFile.remove(at: randomIndex)
                        glbPlcCorrectAnswer.remove(at: randomIndex)
                        glbPlcDescriptionEng.remove(at: randomIndex)
                        glbPlcObjectId.remove(at: randomIndex)
                    }
                    self.tableView.reloadData()
                }
                
            }

        }
        else {
            var questionLimit = 4
            
            if glbPlcObjectId.count < questionLimit {
                questionLimit = glbPlcObjectId.count
            }
            
            for _ in 0 ..< questionLimit {
                
                let randomIndex = Int(arc4random_uniform(UInt32(glbPlcObjectId.count - 1)))
                
                option1.append(glbPlcOption1[randomIndex])
                option2.append(glbPlcOption2[randomIndex])
                option3.append(glbPlcOption3[randomIndex])
                option4.append(glbPlcOption4[randomIndex])
                imageFile.append(glbPlcImageFile[randomIndex])
                correctAnswer.append(glbPlcCorrectAnswer[randomIndex])
                descriptionEng.append(glbPlcDescriptionEng[randomIndex])
                questionCompleted.append(glbPlcObjectId[randomIndex])
                
                showDetail.append(false)
                userRecord.append(false)
                
                glbPlcOption1.remove(at: randomIndex)
                glbPlcOption2.remove(at: randomIndex)
                glbPlcOption3.remove(at: randomIndex)
                glbPlcOption4.remove(at: randomIndex)
                glbPlcImageFile.remove(at: randomIndex)
                glbPlcCorrectAnswer.remove(at: randomIndex)
                glbPlcDescriptionEng.remove(at: randomIndex)
                glbPlcObjectId.remove(at: randomIndex)
            }
            tableView.reloadData()
        }
        createProgressBar()
        
    }
    
    @objc func timeCount() {
        
        timeRemaining = timeRemaining - 1
        
        if timeRemaining <= 0 {
            timer.invalidate()
            timeLabel.text = "\(0)"
            quizCompleted()
            let userScoreQuery = PFQuery(className: "UserScore")
            userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            userScoreQuery.findObjectsInBackground { [unowned self] (objects, error) in
                if let score = objects?.first {
                    if let totalScore = Int(score["score"] as! String) {
                        self.totalScoreAfterTest = totalScore + self.scorePoint
                        self.showPopup(Score: self.scorePoint, totalScore: self.totalScoreAfterTest)
                        
                        score["userId"] = PFUser.current()?.objectId
                        score["score"] = String(self.totalScoreAfterTest)
                        score.saveInBackground()
                        
                    }
                    else {
                        self.totalScoreAfterTest = self.scorePoint
                        self.showPopup(Score: self.scorePoint, totalScore: self.totalScoreAfterTest)
                        
                        score["userId"] = PFUser.current()?.objectId
                        score["score"] = String(self.totalScoreAfterTest)
                        score.saveInBackground()
                    }
                }
                else {
                    self.totalScoreAfterTest = self.scorePoint
                    self.showPopup(Score: self.scorePoint, totalScore: self.totalScoreAfterTest)
                    
                    let score = PFObject(className: "UserScore")
                    score["userId"] = PFUser.current()?.objectId
                    score["score"] = String(self.totalScoreAfterTest)
                    score.saveInBackground()
                }
            }

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
        let rowToSelect: IndexPath = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: rowToSelect, at: .top, animated: false)


        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
        popOverVC.scoreWin = Score
        popOverVC.totalScore = totalScore
        popOverVC.delegate = self
        
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.bounds//self.view.frame
        //complete.isEnabled = false
        //back.isEnabled = false
        
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        

        
    }
    
    func quizCompleted() {
        let sectionNo = 0
        complete.title = "Next"

        if isCompleted == false {
            isCompleted = true
            /*let nofQuestions = correctAnswer.count
            
            if nofQuestions > 0 {
                for rowNo in 0...nofQuestions-1 {
                    
                    let rowToSelect: IndexPath = IndexPath(row: rowNo, section: sectionNo)
                    self.tableView.reloadRows(at: [rowToSelect], with: .fade)
                }
            }*/
            
            tableView.reloadData()
        }
        var indx = 0
        getQuizScore()
        for question in questionCompleted {
            
            if userRecord[indx] == true {
                print("User Record is true, index: \(indx)")
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
        
        let spacing: CGFloat = 5 // the amount of spacing to appear between image and title
        cell.markOption1.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        cell.markOption1.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption1.imageView?.contentMode = .scaleAspectFit
        cell.markOption1.setTitleColor(UIColor.black, for: .normal)
        cell.markOption1.layer.borderWidth = 0

        cell.markOption2.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        cell.markOption2.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption2.imageView?.contentMode = .scaleAspectFit
        cell.markOption2.setTitleColor(UIColor.black, for: .normal)
        cell.markOption2.layer.borderWidth = 0

        cell.markOption3.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        cell.markOption3.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption3.imageView?.contentMode = .scaleAspectFit
        cell.markOption3.setTitleColor(UIColor.black, for: .normal)
        cell.markOption3.layer.borderWidth = 0
        
        cell.markOption4.imageEdgeInsets = UIEdgeInsetsMake(5, 5, 5, spacing);
        cell.markOption4.titleEdgeInsets = UIEdgeInsetsMake(0, spacing, 0, 0);
        cell.markOption4.imageView?.contentMode = .scaleAspectFit
        cell.markOption4.setTitleColor(UIColor.black, for: .normal)
        cell.markOption4.layer.borderWidth = 0
        
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
        
        
        /*cell.detailsButton.backgroundColor = .clear
        cell.detailsButton.layer.cornerRadius = 5
        cell.detailsButton.layer.borderWidth = 1
        cell.detailsButton.layer.borderColor = UIColor.black.cgColor*/
        
        /*let screenSize = UIScreen.main.bounds
        
        if screenSize.width < 350 {
            cell.toDoListButton.titleLabel?.font = .systemFont(ofSize: 14)
            cell.detailsButton.titleLabel?.font = .systemFont(ofSize: 14)
        }
        else {
            cell.toDoListButton.titleLabel?.font = .systemFont(ofSize: 15)
            cell.detailsButton.titleLabel?.font = .systemFont(ofSize: 15)
        }*/
        
        cell.layer.cornerRadius=20 //set corner radius here
        cell.layer.borderColor = UIColor.lightGray.cgColor  // set cell border color here
        cell.layer.borderWidth = 2 // set border width here
        
        //print("Row: \(indexPath.row) showDetail: \(showDetail) Completed: \(isCompleted)")
        
        if (showDetail[indexPath.row] == true)/* && (detailCellRow == indexPath.row)*/ {

            //cell.placeImage.isHidden = true
            cell.markOption1.isHidden = true
            cell.markOption2.isHidden = true
            cell.markOption3.isHidden = true
            cell.markOption4.isHidden = true
            cell.detailsButton.isHidden = false
            cell.toDoListButton.isHidden = false
            cell.detailsButton.setTitle("Back", for: [])
            
            cell.detailText.isHidden = false
            cell.detailText.text = descriptionEng[indexPath.row]
            cell.detailText.sizeToFit()
            cell.detailText.numberOfLines = 0
            
            imageFile[indexPath.row].getDataInBackground { (data, error) in
                
                if let imageData = data {
                    
                    if let imageToDisplay = UIImage(data: imageData) {
                        
                        cell.placeImage.image = imageToDisplay
                        
                        // test
                        
                        /*let boundsScale = cell.placeImage.bounds.size.width / cell.placeImage.bounds.size.height
                        let imageScale = imageToDisplay.size.width / imageToDisplay.size.height
                        
                        var drawingRect: CGRect = cell.placeImage.bounds
                        
                        if boundsScale > imageScale {
                            drawingRect.size.width =  drawingRect.size.height * imageScale
                            drawingRect.origin.x = (cell.placeImage.bounds.size.width - drawingRect.size.width) / 2
                        } else {
                            drawingRect.size.height = drawingRect.size.width / imageScale
                            drawingRect.origin.y = (cell.placeImage.bounds.size.height - drawingRect.size.height) / 2
                        }
                        let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: 10)
                        let mask = CAShapeLayer()
                        mask.path = path.cgPath
                        cell.placeImage.layer.mask = mask*/
                        
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
                        
                        // test
                        
                        /*let boundsScale = cell.placeImage.bounds.size.width / cell.placeImage.bounds.size.height
                        let imageScale = imageToDisplay.size.width / imageToDisplay.size.height
                        
                        var drawingRect: CGRect = cell.placeImage.bounds
                        
                        if boundsScale > imageScale {
                            drawingRect.size.width =  drawingRect.size.height * imageScale
                            drawingRect.origin.x = (cell.placeImage.bounds.size.width - drawingRect.size.width) / 2
                        } else {
                            drawingRect.size.height = drawingRect.size.width / imageScale
                            drawingRect.origin.y = (cell.placeImage.bounds.size.height - drawingRect.size.height) / 2
                        }
                        let path = UIBezierPath(roundedRect: drawingRect, cornerRadius: 10)
                        let mask = CAShapeLayer()
                        mask.path = path.cgPath
                        cell.placeImage.layer.mask = mask*/
                        
                    
                    }
                }
            
            }
            
            cell.markOption1.isHidden = false
            cell.markOption2.isHidden = false
            cell.markOption3.isHidden = false
            cell.markOption4.isHidden = false
        
            cell.detailText.isHidden = true
            
            cell.markOption1.setTitle(option1[indexPath.row], for: [])
            cell.markOption2.setTitle(option2[indexPath.row], for: [])
            cell.markOption3.setTitle(option3[indexPath.row], for: [])
            cell.markOption4.setTitle(option4[indexPath.row], for: [])

            
            cell.markOption1.setImage(UIImage(named: "uncheck.png"), for: [])
            cell.markOption2.setImage(UIImage(named: "uncheck.png"), for: [])
            cell.markOption3.setImage(UIImage(named: "uncheck.png"), for: [])
            cell.markOption4.setImage(UIImage(named: "uncheck.png"), for: [])

            let questionIndex = questionNo.index(of: indexPath.row)
            
            if let qIndex = questionIndex {
                let answerIndex = answer[qIndex]
                if answerIndex == 1 {
                    cell.markOption1.setImage(UIImage(named: "check.png"), for: [])
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
            cell.toDoListButton.isHidden = true

            cell.markOption1.isEnabled = true
            cell.markOption2.isEnabled = true
            cell.markOption3.isEnabled = true
            cell.markOption4.isEnabled = true

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

                        //cell.markOption1.setImage(UIImage(named: "correct2.png"), for: [])
                        cell.markOption1.setTitleColor(UIColor(rgb: 0x039D18), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption1.setImage(tintedImage, for: .normal)
                        cell.markOption1.tintColor = UIColor(rgb: 0x039D18)//UIColor.green
                    }
                    else if selected == 2 {

                        //cell.markOption2.setImage(UIImage(named: "correct2.png"), for: [])
                        cell.markOption2.setTitleColor(UIColor(rgb: 0x039D18), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption2.setImage(tintedImage, for: .normal)
                        cell.markOption2.tintColor = UIColor(rgb: 0x039D18)//UIColor.green
                    }
                    else if selected == 3 {
                        //cell.markOption3.setImage(UIImage(named: "correct2.png"), for: [])
                        cell.markOption3.setTitleColor(UIColor(rgb: 0x039D18), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption3.setImage(tintedImage, for: .normal)
                        cell.markOption3.tintColor = UIColor(rgb: 0x039D18)//UIColor.green
                    }
                    else if selected == 4 {

                        //cell.markOption4.setImage(UIImage(named: "correct2.png"), for: [])
                        cell.markOption4.setTitleColor(UIColor(rgb: 0x039D18), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption4.setImage(tintedImage, for: .normal)
                        cell.markOption4.tintColor = UIColor(rgb: 0x039D18)//UIColor.green
                    }
                }
                else if status == 0 {

                    if selected == 1 {
                    
                       //cell.markOption1.setImage(UIImage(named: "wrong.gif"), for: .normal)
                        cell.markOption1.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption1.setImage(tintedImage, for: .normal)
                        cell.markOption1.tintColor = UIColor(rgb: 0xC20F16)
                    
                    }
                    else if selected == 2 {
                    
                        //cell.markOption2.setImage(UIImage(named: "wrong.gif"), for: [])
                        cell.markOption2.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption2.setImage(tintedImage, for: .normal)
                        cell.markOption2.tintColor = UIColor(rgb: 0xC20F16)

                    
                    }
                    else if selected == 3 {
                    
                        //cell.markOption3.setImage(UIImage(named: "wrong.gif"), for: [])
                        cell.markOption3.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption3.setImage(tintedImage, for: .normal)
                        cell.markOption3.tintColor = UIColor(rgb: 0xC20F16)
                    
                    }
                    else if selected == 4 {
                    
                        //cell.markOption4.setImage(UIImage(named: "wrong.gif"), for: [])
                        cell.markOption4.setTitleColor(UIColor(rgb: 0xC20F16), for: .normal)
                        let origImage = UIImage(named: "check.png");
                        let tintedImage = origImage?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
                        cell.markOption4.setImage(tintedImage, for: .normal)
                        cell.markOption4.tintColor = UIColor(rgb: 0xC20F16)
                    
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
        

        if let tappedIndexPath = tableView.indexPath(for: sender) {
            glbToDoItemPlaceOrFood.append("Place")
            glbToDoItemCompleted.append(false)
            glbToDoItemDescriptions.append(descriptionEng[tappedIndexPath.row])
            glbToDoItemImageFile.append(imageFile[tappedIndexPath.row])
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
            toDoItem["PlaceOrFood"] = "Place"
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
    
    func pullQuizItems() {
        questionSeenBefore.removeAll()
        option1.removeAll()
        option2.removeAll()
        option3.removeAll()
        option4.removeAll()
        imageFile.removeAll()
        correctAnswer.removeAll()
        descriptionEng.removeAll()
        descriptionTr.removeAll()
        showDetail.removeAll()
        questionCompleted.removeAll()
        userRecord.removeAll()
        answer.removeAll()
        questionNo.removeAll()
        scorePoint = 0
        
        
        
        // New code
        print("Global Objects before: \(glbPlcObjectId)")
        if glbPlcObjectId.count < 10 {
            questionSeenBefore.removeAll()
            let questionCoveredQuery = PFQuery(className: "placesCoveredBefore")
            questionCoveredQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
            questionCoveredQuery.findObjectsInBackground { [unowned self] (objects, error) in
                
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
                
                if glbPlcObjectId.count > 0 {
                    for indx in 0 ..< glbPlcObjectId.count {
                        self.questionSeenBefore.append(glbPlcObjectId[indx])
                    }
                }
                print("Question Seen Before: \(self.questionSeenBefore)")

                let placesQuery = PFQuery(className: "Places")
                placesQuery.whereKey("objectId", notContainedIn: self.questionSeenBefore)
                placesQuery.findObjectsInBackground { [unowned self] (objects, error) in
                    if let places = objects {
                        
                        for place in places {
                            
                            glbPlcOption1.append(place["alternative1"] as! String)
                            glbPlcOption2.append(place["alternative2"] as! String)
                            glbPlcOption3.append(place["alternative3"] as! String)
                            glbPlcOption4.append(place["alternative4"] as! String)
                            glbPlcImageFile.append(place["imageFile"] as! PFFile)
                            glbPlcCorrectAnswer.append(place["correctAlternative"] as! String)
                            glbPlcDescriptionEng.append(place["engDescription"] as! String)
                            
                            if let question = place.objectId {
                                glbPlcObjectId.append(question)
                            }
                        }
                    }
                    print("Pulled onjects: \(glbPlcObjectId)")
                    var questionLimit = 4
                    
                    if glbPlcObjectId.count < questionLimit {
                        questionLimit = glbPlcObjectId.count
                    }
                    print("Global Objects after: \(glbPlcObjectId)")
                    for _ in 0 ..< questionLimit {
                        
                        let randomIndex = Int(arc4random_uniform(UInt32(glbPlcObjectId.count - 1)))
                        
                        self.option1.append(glbPlcOption1[randomIndex])
                        self.option2.append(glbPlcOption2[randomIndex])
                        self.option3.append(glbPlcOption3[randomIndex])
                        self.option4.append(glbPlcOption4[randomIndex])
                        self.imageFile.append(glbPlcImageFile[randomIndex])
                        self.correctAnswer.append(glbPlcCorrectAnswer[randomIndex])
                        self.descriptionEng.append(glbPlcDescriptionEng[randomIndex])
                        self.questionCompleted.append(glbPlcObjectId[randomIndex])
                        
                        self.showDetail.append(false)
                        self.userRecord.append(false)
                        
                        glbPlcOption1.remove(at: randomIndex)
                        glbPlcOption2.remove(at: randomIndex)
                        glbPlcOption3.remove(at: randomIndex)
                        glbPlcOption4.remove(at: randomIndex)
                        glbPlcImageFile.remove(at: randomIndex)
                        glbPlcCorrectAnswer.remove(at: randomIndex)
                        glbPlcDescriptionEng.remove(at: randomIndex)
                        glbPlcObjectId.remove(at: randomIndex)
                    }
                    self.tableView.reloadData()
                    
                }
                
            }
            
        }
        else {
            var questionLimit = 4
            
            if glbPlcObjectId.count < questionLimit {
                questionLimit = glbPlcObjectId.count
            }
            print("Global Objects after: \(glbPlcObjectId)")
            for _ in 0 ..< questionLimit {
                
                let randomIndex = Int(arc4random_uniform(UInt32(glbPlcObjectId.count - 1)))
                
                option1.append(glbPlcOption1[randomIndex])
                option2.append(glbPlcOption2[randomIndex])
                option3.append(glbPlcOption3[randomIndex])
                option4.append(glbPlcOption4[randomIndex])
                imageFile.append(glbPlcImageFile[randomIndex])
                correctAnswer.append(glbPlcCorrectAnswer[randomIndex])
                descriptionEng.append(glbPlcDescriptionEng[randomIndex])
                questionCompleted.append(glbPlcObjectId[randomIndex])
                
                showDetail.append(false)
                userRecord.append(false)
                
                glbPlcOption1.remove(at: randomIndex)
                glbPlcOption2.remove(at: randomIndex)
                glbPlcOption3.remove(at: randomIndex)
                glbPlcOption4.remove(at: randomIndex)
                glbPlcImageFile.remove(at: randomIndex)
                glbPlcCorrectAnswer.remove(at: randomIndex)
                glbPlcDescriptionEng.remove(at: randomIndex)
                glbPlcObjectId.remove(at: randomIndex)
            }
            tableView.reloadData()
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
                        scorePoint = scorePoint + 7
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
            progressLayer.strokeColor = complete.tintColor?.cgColor
            progressLayer.strokeEnd = 0.0
            
            navigationBar.layer.addSublayer(progressLayer)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "placesBackSegue" {
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
