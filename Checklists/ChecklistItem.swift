//
//  ChecklistItem.swift
//  Checklists
//
//  Created by abhinay reddy keesara on 2/18/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import Foundation

class ChecklistItem: NSObject, NSCoding {
    
    var text = ""
    var checked = false
    
    override init() {
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
    }

    // for loading data from checklist.plist file
    required init?(coder aDecoder: NSCoder) {
        
        text = aDecoder.decodeObjectForKey("Text") as! String
        checked = aDecoder.decodeBoolForKey("Checked")
        
        super.init()
    }
}
