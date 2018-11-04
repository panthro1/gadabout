//
//  puzzleMapViewController.swift
//  gadabout
//
//  Created by Ahmet on 17.09.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse


class puzzleMapViewController: UIViewController {

    
    var allImgViews = [UIImageView]()
    var allCenters = [CGPoint]()
    var emptySpot: CGPoint = CGPoint(x: 0, y: 0)
    var tapCenter: CGPoint = CGPoint(x: 0, y: 0)
    var left: CGPoint = CGPoint(x: 0, y: 0)
    var right: CGPoint = CGPoint(x: 0, y: 0)
    var top: CGPoint = CGPoint(x: 0, y: 0)
    var bottom: CGPoint = CGPoint(x: 0, y: 0)
    var leftIsEmpty : Bool = false
    var rightIsEmpty : Bool = false
    var topIsEmpty : Bool = false
    var bottomIsEmpty : Bool = false
    var isHintDisplayed: Bool = false
    var startTime = Date()
    var harder: Bool = false
    
    
    var option1: String = ""
    var option2: String = ""
    var option3: String = ""
    var option4: String = ""
    var descriptionEng: String = ""
    var descriptionTr: String = ""
    var correctAnswer : String = ""
    var imageFile = [PFFile]()
    var nofPlaceInstances: Int32 = 0
    var nofFoodInstances: Int32 = 0
    var placeFoodSelection: UInt32 = 0
    var myPicture = UIImage()

    
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var harderSimpleButton: UIButton!
    
    func displayAlert(title: String, message: String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            //self.dismiss(animated: true, completion: nil)
        }))
        
        self.present(alert, animated: true, completion: nil)
        
    }

    @IBAction func harderTapped(_ sender: Any) {
        let button = sender as? UIButton
        button?.shake()
        
        if harder == false {
            harder = true
            
            
            let nofRows = 3
            let nofColumns = 3
            
            for row in 0 ..< nofRows {
                for col in 0 ..< nofColumns {
                    
                    if let viewWithTag = self.view.viewWithTag(10+row*3+col) {
                        viewWithTag.removeFromSuperview()
                    }
                    
                }
            }
            allImgViews.removeAll()
            allCenters.removeAll()
            
            
            let images = slice(image: myPicture, into: 4)
            
            
            let nofRowsHard = 4
            let nofColumnsHard = 4
            
            var xCent: Int = 10+48
            var yCent: Int = 100+48
            
            for row in 0 ..< nofRowsHard {
                for col in 0 ..< nofColumnsHard {
                    
                    var myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: 96, height: 96))
                    let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                    allCenters.append(currCent)
                    myImgView.center = currCent
                    myImgView.image = images[row*4+col]
                    myImgView.isUserInteractionEnabled = true
                    myImgView.tag = 10+row*4+col
                    allImgViews.append(myImgView)
                    self.view.addSubview(myImgView)
                    xCent += 96
                    
                }
                xCent = 10+48
                yCent += 96
            }
            harderSimpleButton.setTitle("Back to simple", for: .normal)
        }
        else {
            harder = false
            
            
            let nofRows = 4
            let nofColumns = 4
            
            for row in 0 ..< nofRows {
                for col in 0 ..< nofColumns {
                    
                    if let viewWithTag = self.view.viewWithTag(10+row*4+col) {
                        viewWithTag.removeFromSuperview()
                    }
                    
                }
            }
            allImgViews.removeAll()
            allCenters.removeAll()
            
            
            let images = slice(image: myPicture, into: 4)
            
            
            let nofRowsHard = 3
            let nofColumnsHard = 3
            
            var xCent: Int = 10+48/3*4
            var yCent: Int = 100+48/3*4
            
            for row in 0 ..< nofRowsHard {
                for col in 0 ..< nofColumnsHard {
                    
                    var myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: 96/3*4, height: 96/3*4))
                    let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                    allCenters.append(currCent)
                    myImgView.center = currCent
                    myImgView.image = images[row*3+col]
                    myImgView.isUserInteractionEnabled = true
                    myImgView.tag = 10+row*3+col
                    allImgViews.append(myImgView)
                    self.view.addSubview(myImgView)
                    xCent += 96/3*4
                    
                }
                xCent = 10+48/3*4
                yCent += 96/3*4
            }
            harderSimpleButton.setTitle("Make it harder", for: .normal)
        }
        self.randomizeBlocks()
        allImgViews[0].removeFromSuperview()
        
        leftIsEmpty = false
        rightIsEmpty = false
        topIsEmpty = false
        bottomIsEmpty = false
        startTime = Date()

        
    }
    
    
    @IBAction func backTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "mapPuzzleBackSegue", sender: self)
    }
    
    @IBAction func hintTapped(_ sender: Any) {
        
        let button = sender as? UIButton
        button?.flash()
        
        if isHintDisplayed == false {
            var imageView : UIImageView
            imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 96*4, height: 96*4))
            imageView.tag = 100
            imageView.image = myPicture
            self.view.addSubview(imageView)
            isHintDisplayed = true
            hintButton.setTitle("Back to Puzzle", for: [])
        }
        else {
            if let viewWithTag = self.view.viewWithTag(100) {
                viewWithTag.removeFromSuperview()
                isHintDisplayed = false
                hintButton.setTitle("Hint", for: [])
            }
        }
        showPopup(Score: 3, totalScore: 5)
    }
    func slice(image: UIImage, into howMany: Int) -> [UIImage] {
        let width: CGFloat
        let height: CGFloat
        
        switch image.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            width = image.size.height
            height = image.size.width
        default:
            width = image.size.width
            height = image.size.height
        }
        
        let tileWidth = Int(width / CGFloat(howMany))
        let tileHeight = Int(height / CGFloat(howMany))
        
        let scale = Int(image.scale)
        var images = [UIImage]()
        
        let cgImage = image.cgImage!
        
        var adjustedHeight = tileHeight
        
        var y = 0
        for row in 0 ..< howMany {
            if row == (howMany - 1) {
                adjustedHeight = Int(height) - y
            }
            var adjustedWidth = tileWidth
            var x = 0
            for column in 0 ..< howMany {
                if column == (howMany - 1) {
                    adjustedWidth = Int(width) - x
                }
                let origin = CGPoint(x: x * scale, y: y * scale)
                let size = CGSize(width: adjustedWidth * scale, height: adjustedHeight * scale)
                let tileCgImage = cgImage.cropping(to: CGRect(origin: origin, size: size))!
                images.append(UIImage(cgImage: tileCgImage, scale: image.scale, orientation: image.imageOrientation))
                x += tileWidth
            }
            y += tileHeight
        }
        return images
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        harderSimpleButton.backgroundColor = .clear
        harderSimpleButton.layer.cornerRadius = 5
        harderSimpleButton.layer.borderWidth = 1
        harderSimpleButton.layer.borderColor = UIColor.black.cgColor
        
        hintButton.layer.cornerRadius = 5
        hintButton.layer.borderWidth = 1
        hintButton.layer.borderColor = UIColor.black.cgColor


        
        placeFoodSelection = arc4random_uniform(2)
        print("Random Index: \(placeFoodSelection)")
        
        let nofInstancePlaceQuery = PFQuery(className: "Places")
        nofInstancePlaceQuery.countObjectsInBackground { (count, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.nofPlaceInstances = count
                print("Total place instances: \(count)")
            }
            
            if self.placeFoodSelection == 0 {
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.nofPlaceInstances)))
                print("Random Index for Places: \(randomIndex)")
                
                let placesQuery = PFQuery(className: "Places")
                
                placesQuery.limit = 1
                placesQuery.skip = randomIndex
                self.imageFile.removeAll()
                
                placesQuery.findObjectsInBackground { (objects, error) in
                    
                    
                    if let places = objects {
                        
                        for place in places {
                            
                            self.option1 = place["alternative1"] as! String
                            self.option2 = place["alternative2"] as! String
                            self.option3 = place["alternative3"] as! String
                            self.option4 = place["alternative4"] as! String
                            self.imageFile.append(place["imageFile"] as! PFFile)
                            self.correctAnswer = place["correctAlternative"] as! String
                            self.descriptionEng = place["engDescription"] as! String
                            self.descriptionTr = place["trDescription"] as! String
                            
                        }
                    }
                    
                    self.imageFile[0].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.myPicture = imageToDisplay
                                
                                let images = self.slice(image: self.myPicture, into: 3)
                                
                                var xCent: Int = 10+48/3*4
                                var yCent: Int = 100+48/3*4
                                
                                let nofRows = 3
                                let nofColumns = 3
                                
                                for row in 0 ..< nofRows {
                                    for col in 0 ..< nofColumns {
                                        let myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: 96/3*4, height: 96/3*4))
                                        let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                                        self.allCenters.append(currCent)
                                        myImgView.center = currCent
                                        myImgView.image = images[row*3+col]
                                        myImgView.isUserInteractionEnabled = true
                                        myImgView.tag = 10+row*3+col
                                        self.allImgViews.append(myImgView)
                                        self.view.addSubview(myImgView)
                                        xCent += 96/3*4
                                        
                                    }
                                    xCent = 10+48/3*4
                                    yCent += 96/3*4
                                }
                                self.randomizeBlocks()
                                self.allImgViews[0].removeFromSuperview()
                                
                                self.leftIsEmpty = false
                                self.rightIsEmpty = false
                                self.topIsEmpty = false
                                self.bottomIsEmpty = false
                                self.startTime = Date()

                            }
                        }
                        
                    }
                    
                    
                        

                    if let correctAnsInt = Int(self.correctAnswer) {
                        
                        /*if correctAnsInt == 1 {
                            self.headerLabel.text = self.option1
                        }
                        else if correctAnsInt == 2 {
                            self.headerLabel.text = self.option2
                        }
                        else if correctAnsInt == 3 {
                            self.headerLabel.text = self.option3
                        }
                        else if correctAnsInt == 4 {
                            self.headerLabel.text = self.option4
                        }*/
                    }
                    /*self.descriptionText.text = self.descriptionEng
                    self.descriptionText.isHidden = false
                    self.headerLabel.isHidden = false
                    self.image.isHidden = false*/
                    
                    
                    
                    
                }
                
            }
        }
        
        let nofInstanceFoodQuery = PFQuery(className: "Foods")
        nofInstanceFoodQuery.countObjectsInBackground { (count, error) in
            
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                self.nofFoodInstances = count
                print("Total place instances: \(count)")
            }
            
            if self.placeFoodSelection == 1 {
                
                let randomIndex = Int(arc4random_uniform(UInt32(self.nofFoodInstances)))
                print("Random Index for Foods: \(randomIndex)")
                
                let placesQuery = PFQuery(className: "Foods")
                
                placesQuery.limit = 1
                placesQuery.skip = randomIndex
                self.imageFile.removeAll()
                
                placesQuery.findObjectsInBackground { (objects, error) in
                    
                    
                    if let places = objects {
                        
                        for place in places {
                            
                            self.option1 = place["alternative1"] as! String
                            self.option2 = place["alternative2"] as! String
                            self.option3 = place["alternative3"] as! String
                            self.option4 = place["alternative4"] as! String
                            self.imageFile.append(place["imageFile"] as! PFFile)
                            self.correctAnswer = place["correctAlternative"] as! String
                            self.descriptionEng = place["engDescription"] as! String
                            self.descriptionTr = place["trDescription"] as! String
                            
                        }
                    }
                    
                    self.imageFile[0].getDataInBackground { (data, error) in
                        
                        if let imageData = data {
                            
                            if let imageToDisplay = UIImage(data: imageData) {
                                
                                self.myPicture = imageToDisplay
                                
                                let images = self.slice(image: self.myPicture, into: 3)
                                
                                var xCent: Int = 10+48/3*4
                                var yCent: Int = 100+48/3*4
                                
                                let nofRows = 3
                                let nofColumns = 3
                                
                                for row in 0 ..< nofRows {
                                    for col in 0 ..< nofColumns {
                                        var myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: 96/3*4, height: 96/3*4))
                                        let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                                        self.allCenters.append(currCent)
                                        myImgView.center = currCent
                                        myImgView.image = images[row*3+col]
                                        myImgView.isUserInteractionEnabled = true
                                        myImgView.tag = 10+row*3+col
                                        self.allImgViews.append(myImgView)
                                        self.view.addSubview(myImgView)
                                        xCent += 96/3*4
                                        
                                    }
                                    xCent = 10+48/3*4
                                    yCent += 96/3*4
                                }
                                
                                self.randomizeBlocks()
                                self.allImgViews[0].removeFromSuperview()
                                
                                self.leftIsEmpty = false
                                self.rightIsEmpty = false
                                self.topIsEmpty = false
                                self.bottomIsEmpty = false
                                self.startTime = Date()

                                
                            }
                        }
                        
                    }
                    if let correctAnsInt = Int(self.correctAnswer) {
                        
                        /*if correctAnsInt == 1 {
                            self.headerLabel.text = self.option1
                        }
                        else if correctAnsInt == 2 {
                            self.headerLabel.text = self.option2
                        }
                        else if correctAnsInt == 3 {
                            self.headerLabel.text = self.option3
                        }
                        else if correctAnsInt == 4 {
                            self.headerLabel.text = self.option4
                        }*/
                    }
                    /*self.descriptionText.text = self.descriptionEng
                    self.descriptionText.isHidden = false
                    self.headerLabel.isHidden = false
                    self.image.isHidden = false*/
                }
                
            }
        }
    }
    
    
    func randomizeBlocks() {

        var randLoc: CGPoint
        var centersCopied = self.allCenters
        
        //centersCopied = allCenters
        
        for img in allImgViews {
            let randomIndex = Int(arc4random_uniform(UInt32(centersCopied.count)))
            randLoc = centersCopied[randomIndex]
            
            img.center = randLoc
            centersCopied.remove(at: randomIndex)
        }
        emptySpot = allImgViews[0].center
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let myTouch: UITouch = touches.first as! UITouch
        
        if myTouch.view != self.view {
            tapCenter = (myTouch.view?.center)!
            
            if harder == false {
                left = CGPoint(x: tapCenter.x - 96/3*4, y: tapCenter.y)
                right = CGPoint(x: tapCenter.x + 96/3*4, y: tapCenter.y)
                top = CGPoint(x: tapCenter.x, y: tapCenter.y + 96/3*4)
                bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - 96/3*4)
            }
            else {
                left = CGPoint(x: tapCenter.x - 96, y: tapCenter.y)
                right = CGPoint(x: tapCenter.x + 96, y: tapCenter.y)
                top = CGPoint(x: tapCenter.x, y: tapCenter.y + 96)
                bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - 96)
            }
            
            if emptySpot.equalTo(left) {
                leftIsEmpty = true
            }
            if emptySpot.equalTo(right) {
                rightIsEmpty = true
            }
            if emptySpot.equalTo(top) {
                topIsEmpty = true
            }
            if emptySpot.equalTo(bottom) {
                bottomIsEmpty = true
            }
            
            if leftIsEmpty || rightIsEmpty || topIsEmpty || bottomIsEmpty {
                UIView.beginAnimations(nil, context: nil)
                UIView.setAnimationDuration(0.3)
                
                myTouch.view?.center = emptySpot
                UIView.commitAnimations()
                
                emptySpot = tapCenter
                leftIsEmpty = false
                rightIsEmpty = false
                topIsEmpty = false
                bottomIsEmpty = false
                
                var xCent: Int = 10+48/3*4
                var yCent: Int = 100+48/3*4
                
                if harder {
                    xCent = 10+48
                    yCent = 100+48
                }
                
                var nofRows: UInt8 = 3
                var nofColumns: UInt8 = 3
                
                if harder {
                    nofRows = 4
                    nofColumns = 4
                }
                
                
                var completed: Bool = true
                
                for row in 0 ..< nofRows {
                    for col in 0 ..< nofColumns {
                        if row == 0 && col == 0 {
                            completed = true
                        }
                        else {
                            var currCent:CGPoint = allImgViews[Int(row)*3+Int(col)].center
                            if harder {
                                currCent = allImgViews[Int(row)*4+Int(col)].center
                            }
                            let mustBe = CGPoint(x: xCent, y: yCent)
                            if currCent.equalTo(mustBe) {
                                completed = true
                            }
                            else {
                                completed = false
                                break
                            }
                        }
                        if harder == false {
                            xCent += 96/3*4
                        }
                        else {
                            xCent += 96
                        }
                    }
                    if harder == false {
                        xCent = 10+48/3*4
                        yCent += 96/3*4
                    }
                    else {
                        xCent = 10+48
                        yCent += 96

                    }
                    
                    if completed == false {
                        break
                    }
                }
                if completed == true {
                    let endTime = Date()
                    let seconds = endTime.timeIntervalSince(self.startTime)
                    let formatted = String(format: "%.1f", seconds)
                    self.displayAlert(title: "Puzzle completed", message: " You have completed in \(formatted) seconds.")
                    showPopup(Score: 3, totalScore: 5)
                    print("Puzzle Completed")
                }            }
        }
        
    }
    func showPopup(Score: Int, totalScore: Int) {
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "scorePopUpID") as! scorePopUpViewController
        popOverVC.scoreWin = Score
        popOverVC.totalScore = totalScore
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.frame
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
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
