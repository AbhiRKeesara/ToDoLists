//
//  DataModel.swift
//  ToDoLists
//
//  Created by abhinay reddy keesara on 2/27/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
// DataModel will be taking over the responsibilities for loading and saving the to-do list from AllListsViewController.

import Foundation

class DataModel {
    
    // define the new DataModel object and give it a lists property.
    
    var lists = [Checklist]()
    
    //  to load checklist.plist
    
    init() {
        
        loadChecklists()
        registerDefaults()
        handleFirstTime()
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
                
                sortChecklists()
            }
            
        }
        
    }
    
    // method for setting default value (-1) for NSUserdefaults default value. if not app crashes as NSUserDefaults set the value to 0.
    
    
    func registerDefaults() {
        
        let dictionary = [ "ChecklistIndex": -1, "FirstTime": true, "ChecklitItemsID": 0]
        
        NSUserDefaults.standardUserDefaults().registerDefaults(dictionary)
    }
    
    
    var indexOfSelectedChecklist: Int {
        
        get {
            
        return NSUserDefaults.standardUserDefaults().integerForKey("ChecklistIndex")
            
        }
        
        set {
            
            NSUserDefaults.standardUserDefaults().setInteger(newValue, forKey: "ChecklistIndex")
            NSUserDefaults.standardUserDefaults().synchronize()
            
        }
    }
    
    // when the app launches for the first time
    func handleFirstTime() {
        
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let firstTime = userDefaults.boolForKey("FirstTime")
        
        if firstTime {
            
            let checklist = Checklist(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.setBool(false, forKey: "FirstTime")
            userDefaults.synchronize()
        }
    }
    
    // method used for sorting the items
    
    
    func sortChecklists() {
        
        lists.sortInPlace({ checklist1, checklist2 in return checklist1.name.localizedStandardCompare(checklist2.name) == .OrderedAscending })
        
        
    }
    
    class func nextChecklistItemID() -> Int {
        
        let userDefaults = NSUserDefaults.standardUserDefaults()
        let itemID = userDefaults.integerForKey("ChecklistItemID")
        userDefaults.setInteger(itemID + 1, forKey: "ChecklistItemID")
        
        userDefaults.synchronize()
        return itemID
    }
}