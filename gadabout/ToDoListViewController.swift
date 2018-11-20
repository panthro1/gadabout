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
    
    var itemNames = [String]()
    var itemDescriptions = [String]()
    var completed = [Bool]()
    var itemIDs = [String]()
    var placeOrFood = [String]()
    var completedDB = [String]()
    var imageFile = [PFFile]()
    

    @IBOutlet weak var table: UITableView!
    
    
    @IBAction func backTapped(_ sender: Any) {
        
        performSegue(withIdentifier: "toDoBackSegue", sender: self)
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let itemsObject = UserDefaults.standard.object(forKey: "toDoItem") as? [String]
        print("itemsObject: \(itemsObject)")
        let itemDescription = UserDefaults.standard.object(forKey: "toDoItemDescription") as? [String]
        print("itemsDescription: \(itemDescription)")
        
        if let tempItems = itemsObject as? [String] {
            itemNames = tempItems
        }
        
        if let tempDescriptions = itemDescription  as? [String] {
            itemDescriptions = tempDescriptions
        }
        print(itemNames)
        
        if let items = itemsObject{
            for _ in 0 ..< items.count {
                completed.append(false)
            }
        }
        
        // New code
        
        /*let toDoListItemQuery = PFQuery(className: "ToDoList")
        toDoListItemQuery.whereKey("userId", equalTo: PFUser.current()?.objectId)
        toDoListItemQuery.findObjectsInBackground { (objects, error) in
            if let error = error {
                print(error.localizedDescription)
            }
            else {
                if let items = objects {
                    for item in items {
                        self.itemIDs.append(item["item"] as! String)
                        self.placeOrFood.append(item["PlaceOrFood"] as! String)
                        self.completedDB.append(item["Completed"] as! String)
                    }
                }
            }
            var indx = 0
            var placeItems = [String]()
            var foodItems = [String]()
            for itemId in self.itemIDs {
                if self.placeOrFood[indx] == "Place" {
                    placeItems.append(itemId)
                }
                else {
                    foodItems.append(itemId)
                }
                indx = indx + 1
            }
            
            if placeItems.count > 0 {
                print("place items count : \(placeItems.count)")
                let placeQuery = PFQuery(className: "Places")
                placeQuery.whereKey("objectId", containedIn: placeItems)
                placeQuery.findObjectsInBackground(block: { (objects, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        if let places = objects {
                            for place in places {
                                if let correctAnsInt = Int(place["correctAlternative"] as! String) {
                                    if correctAnsInt == 1 {
                                        self.itemNames.append(place["alternative1"] as! String)
                                    }
                                    else if correctAnsInt == 2 {
                                        self.itemNames.append(place["alternative2"] as! String)
                                    }
                                    else if correctAnsInt == 3 {
                                        self.itemNames.append(place["alternative3"] as! String)
                                    }
                                    else if correctAnsInt == 4 {
                                        self.itemNames.append(place["alternative4"] as! String)
                                    }
                                }
                                self.itemDescriptions.append(place["engDescription"] as! String)
                                self.imageFile.append(place["imageFile"] as! PFFile)
                                if let plcObjId = place.objectId {
                                    let arrIndx = self.itemIDs.firstIndex(of: plcObjId)
                                    if let indx = arrIndx {
                                        if self.itemIDs[indx] == "YES" {
                                            self.completed.append(true)
                                        }
                                        else {
                                            self.completed.append(false)
                                        }
                                    }
                                    else {
                                        self.completed.append(false)
                                    }
                                }
                                
                            }
                        }
                    }
                    if foodItems.count > 0 {
                        let foodQuery = PFQuery(className: "Places")
                        foodQuery.whereKey("objectId", containedIn: foodItems)
                        foodQuery.findObjectsInBackground(block: { (objects, error) in
                            if let error = error {
                                print(error.localizedDescription)
                            }
                            else {
                                if let foods = objects {
                                    for food in foods {
                                        if let correctAnsInt = Int(food["correctAlternative"] as! String) {
                                            if correctAnsInt == 1 {
                                                self.itemNames.append(food["alternative1"] as! String)
                                            }
                                            else if correctAnsInt == 2 {
                                                self.itemNames.append(food["alternative2"] as! String)
                                            }
                                            else if correctAnsInt == 3 {
                                                self.itemNames.append(food["alternative3"] as! String)
                                            }
                                            else if correctAnsInt == 4 {
                                                self.itemNames.append(food["alternative4"] as! String)
                                            }
                                        }
                                        self.itemDescriptions.append(food["engDescription"] as! String)
                                        self.imageFile.append(food["imageFile"] as! PFFile)

                                        if let plcObjId = food.objectId {
                                            let arrIndx = self.itemIDs.firstIndex(of: plcObjId)
                                            if let indx = arrIndx {
                                                if self.itemIDs[indx] == "YES" {
                                                    self.completed.append(true)
                                                }
                                                else {
                                                    self.completed.append(false)
                                                }
                                            }
                                            else {
                                                self.completed.append(false)
                                            }
                                        }
                                    }
                                }
                            }
                            self.table.reloadData()
                        })

                    }
                    else {
                        self.table.reloadData()
                    }
                })
            }
            
            else if foodItems.count > 0 {
                let foodQuery = PFQuery(className: "Places")
                foodQuery.whereKey("objectId", containedIn: foodItems)
                foodQuery.findObjectsInBackground(block: { (objects, error) in
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    else {
                        if let foods = objects {
                            for food in foods {
                                if let correctAnsInt = Int(food["correctAlternative"] as! String) {
                                    if correctAnsInt == 1 {
                                        self.itemNames.append(food["alternative1"] as! String)
                                    }
                                    else if correctAnsInt == 2 {
                                        self.itemNames.append(food["alternative2"] as! String)
                                    }
                                    else if correctAnsInt == 3 {
                                        self.itemNames.append(food["alternative3"] as! String)
                                    }
                                    else if correctAnsInt == 4 {
                                        self.itemNames.append(food["alternative4"] as! String)
                                    }
                                }
                                self.itemDescriptions.append(food["engDescription"] as! String)
                                self.imageFile.append(food["imageFile"] as! PFFile)

                                if let plcObjId = food.objectId {
                                    let arrIndx = self.itemIDs.firstIndex(of: plcObjId)
                                    if let indx = arrIndx {
                                        if self.itemIDs[indx] == "YES" {
                                            self.completed.append(true)
                                        }
                                        else {
                                            self.completed.append(false)
                                        }
                                    }
                                    else {
                                        self.completed.append(false)
                                    }
                                }
                            }
                        }
                    }
                    self.table.reloadData()
                })
            }
        }*/
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
        
        if itemNames.count >= indexPath.row {
            toDoName = itemNames[indexPath.row]
        }
        
        if itemDescriptions.count >= indexPath.row {
            toDoDesc = itemDescriptions[indexPath.row]
        }
        
        //let str = attributedText(withString: toDoName, boldString: toDoDesc, font: UIFont(name: "Helvetica Neue", size: 15)!)
        
        /*cell.textLabel?.text = toDoName + toDoDesc
        //cell.textLabel?.text = str.string
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0*/
        
        
        cell.textLabel?.text = toDoName
        cell.textLabel?.font = UIFont.systemFont(ofSize: 20, weight: UIFont.Weight.bold)
        cell.textLabel?.sizeToFit()
        cell.textLabel?.numberOfLines = 0
        
        
        if completed[indexPath.row] == true {
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
            UserDefaults.standard.set(itemNames, forKey: "toDoItem")
            UserDefaults.standard.set(itemDescriptions, forKey: "toDoItemDescription")
            tableView.deleteRows(at: [indexPath], with: .bottom)
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
        let closeAction = UIContextualAction(style: .normal, title:  "Close", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            if self.completed[indexPath.row] == true {
                self.completed[indexPath.row] = false
            }
            else {
                self.completed[indexPath.row] = true
            }
            tableView.reloadData()
            
        
            success(true)
        })
        if completed[indexPath.row] == true {
            closeAction.image = UIImage(named: "undo-arrow.png")
        }
        else {
            closeAction.image = UIImage(named: "checked.png")
        }
        closeAction.backgroundColor = .purple
        return UISwipeActionsConfiguration(actions: [closeAction])
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
