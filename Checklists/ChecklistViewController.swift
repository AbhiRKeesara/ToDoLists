//
//  ViewController.swift
//  Checklists
//
//  Created by abhinay reddy keesara on 2/17/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import UIKit

//ChecklistViewController now promises to do the things from the ItemDetailViewControllerDelegate protocol.

/*step-4 make object (checklistviewcontroller) conform to the delegate protocol.
put the name of the protocol in its class line and implement the methods from the protocol.*/

class ChecklistViewController: UITableViewController, ItemDetailViewControllerDelegate {
    
// checklistItem objects serves to combine text and the checked flag into one object
    
//    var row0item: ChecklistItem
//    var row1item: ChecklistItem
//    var row2item: ChecklistItem
//    var row3item: ChecklistItem
//    var row4item: ChecklistItem
    
    var items: [ChecklistItem] = [ChecklistItem] ()
    var checklist: Checklist!
    
    /* since the rowXitem dont have a value, it is a empty container for a checklistItem object.
    -->In Swift programs, all variables should always have a value – the containers can never be empty.
    -->If you can’t give the variable a value right away when you declare it, then you have
        to give it a value inside a so-called initializer method.
    --> So intiallizing it as following method.
    */
    
    //required init?(coder aDecoder: NSCoder) {
        
        // first need to make sure instance variable items has a proper value(a new array)
        
        
       // items = [ChecklistItem]()
        
        
//        let row0item = ChecklistItem()
//        row0item.text = "Call Mom"
//        row0item.checked = false
//        items.append(row0item)
//        
//       let row1item = ChecklistItem()
//        row1item.text = "Check Mails"
//        row1item.checked = false
//        items.append(row1item)
//        
//        let row2item = ChecklistItem()
//        row2item.text = "Pay Credit card bill"
//        row2item.checked = false
//        items.append(row2item)
//        
//        let row3item = ChecklistItem()
//        row3item.text = "Check Groceries"
//        row3item.checked = false
//        items.append(row3item)
//        
//       let row4item = ChecklistItem()
//        row4item.text = "Turn off switches"
//        row4item.checked = false
//        items.append(row4item)
        // call super.init to ensure the rest of the view controller is unfrozen from the  storyboard
       // super.init(coder: aDecoder)
        // loading the plist
        
//        loadChecklistItems()
//        
//        print("Documents folder is \(documentsDirectory())")
//        print("Data file path is \(dataFilePath())")
//    
        
   // }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = checklist.name
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // declaring for number of rows
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }

        // declaring for creating a cell and to pass the data
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // to resuse the cell
        let cell = tableView.dequeueReusableCellWithIdentifier("ChecklistItem", forIndexPath: indexPath)
        
        let item = checklist.items[indexPath.row]
            
       
        configureTextForCell(cell, withChecklistItem: item)
        configureCheckmarkForCell(cell, withChecklistItem: item)
        return cell
    }
    
    // when a row is selected
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let cell = tableView.cellForRowAtIndexPath(indexPath) {
            
         let item = checklist.items[indexPath.row]
//            item.checked = !item.checked
            item.toggleChecked()
            
            configureCheckmarkForCell(cell, withChecklistItem: item)
        }
        
        // to deselect the selected row
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        //saveChecklistItems()
    }
    
    // method to delete a row
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        // remove the item from the data model
        checklist.items.removeAtIndex(indexPath.row)
        
        // delete the corresponding row from the table view.
        
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
     //   saveChecklistItems()
        
    }
    
    func configureCheckmarkForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        let label = cell.viewWithTag(101) as! UILabel
        if item.checked {
            label.text = "√"
        } else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell: UITableViewCell, withChecklistItem item: ChecklistItem) {
        
        // assigning the tag to the label and using it
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.text
    }

    
/*------------------------------------------------------------------------*/
// method for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "AddItem" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            
            controller.delegate = self
        } else if segue.identifier == "EditItem" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPathForCell(sender as! UITableViewCell) {
                
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        }
    }
    

/*----------------------------------------------------------------------*/
//implementations of the protocol’s methods to ChecklistViewController.
    
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil )
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem) {
        
        // index of the new row in array
        let newRowIndex = checklist.items.count
    
        checklist.items.append(item)
        
        let indexPath = NSIndexPath (forRow: newRowIndex, inSection: 0)
        let indexPaths = [ indexPath]
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
    
        dismissViewControllerAnimated(true, completion: nil)
       // saveChecklistItems()
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem) {
        
        if let index = items.indexOf(item) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                configureTextForCell(cell, withChecklistItem: item)
        }
        }
        dismissViewControllerAnimated(true, completion: nil)
       // saveChecklistItems()
   }
   
/**********************************************************************************************/
// implementation for documents directory
    
  /*  func documentsDirectory() -> String {
        
        let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        
        return paths[0]
        
    }
    
    func dataFilePath() ->String {
        return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plists")
    }
*/
/******************************************************************************/
// saving data to plist
    
  /*  func saveChecklistItems() {
        
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
        archiver.encodeObject(items, forKey: "ChecklistItems")
        archiver.finishEncoding()
        data.writeToFile(dataFilePath(), atomically: true)

    }*/
    
    // method for loading the plist
    
   /* func loadChecklistItems() {
        
        let path = dataFilePath()
        
        if NSFileManager.defaultManager().fileExistsAtPath(path) {
        
        if let data = NSData(contentsOfFile: path) {
            
            let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
            items = unarchiver.decodeObjectForKey("ChecklistItems") as! [ChecklistItem]
            
            unarchiver.finishDecoding()
        }
        
    }
    
    } */
}
