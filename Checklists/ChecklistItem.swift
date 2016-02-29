//
//  ChecklistItem.swift
//  Checklists
//
//  Created by abhinay reddy keesara on 2/18/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import Foundation
import UIKit

class ChecklistItem: NSObject, NSCoding {
    
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
    var text = ""
    var checked = false
    
    override init() {
        
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    // method for toggle on or off
    
    func toggleChecked() {
        
        checked = !checked
    }
    
    // method for encoding checklist objects to checklist.plist file
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(text, forKey: "Text")
        aCoder.encodeBool(checked, forKey: "Checked")
        aCoder.encodeObject(dueDate, forKey: "DueDate")
        aCoder.encodeBool(shouldRemind, forKey: "ShouldRemind")
        aCoder.encodeInteger(itemID, forKey: "ItemID")
    
    }

    // for loading data from checklist.plist file
    required init?(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        dueDate = aDecoder.decodeObjectForKey("DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBoolForKey("ShouldRemind")
        itemID = aDecoder.decodeIntegerForKey("ItemID")
        
        super.init()
    }
    
    // method for scheduling notification
    
    func scheduleNotification() {
        
        let existingNotification = notificationForThisItem()
        
        if let notification = existingNotification {
            
//            print("Found an existing notification \(notification)")
        
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
        
        
        
        if shouldRemind && dueDate.compare(NSDate()) != .OrderedAscending {
            
            let localNotification = UILocalNotification()
            
            localNotification.fireDate = dueDate
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            
           UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
//            
//            print("Scheduled notification \(localNotification) for  itemID \(itemID)")
        }
    }
    
    // method to ask uiapplication for all list of scheduled notifications.
    
    func notificationForThisItem() -> UILocalNotification? {
        
        let allNotifications = UIApplication.sharedApplication().scheduledLocalNotifications!
        
        for notification in allNotifications {
            
            if let number = notification.userInfo?["ItemID"] as? Int
            
                where number == itemID {
                    
                    return notification
            }
        }
    
    return nil
    }
    
    // method when checklist or checklist items are deleted 
    
    deinit {
        
        if let notification = notificationForThisItem() {
            
//            print("Removing existing notification\(notification)")
            
            UIApplication.sharedApplication().cancelLocalNotification(notification)
        }
    }
}
