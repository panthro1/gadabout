//
//  ToDoListViewController.swift
//  gadabout
//
//  Created by Ahmet on 15.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import CoreData
import Parse

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemIDs = [String]()
    var placeOrFood = [String]()
    var completedDB = [String]()
    var imageFile = [PFFile]()
    var itemNames = [String]()
    var itemDescriptions = [String]()

    @IBOutlet weak var table: UITableView!
    
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toDoBackSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        itemNames = glbToDoItemNames
        itemDescriptions = glbToDoItemDescriptions
        
        table.reloadData()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemNames.count
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        let cell = UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "Cell")
        
        var toDoName = ""
        var toDoDesc = ""
        
        /*if itemNames.count >= indexPath.row {
            toDoName = itemNames[indexPath.row]
        }
        
        if itemDescriptions.count >= indexPath.row {
            toDoDesc = itemDescriptions[indexPath.row]
        }*/
        
       // New code
        if glbToDoItemNames.count >= indexPath.row {
         toDoName = itemNames[indexPath.row]
         }
         
         if glbToDoItemDescriptions.count >= indexPath.row {
         toDoDesc = itemDescriptions[indexPath.row]
         }
        
        cell.textLabel?.text = toDoName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        
        
        if glbToDoItemCompleted[indexPath.row] == true {
            let toDoNameAttributeString: NSMutableAttributedString =  NSMutableAttributedString(string: toDoName)
            toDoNameAttributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, toDoNameAttributeString.length))
            cell.textLabel?.attributedText = toDoNameAttributeString
        }
        
        cell.detailTextLabel?.text = toDoDesc
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18, weight: UIFont.Weight.thin)
        cell.detailTextLabel?.sizeToFit()
        cell.detailTextLabel?.numberOfLines = 0

        

        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            itemNames.remove(at: indexPath.row)
            itemDescriptions.remove(at: indexPath.row)
            
            
            tableView.deleteRows(at: [indexPath], with: .bottom)
            
            let toDoItemQuery = PFQuery(className: "ToDoList")
            toDoItemQuery.whereKey("item", equalTo: glbToDoItemIDs[indexPath.row])
            toDoItemQuery.findObjectsInBackground(block: { (objects, error) in
                if let error = error {
                    print(error.localizedDescription)
                }
                else {
                    if let item = objects?.first {
                        item.deleteInBackground()
                    }
                }
            })
            
            glbToDoItemNames.remove(at: indexPath.row)
            glbToDoItemDescriptions.remove(at: indexPath.row)
            glbToDoItemImageFile.remove(at: indexPath.row)
            glbToDoItemIDs.remove(at: indexPath.row)
            glbToDoItemCompleted.remove(at: indexPath.row)
            glbToDoItemPlaceOrFood.remove(at: indexPath.row)
        }
    }

    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedStringKey.font: font])
        let boldFontAttribute: [NSAttributedStringKey: Any] = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "toDoBackSegue" {
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
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let closeAction = UIContextualAction(style: .normal, title: nil, handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if glbToDoItemCompleted[indexPath.row] == true {
                glbToDoItemCompleted[indexPath.row] = false
                
                let toDoItemQuery = PFQuery(className: "ToDoList")
                toDoItemQuery.whereKey("item", equalTo: glbToDoItemIDs[indexPath.row])
                toDoItemQuery.findObjectsInBackground(block: { (objects, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        if let item = objects?.first {
                            item["Completed"] = "NO"
                            item.saveInBackground()
                        }
                    }
                })
            }
            else {
                glbToDoItemCompleted[indexPath.row] = true
                // New code
                let toDoItemQuery = PFQuery(className: "ToDoList")
                toDoItemQuery.whereKey("item", equalTo: glbToDoItemIDs[indexPath.row])
                toDoItemQuery.findObjectsInBackground(block: { (objects, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        if let item = objects?.first {
                            item["Completed"] = "YES"
                            item.saveInBackground()
                        }
                    }
                })
            }
            tableView.reloadData()
            




        
            success(true)
        })
        if glbToDoItemCompleted[indexPath.row] == true {
            closeAction.image = UIImage(named: "undo-arrow.png")
        }
        else {
            closeAction.image = UIImage(named: "checked.png")
        }
        closeAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [closeAction])
    }
    
    func showPopup(indx: Int) {
        
        let popOverVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "toDoImagePopupID") as! ToDoImageDisplayViewController
        
        glbToDoItemImageFile[indx].getDataInBackground { (data, error) in
            if let imageData = data {
                if let imageToDisplay = UIImage(data: imageData) {

                    popOverVC.toDoImage.image = imageToDisplay

                }
            }
        }
        popOverVC.header = glbToDoItemNames[indx]
        popOverVC.desc = glbToDoItemDescriptions[indx]
        //let header = glbToDoItemNames[indx]
        
        /*if glbToDoItemNames[indx].count > 0 {
            popOverVC.toDoHeader.text = glbToDoItemNames[indx]
        }*/
        
        
        
            
        self.addChildViewController(popOverVC)
        popOverVC.view.frame = self.view.bounds
        /*tableView.isScrollEnabled = false
        complete.isEnabled = false
        back.isEnabled = false*/
        self.view.addSubview(popOverVC.view)
        popOverVC.didMove(toParentViewController: self)
        
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showPopup(indx: indexPath.row)
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
