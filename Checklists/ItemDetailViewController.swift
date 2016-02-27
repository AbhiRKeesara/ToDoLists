//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by abhinay reddy keesara on 2/20/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import UIKit

// delegates in five steps(1,2,3,4,5)
//step-1 definedelegate protocol for object(additem view controller)

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
    }

class ItemDetailViewController: UITableViewController, UITextFieldDelegate   {
    
    // step -2 give object (additemviewcontroller) an optional delegate variable. it should be weak.
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            
        }
    
    }
    
   // for textfield.
    @IBOutlet weak var textField: UITextField!
    
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    // method for cancel button.
    @IBAction func cancel() {
//        dismissViewControllerAnimated(true, completion:nil)
        
        // step-3 make object (additemviewzcontroller)send message to delegate when something happens here when cancel is pressed by user.
        delegate?.itemDetailViewControllerDidCancel(self)
    }

    // method for done button.
    @IBAction func done() {
        
//        print("contents of the text field: \(textField.text!)")
//        
//        dismissViewControllerAnimated(true, completion: nil)
        if let item = itemToEdit {
            
            item.text = textField.text!
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            
        let item = ChecklistItem()
        item.text = textField.text!
        item.checked = false
        
        // step-3 make object (additemviewzcontroller)send message to delegate when something happens here when done is pressed by user
        delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    // method when a cell is tapped by user.
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        return nil 
    }
    
    // method for the keyboard to appear automatically when additem screen opens.
    
    //view controller receives the viewWillAppear() message just before it becomes visible.
   
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    
    // method to enable or disable bar button item based on text field.
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
   
        //which part of the text should be replaced (the range) and the text it should be replaced with (the replacement string).
        
        let oldText: NSString = textField.text!
        let newText: NSString = oldText.stringByReplacingCharactersInRange(range, withString: string)
        
//        if newText.length > 0 {
//            doneBarButton.enabled = true
//        } else {
//            doneBarButton.enabled = false
//        }
        
        doneBarButton.enabled = (newText.length > 0)
    
        return true
    }
    
}