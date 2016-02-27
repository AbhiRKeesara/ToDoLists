//
//  AllListsViewController.swift
//  ToDoLists
//
//  Created by abhinay reddy keesara on 2/21/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate {

    var lists: [Checklist]
    
    required init?(coder aDecoder: NSCoder) {
        
        lists = [Checklist]()
        
        super.init(coder: aDecoder)
        
       loadChecklists()
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

 


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return lists.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        // Configure the cell...
        
        let cell = cellForTableView(tableView)
        
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .DetailDisclosureButton
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let checklist = lists[indexPath.row]
        performSegueWithIdentifier("ShowChecklist", sender: checklist)
    }
    
    func cellForTableView(tableView: UITableView) ->UITableViewCell {
        
        let cellIdentifier = "Cell"
        
        if let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .Default, reuseIdentifier: cellIdentifier)
        }
        
    }

    // method for segue
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "ShowChecklist" {
            
            let controller = segue.destinationViewController as! ChecklistViewController
            controller.checklist = sender as! Checklist
        } else if segue.identifier == "AddChecklist" {
            
            let navigationController = segue.destinationViewController as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController
            controller.delegate = self
            controller.checkListToEdit = nil
            
        }
    }
    
// implementation for listviewcontrollerdelegate protocol methods
    
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: Checklist) {
        let newRowIndex = lists.count
        
        lists.append(checklist)
        
        let indexPath = NSIndexPath(forRow: newRowIndex, inSection: 0)
        let indexPaths = [indexPath]
        
        tableView.insertRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
        dismissViewControllerAnimated(true, completion: nil)
    }

    
    func listDetailViewController(controller: ListDetailViewController , didFinishEditingChecklist checklist: Checklist) {
        
        if let index = lists.indexOf(checklist) {
            let indexPath = NSIndexPath(forRow: index, inSection: 0)
            if let cell = tableView.cellForRowAtIndexPath(indexPath) {
                cell.textLabel!.text = checklist.name
            }
            
        }
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    
    //method to delete checklists
    
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        
        lists.removeAtIndex(indexPath.row)
        
        let indexPaths = [indexPath]
        
        tableView.deleteRowsAtIndexPaths(indexPaths, withRowAnimation: .Automatic)
        
    }
    
    override func tableView(tableView: UITableView, accessoryButtonTappedForRowWithIndexPath indexPath: NSIndexPath) {
        
        
        let navigationController = storyboard!.instantiateViewControllerWithIdentifier("ListDetailNavigationController") as! UINavigationController
        
        let controller = navigationController.topViewController as! ListDetailViewController
        
        controller.delegate = self
        
        let checklist = lists[indexPath.row]
        controller.checkListToEdit = checklist
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    
    
    
    
/**********************************************************************************************/
    // implementation for documents directory
    
     func documentsDirectory() -> String {
    
    let paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
    
    return paths[0]
    
    }
    
    func dataFilePath() ->String {
    return (documentsDirectory() as NSString).stringByAppendingPathComponent("Checklists.plists")
    }

    /******************************************************************************/
    // saving data to plist
    
    func saveChecklists() {
    
    let data = NSMutableData()
    let archiver = NSKeyedArchiver(forWritingWithMutableData: data)
    archiver.encodeObject(lists, forKey: "Checklists")
    archiver.finishEncoding()
    data.writeToFile(dataFilePath(), atomically: true)
    
    }
    
    // method for loading the plist
    
    func loadChecklists() {
    
    let path = dataFilePath()
    
    if NSFileManager.defaultManager().fileExistsAtPath(path) {
    
    if let data = NSData(contentsOfFile: path) {
    
    let unarchiver = NSKeyedUnarchiver(forReadingWithData: data)
    lists = unarchiver.decodeObjectForKey("Checklists") as! [Checklist]
    
    unarchiver.finishDecoding()
    }
    
    }
    
    }
    
    
}
