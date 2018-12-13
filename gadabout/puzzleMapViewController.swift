//
//  puzzleMapViewController.swift
//  gadabout
//
//  Created by Ahmet on 17.09.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import Parse
import GoogleMobileAds


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

    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBOutlet weak var bannerView: GADBannerView!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBOutlet weak var harderSimpleButton: UIButton!
    
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        
        let activityIndicator = UIActivityIndicatorView(frame: CGRect(x: self.view.center.x, y: self.view.center.y, width: 100, height: 100))
        activityIndicator.transform = CGAffineTransform(scaleX: 2, y: 2)
        activityIndicator.center = self.view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        view.addSubview(activityIndicator)
        activityIndicator.startAnimating()
        UIApplication.shared.beginIgnoringInteractionEvents()

        
        var nofRows = 3
        var nofColumns = 3
        
        if harder == true {
            nofRows = 4
            nofColumns = 4
        }
        
        for row in 0 ..< nofRows {
            for col in 0 ..< nofColumns {
                
                if let viewWithTag = self.view.viewWithTag(10+row*nofRows+col) {
                    viewWithTag.removeFromSuperview()
                }
                
            }
        }
        allImgViews.removeAll()
        allCenters.removeAll()
        
        let randomIndex = Int(arc4random_uniform(UInt32(self.imageFile.count)))
        
        self.imageFile[randomIndex].getDataInBackground { (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    self.myPicture = imageToDisplay
                    
                    let images = self.slice(image: self.myPicture, into: nofRows)
                    
                    let screenSize = UIScreen.main.bounds
                    
                    var imageHeightAndWeight = Int(floor((screenSize.width*0.96)/3))
                    let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
                    let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
                    
                    if self.harder == true {
                        imageHeightAndWeight = Int(floor((screenSize.width*0.96)/4))
                    }
                    
                    var xCent: Int = Int(0.02*screenSize.width) + imageHeightAndWeight/2
                    var yCent: Int = upperOffset + imageHeightAndWeight/2
                    
                    
                    for row in 0 ..< nofRows {
                        for col in 0 ..< nofColumns {
                            let myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: imageHeightAndWeight, height: imageHeightAndWeight))
                            let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                            self.allCenters.append(currCent)
                            myImgView.center = currCent
                            myImgView.image = images[row*nofRows+col]
                            myImgView.isUserInteractionEnabled = true
                            myImgView.tag = 10+row*nofRows+col
                            self.allImgViews.append(myImgView)
                            self.view.addSubview(myImgView)
                            xCent += imageHeightAndWeight
                            
                        }
                        xCent = Int(0.02*screenSize.width) + imageHeightAndWeight/2
                        yCent += imageHeightAndWeight
                    }
                    
                    self.randomizeBlocks()
                    self.allImgViews[0].removeFromSuperview()
                    
                    self.leftIsEmpty = false
                    self.rightIsEmpty = false
                    self.topIsEmpty = false
                    self.bottomIsEmpty = false
                    self.startTime = Date()

                    
                    /*var xCent: Int = 10+48/3*4
                    var yCent: Int = 100+48/3*4
                    
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
                    self.startTime = Date()*/
                    
                    
                    
                }
            }
            activityIndicator.stopAnimating()
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
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
        
        // New code
        let screenSize = UIScreen.main.bounds
        let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        var xCent: Int = 0
        var yCent: Int = 0
        
        
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
            
            
            let imageHeightAndWeight = Int(floor((screenSize.width*0.96)/4))
            let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
            
            xCent = Int(0.02*screenSize.width) + imageHeightAndWeight/2
            yCent = upperOffset + imageHeightAndWeight/2
            
            for row in 0 ..< nofRowsHard {
                for col in 0 ..< nofColumnsHard {
                    
                    var myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: imageHeightAndWeight, height: imageHeightAndWeight))
                    let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                    allCenters.append(currCent)
                    myImgView.center = currCent
                    myImgView.image = images[row*4+col]
                    myImgView.isUserInteractionEnabled = true
                    myImgView.tag = 10+row*4+col
                    allImgViews.append(myImgView)
                    self.view.addSubview(myImgView)
                    xCent += imageHeightAndWeight
                    
                }
                xCent = Int(0.02*screenSize.width) + imageHeightAndWeight/2
                yCent += imageHeightAndWeight
            }
            harderSimpleButton.setTitle("Back to simple ?", for: .normal)
           
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
            
            
            let images = slice(image: myPicture, into: 3)
            
            
            let nofRowsHard = 3
            let nofColumnsHard = 3
            
            let imageHeightAndWeight = Int(floor((screenSize.width*0.96)/3))
            let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
            
            xCent = Int(0.02*screenSize.width) + imageHeightAndWeight/2
            yCent = upperOffset + imageHeightAndWeight/2

            for row in 0 ..< nofRowsHard {
                for col in 0 ..< nofColumnsHard {
                    
                    var myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: imageHeightAndWeight, height: imageHeightAndWeight))
                    let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                    allCenters.append(currCent)
                    myImgView.center = currCent
                    myImgView.image = images[row*3+col]
                    myImgView.isUserInteractionEnabled = true
                    myImgView.tag = 10+row*3+col
                    allImgViews.append(myImgView)
                    self.view.addSubview(myImgView)
                    xCent += imageHeightAndWeight
                    
                }
                xCent = Int(0.02*screenSize.width) + imageHeightAndWeight/2
                yCent += imageHeightAndWeight
            }
            harderSimpleButton.setTitle("Make it harder ?", for: .normal)
        }
        self.randomizeBlocks()
        allImgViews[0].removeFromSuperview()
        let test = getInversionCount()
        
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
            
            let screenSize = UIScreen.main.bounds
            let imageHeightAndWeight = Int(floor(screenSize.width*0.96))
            let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
            let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
            let leftOffset = Int(0.02*screenSize.width)
            
            imageView = UIImageView(frame: CGRect(x: leftOffset, y: upperOffset, width: imageHeightAndWeight, height: imageHeightAndWeight))
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
        let screenSize = UIScreen.main.bounds
        
        /*harderSimpleButton.backgroundColor = .clear
        harderSimpleButton.layer.cornerRadius = 5
        harderSimpleButton.layer.borderWidth = 1
        harderSimpleButton.layer.borderColor = UIColor.black.cgColor*/
        
        hintButton.layer.cornerRadius = 5
        hintButton.layer.borderWidth = 1
        hintButton.layer.borderColor = UIColor.black.cgColor
        
        if screenSize.width < 350 {
            hintButton.titleLabel?.font = .systemFont(ofSize: 18)
            harderSimpleButton.titleLabel?.font = .systemFont(ofSize: 18)
        }
        else if screenSize.width < 400 {
            hintButton.titleLabel?.font = .systemFont(ofSize: 20)
            harderSimpleButton.titleLabel?.font = .systemFont(ofSize: 20)
        }
        else {
            hintButton.titleLabel?.font = .systemFont(ofSize: 22)
            harderSimpleButton.titleLabel?.font = .systemFont(ofSize: 22)
        }

        // Account ad
        //bannerView.adUnitID = "ca-app-pub-5745243428784846~5277829027"
        
        // Test add
        bannerView.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        
        bannerView.rootViewController = self
        bannerView.load(GADRequest())

        NotificationCenter.default.addObserver(self, selector: #selector(isRotated), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
        
        for indx in 0 ..< glbPlcImageFile.count {
            
            option1.append(glbPlcOption1[indx])
            option2.append(glbPlcOption2[indx])
            option3.append(glbPlcOption3[indx])
            option4.append(glbPlcOption4[indx])
            imageFile.append(glbPlcImageFile[indx])
            correctAnswer.append(glbPlcCorrectAnswer[indx])
            descriptionEng.append(glbPlcDescriptionEng[indx])
            //objectId.append(glbPlcObjectId[indx])
            //isPlace.append(true)
        }
        
        for indx in 0 ..< glbFdImageFile.count {
            
            option1.append(glbFdOption1[indx])
            option2.append(glbFdOption2[indx])
            option3.append(glbFdOption3[indx])
            option4.append(glbFdOption4[indx])
            imageFile.append(glbFdImageFile[indx])
            correctAnswer.append(glbFdCorrectAnswer[indx])
            descriptionEng.append(glbFdDescriptionEng[indx])
            //objectId.append(glbFdObjectId[indx])
            //isPlace.append(false)
        }

        
        
        let randomIndex = Int(arc4random_uniform(UInt32(imageFile.count)))
        
        self.imageFile[randomIndex].getDataInBackground { [unowned self] (data, error) in
            
            if let imageData = data {
                
                if let imageToDisplay = UIImage(data: imageData) {
                    
                    self.myPicture = imageToDisplay
                    
                    let images = self.slice(image: self.myPicture, into: 3)
                    
                    let imageHeightAndWeight = Int(floor((screenSize.width*0.96)/3))
                    let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
                    let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
                    
                    print("Navigation bar height: \(navBarHeight)")
                    
                    print("Screen width: \(screenSize.width)")
                    print("Image Height and Width: \(imageHeightAndWeight)")
                    print("Upper offset: \(upperOffset)")
                    
                    
                    var xCent: Int = Int(0.02*screenSize.width) + imageHeightAndWeight/2
                    var yCent: Int = upperOffset + imageHeightAndWeight/2
                    
                    let nofRows = 3
                    let nofColumns = 3
                    
                    for row in 0 ..< nofRows {
                        for col in 0 ..< nofColumns {
                            let myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: imageHeightAndWeight, height: imageHeightAndWeight))
                            let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                            self.allCenters.append(currCent)
                            myImgView.center = currCent
                            myImgView.image = images[row*3+col]
                            myImgView.isUserInteractionEnabled = true
                            myImgView.tag = 10+row*nofRows+col
                            self.allImgViews.append(myImgView)
                            self.view.addSubview(myImgView)
                            xCent += imageHeightAndWeight
                            
                        }
                        xCent = Int(0.02*screenSize.width) + imageHeightAndWeight/2
                        yCent += imageHeightAndWeight
                    }
                    
                    self.randomizeBlocks()
                    self.allImgViews[0].removeFromSuperview()
                    let test: Int = self.getInversionCount()
                    
                    
                    
                    self.leftIsEmpty = false
                    self.rightIsEmpty = false
                    self.topIsEmpty = false
                    self.bottomIsEmpty = false
                    self.startTime = Date()
                    
                    
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
        
        let screenSize = UIScreen.main.bounds
        
        var imageHeightAndWeight = floor((screenSize.width*0.96)/3)
        let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
        
        if harder == true {
            imageHeightAndWeight = floor((screenSize.width*0.96)/4)
        }
        
        if myTouch.view != self.view {
            tapCenter = (myTouch.view?.center)!
            

            left = CGPoint(x: tapCenter.x - imageHeightAndWeight, y: tapCenter.y)
            right = CGPoint(x: tapCenter.x + imageHeightAndWeight, y: tapCenter.y)
            top = CGPoint(x: tapCenter.x, y: tapCenter.y + imageHeightAndWeight)
            bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - imageHeightAndWeight)
            
            if emptySpot.equalTo(left) {
                leftIsEmpty = true
                print("Left is empty")
            }
            if emptySpot.equalTo(right) {
                rightIsEmpty = true
                print("Right is empty")
            }
            if emptySpot.equalTo(top) {
                topIsEmpty = true
                print("Top is empty")
            }
            if emptySpot.equalTo(bottom) {
                bottomIsEmpty = true
                print("Bottom is empty")
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
                
                var xCent: Int = Int(0.02*screenSize.width) + Int(imageHeightAndWeight)/2
                var yCent: Int = upperOffset + Int(imageHeightAndWeight)/2
                
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
                        xCent += Int(imageHeightAndWeight)
                    }
                    xCent = Int(0.02*screenSize.width) + Int(imageHeightAndWeight)/2
                    yCent += Int(imageHeightAndWeight)
                    
                    if completed == false {
                        break
                    }
                }
                
                //completed = true // For only test purpose
                if completed == true {
                    let endTime = Date()
                    let seconds = endTime.timeIntervalSince(self.startTime)
                    //let formatted = String(format: "%.1f", seconds)
                    //self.displayAlert(title: "Puzzle completed", message: " You have completed in \(formatted) seconds.")
                    let userScoreQuery = PFQuery(className: "UserScore")
                    userScoreQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
                    userScoreQuery.findObjectsInBackground { (objects, error) in
                        if let score = objects?.first {
                            if let totalScore = Int(score["score"] as! String) {
                                var scorePoint = 20
                                if self.harder == true {
                                    scorePoint = 120
                                }
                                let totalScoreAfterTest = totalScore + scorePoint
                                self.showPopup(Score: scorePoint, totalScore: totalScoreAfterTest)
                                
                                score["userId"] = PFUser.current()?.objectId
                                score["score"] = String(totalScoreAfterTest)
                                score.saveInBackground()
                                
                            }
                            else {
                                var scorePoint = 20
                                if self.harder == true {
                                    scorePoint = 120
                                }
                                let totalScoreAfterTest = scorePoint
                                self.showPopup(Score: scorePoint, totalScore: totalScoreAfterTest)
                                
                                score["userId"] = PFUser.current()?.objectId
                                score["score"] = String(totalScoreAfterTest)
                                score.saveInBackground()
                            }
                        }
                        else {
                            var scorePoint = 20
                            if self.harder == true {
                                scorePoint = 120
                            }
                            let totalScoreAfterTest = scorePoint
                            self.showPopup(Score: scorePoint, totalScore: totalScoreAfterTest)
                            
                            let score = PFObject(className: "UserScore")
                            score["userId"] = PFUser.current()?.objectId
                            score["score"] = String(totalScoreAfterTest)
                            score.saveInBackground()
                        }
                    }
                    print("Puzzle Completed")
                }
            }
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
    
    @objc func isRotated() {
        switch UIDevice.current.orientation {
        case .landscapeLeft:
            print("Landscape left")
        case .landscapeRight:
            print("Landscape right")
        case .portrait:
            print("Portrait")
        case .portraitUpsideDown:
            print("Portrait upside down")
        case .unknown:
            print("unknown")
        case .faceUp:
            print("face up")
        case .faceDown:
            print("face down")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "mapPuzzleBackSegue" {
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
    
    func getInversionCount() -> Int {
        
        let screenSize = UIScreen.main.bounds
        
        var imageHeightAndWeight = floor((screenSize.width*0.96)/3)
        let navBarHeight = self.navigationBar.frame.size.height + UIApplication.shared.statusBarFrame.height
        let upperOffset = Int(screenSize.height*0.01) + Int(navBarHeight)
        
        var nofRows = 3
        var nofColumns = 3
        
        if harder == true {
            imageHeightAndWeight = floor((screenSize.width*0.96)/4)
            nofRows = 4
            nofColumns = 4
        }
        
        
        var allImgIndexes = [Int]()
        var imgIndxRowNo : Int = 0
        var imgIndxColNo : Int = 0
        
        for row in 0 ..< nofRows {
            for col in 0 ..< nofColumns {
                if row != 0 || col != 0 {
                    var currCent:CGPoint = allImgViews[Int(row)*3+Int(col)].center
                    if harder {
                        currCent = allImgViews[Int(row)*4+Int(col)].center
                    }
                    imgIndxColNo = (Int(currCent.x) - Int(0.02*screenSize.width) - Int(imageHeightAndWeight)/2) / Int(imageHeightAndWeight)
                    imgIndxRowNo = (Int(currCent.y) - upperOffset - Int(imageHeightAndWeight)/2) / Int(imageHeightAndWeight)
                    
                    allImgIndexes.append(imgIndxRowNo*nofRows + imgIndxColNo + 1)
                    //print("All image center X : \(currCent.x) center y: \(currCent.y)")
                }
            }
        }
        
        let emptySpotColNo = (Int(emptySpot.x) - Int(0.02*screenSize.width) - Int(imageHeightAndWeight)/2) / Int(imageHeightAndWeight)
        let emptySpotRowNo = (Int(emptySpot.y) - upperOffset - Int(imageHeightAndWeight)/2) / Int(imageHeightAndWeight)
        allImgIndexes.insert(0, at: emptySpotRowNo * nofRows + emptySpotColNo)
        
        print(allImgIndexes)
        
        var invCount = 0
        
        for ind_i in 0 ..< (nofRows*nofColumns - 1){
            for ind_j in ind_i + 1 ..< (nofRows*nofColumns) {
                if allImgIndexes[ind_i] != 0 && allImgIndexes[ind_j] != 0 && allImgIndexes[ind_i] > allImgIndexes[ind_j] {
                    invCount = invCount + 1
                }
            }
        }
        
        print("Inversion count: \(invCount)")
        
        var solvable = false
        
        if nofRows == 3 {
            // Grid is odd
            if invCount % 2 == 0 {
                solvable = true
            }
            else {
                solvable = false
                
                if allImgIndexes[0] != 0 && allImgIndexes[1] != 0 {
                    let tempCent:CGPoint = allImgViews[1].center
                    
                    allImgViews[1].center = allImgViews[2].center
                    allImgViews[2].center = tempCent
                    
                }
                else {
                    let tempCent:CGPoint = allImgViews[7].center
                    
                    allImgViews[7].center = allImgViews[8].center
                    allImgViews[8].center = tempCent
                    
                }
                print("Made solvable")
            }
        }
        else {
            // Grid is even
            if let blankPos = allImgIndexes.firstIndex(of: 0) {
                let blankPosIndx: Int = (15 - blankPos) / 4 + 1
                print("Blank position: \(blankPosIndx)")
                
                if blankPosIndx % 2 == 0 {
                    // blank is on an even row
                    if invCount % 2 == 0 {
                        solvable = false
                    }
                    else {
                        solvable = true
                    }
                }
                else {
                    // blank is on odd row
                    if invCount % 2 == 0 {
                        solvable = true
                    }
                    else {
                        solvable = false
                    }

                }
            }
        }
        
        print("Solvable: \(solvable)")

        return 3
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
