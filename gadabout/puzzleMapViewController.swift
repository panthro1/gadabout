//
//  puzzleMapViewController.swift
//  gadabout
//
//  Created by Ahmet on 17.09.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit

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

    @IBOutlet weak var testLabel: UILabel!
    
    @IBOutlet weak var hintButton: UIButton!
    
    @IBAction func backTapped(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
        performSegue(withIdentifier: "mapPuzzleBackSegue", sender: self)
    }
    
    @IBAction func hintTapped(_ sender: Any) {
        
        if isHintDisplayed == false {
            var imageView : UIImageView
            imageView = UIImageView(frame: CGRect(x: 10, y: 100, width: 96*4, height: 96*4))
            imageView.tag = 100
            imageView.image = UIImage(named:"collesium.jpg")
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
        
        let myPicture = UIImage(named: "collesium.jpg")
        
        if let mainImage = myPicture {

            let images = slice(image: mainImage, into: 3)
            
            var xCent: Int = 10+48/3*4
            var yCent: Int = 100+48/3*4
            
            let nofRows = 3
            let nofColumns = 3
            
            for row in 0 ..< nofRows {
                for col in 0 ..< nofColumns {
                    var myImgView = UIImageView(frame: CGRect(x: 300, y: 234, width: 96/3*4, height: 96/3*4))
                    let currCent:CGPoint = CGPoint(x: xCent, y: yCent)
                    allCenters.append(currCent)
                    myImgView.center = currCent
                    myImgView.image = images[row*3+col]
                    myImgView.isUserInteractionEnabled = true
                    allImgViews.append(myImgView)
                    self.view.addSubview(myImgView)
                    xCent += 96/3*4
                    
                }
                xCent = 10+48/3*4
                yCent += 96/3*4
            }
        }
        self.randomizeBlocks()
        allImgViews[0].removeFromSuperview()

        leftIsEmpty = false
        rightIsEmpty = false
        topIsEmpty = false
        bottomIsEmpty = false
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
            
            left = CGPoint(x: tapCenter.x - 96/3*4, y: tapCenter.y)
            right = CGPoint(x: tapCenter.x + 96/3*4, y: tapCenter.y)
            top = CGPoint(x: tapCenter.x, y: tapCenter.y + 96/3*4)
            bottom = CGPoint(x: tapCenter.x, y: tapCenter.y - 96/3*4)
            
            if emptySpot.equalTo(left) {
                print("Left is empty")
                leftIsEmpty = true
            }
            if emptySpot.equalTo(right) {
                print("Right is empty")
                rightIsEmpty = true
            }
            if emptySpot.equalTo(top) {
                print("Top is empty")
                topIsEmpty = true
            }
            if emptySpot.equalTo(bottom) {
                print("Bottom is empty")
                bottomIsEmpty = true
            }
            print("X: \(emptySpot.x) Y: \(emptySpot.y)")
            
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
                
                let nofRows = 3
                let nofColumns = 3
                var completed: Bool = true
                
                for row in 0 ..< nofRows {
                    for col in 0 ..< nofColumns {
                        let currCent:CGPoint = allImgViews[row*3+col].center
                        let mustBe = CGPoint(x: xCent, y: yCent)
                        if currCent.equalTo(mustBe) {
                            completed = true
                        }
                        else {
                            completed = false
                            break
                        }
                        xCent += 96/3*4
                    }
                    xCent = 10+48/3*4
                    yCent += 96/3*4
                    
                    if completed == false {
                        break
                    }
                }
                if completed == true {
                    print("Puzzle Completed")
                }
            }
        }
        
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
