//
//  ToDoListViewController.swift
//  gadabout
//
//  Created by Ahmet on 15.10.2018.
//  Copyright © 2018 Ahmet. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var itemNames = [String]()
    var itemDescriptions = [String]()

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
        let cell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "Cell")
        
        var toDoName = ""
        var toDoDesc = ""
        
        if itemNames.count >= indexPath.row {
            toDoName = itemNames[indexPath.row]
        }
        
        if itemDescriptions.count >= indexPath.row {
            toDoDesc = ": " + itemDescriptions[indexPath.row]
        }
        
        cell.textLabel?.text = toDoName + toDoDesc
        
        return cell
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
