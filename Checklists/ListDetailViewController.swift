//
//  ListDetailViewController.swift
//  ToDoLists
//
//  Created by abhinay reddy keesara on 2/22/16.
//  Copyright © 2016 abhinay reddy keesara. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate: class {
    
    func listDetailViewControllerDidCancel(controller: ListDetailViewController)
    
    func listDetailViewController(controller: ListDetailViewController ,didFinishAddingChecklist checklist:Checklist)
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist:Checklist)
    
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate, IconPickerViewControllerDelegate {
    
    var iconName = "Folder"
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    weak var delegate: ListDetailViewControllerDelegate?
    
    var checkListToEdit: Checklist?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = UIColor.brownColor()
        
        if let checklist = checkListToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.enabled = true
            iconName = checklist.iconName
        }
     
        iconImageView.image = UIImage(named: iconName)
    }
    
    // method for the keyboard to appear first when the scene is displayed
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    // image view
    @IBOutlet weak var iconImageView: UIImageView!
    
    
    // for cancel button
    @IBAction   func cancel() {
        
        delegate?.listDetailViewControllerDidCancel(self)
    }
    
    
    // for done button
    @IBAction  func done() {
        
        if let checklist = checkListToEdit {
            
            checklist.name = textField.text!
            
            checklist.iconName = iconName
            
            delegate?.listDetailViewController(self, didFinishEditingChecklist:checklist)
            
        } else {
            
            let checklist = Checklist(name: textField.text!)
            checklist.iconName = iconName
            delegate?.listDetailViewController(self, didFinishAddingChecklist: checklist)
        }
    }
    
    
    // text field delegate method that enables or disables the done button depending on whether it is empty or not.
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange,
        replacementString string: String) -> Bool {
            let oldText: NSString = textField.text!
            let newText: NSString = oldText.stringByReplacingCharactersInRange( range, withString: string)
            doneBarButton.enabled = (newText.length > 0)
            return true
    }
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if indexPath.section == 1 {
            
            return indexPath
        } else {
            
             return nil
        }
    }
    
    
    // segue method to move from ListDetailViewController to IconPickerViewController
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if segue.identifier == "PickIcon" {
            
            let controller = segue.destinationViewController as! IconPickerViewController
            controller.delegate = self
        }
    }
    
// implementing delegate method of IconPickerViewController
    
    func iconPicker(picker: IconPickerViewController, didPickIcon iconName: String) {
        
        
        self.iconName = iconName
        
        iconImageView.image = UIImage(named: iconName)
        
        navigationController?.popViewControllerAnimated(true)
    }

}





