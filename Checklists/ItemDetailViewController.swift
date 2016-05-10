//
//  ItemDetailViewController.swift
//  Checklists
//
//  Created by abhinay reddy keesara on 2/20/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import UIKit

// delegates in five steps(1,2,3,4,5)
//step-1 define delegate protocol for object(additem view controller)

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: ChecklistItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: ChecklistItem)
}

class ItemDetailViewController: UITableViewController, UITextFieldDelegate   {
    
    
    // step -2 give object (additemviewcontroller) an optional delegate variable. it should be weak.
    weak var delegate: ItemDetailViewControllerDelegate?
    
    var itemToEdit: ChecklistItem?
    
    var dueDate = NSDate()
    var datePickerVisible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.brownColor()
        
        if let item = itemToEdit {
            
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.enabled = true
            shouldRemindSwitch.on = item.shouldRemind
            dueDate = item.dueDate
            
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
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(self, didFinishEditingItem: item)
        } else {
            
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.on
            item.dueDate = dueDate
            item.scheduleNotification()
            // step-3 make object (additemviewzcontroller)send message to delegate when something happens here when done is pressed by user
            delegate?.itemDetailViewController(self, didFinishAddingItem: item)
        }
        
    }
    
    // for shouldRemind
    
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    // for due date
    
    @IBOutlet weak var dueDatelabel: UILabel!
    
    // date picker
    
    @IBOutlet weak var datePickerCell: UITableViewCell!
    
    @IBOutlet weak var datePicker: UIDatePicker!
    
    // method when a cell is tapped by user.
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 && indexPath.row == 1 {
            
            return indexPath
            
        } else {
            return nil
        }
        
        
        
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
    
    // method for date field
    func updateDueDateLabel() {
        
        
        let formatter = NSDateFormatter()
        formatter.dateStyle = .MediumStyle
        formatter.timeStyle = .ShortStyle
        dueDatelabel.text = formatter.stringFromDate(dueDate)
    }
    
    //method for date picker
    
    
    func showDatePicker() {
        
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
        let indePathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
        
        if let dateCell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
            
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
            
        }
        
        tableView.beginUpdates()
        
        
        tableView.insertRowsAtIndexPaths([indePathDatePicker], withRowAnimation: .Fade)
        
        tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
        tableView.endUpdates()
        
        datePicker.setDate(dueDate, animated: false)
    }
    
    // method for datePicker table view cell
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            
            return datePickerCell
        } else {
            
            return super.tableView(tableView , cellForRowAtIndexPath: indexPath)
            
            
        }
        
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 1 && datePickerVisible {
            
            return 3
        } else {
            
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
        
    }
    
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        
        if indexPath.section == 1 && indexPath.row == 2 {
            
            return 217
        } else {
            
            return super.tableView(tableView, heightForRowAtIndexPath: indexPath)
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
            
        }
        
    }
    
    override func tableView(tableView: UITableView, var indentationLevelForRowAtIndexPath indexPath: NSIndexPath) -> Int {
        
        if indexPath.section == 1 && indexPath.row == 2 {
            
            indexPath = NSIndexPath(forRow: 0, inSection: indexPath.section)
            
        }
        
        return super.tableView(tableView, indentationLevelForRowAtIndexPath: indexPath)
        
        
    }
    
    // method for listening to changes in the date picker event
    
    @IBAction func dateChanged(datePicker: UIDatePicker) {
        
        dueDate = datePicker.date
        
        updateDueDateLabel()
    }
    
    // method to hide date picker 
    
    func hideDatePicker() {
        
        
        if datePickerVisible {
            
            datePickerVisible = false
            
            
            let indexPathDateRow = NSIndexPath(forRow: 1, inSection: 1)
            let indePathDatePicker = NSIndexPath(forRow: 2, inSection: 1)
            
            if let cell = tableView.cellForRowAtIndexPath(indexPathDateRow) {
                
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRowsAtIndexPaths([indexPathDateRow], withRowAnimation: .None)
            tableView.deleteRowsAtIndexPaths([indePathDatePicker], withRowAnimation: .Fade)
            tableView.endUpdates()
        }
    }
    
    // method when text field editing began. need to hide date picker
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        hideDatePicker()
    }
    
    // method for notification permission when remind me switch is toggled on
    
    @IBAction func shouldRemindToggled( switchControl: UISwitch) {
        
        textField.resignFirstResponder()
        
        if switchControl.on {
            
            let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert,.Sound], categories: nil )
            
            UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        }
        
        
        
    }
    
    
}