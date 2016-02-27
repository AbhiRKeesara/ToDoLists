//
//  Checklist.swift
//  ToDoLists
//
//  Created by abhinay reddy keesara on 2/22/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import UIKit

// adding NSCoding to the class makes the Checklist object compliant with NSCoding.
class Checklist: NSObject, NSCoding {
    
var name = ""

var items = [ChecklistItem]() 

    // NSCoding protocol requires following two methods
    required init?(coder aDecoder: NSCoder) {
        
        name = aDecoder.decodeObjectForKey("Name") as! String
        items = aDecoder.decodeObjectForKey("Items") as! [ChecklistItem]
    
        super.init()
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: "Name")
        aCoder.encodeObject(items, forKey: "Items")
    }


    init(name: String) {
        
        self.name = name
        super.init()
    }
    
    
    
    
}
