//
//  File.swift
//  CheckLists
//
//  Created by human on 2018. 11. 28..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import UIKit

protocol ListDetailViewControllerDelegate : class {
    func listDetailViewControllerDidCancel(controller:ListDetailViewController)
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist:CheckList)
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist:CheckList)
}

class ListDetailViewController: UITableViewController, UITextFieldDelegate {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
 
    weak var delegate:ListDetailViewControllerDelegate?
    
    var checklistToEdit: CheckList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        if let checklist = checklistToEdit {
            title = "Edit Checklist"
            textField.text = checklist.name
            doneBarButton.isEnabled = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func cancel(){

        delegate?.listDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done(){
        
        if let checklist = checklistToEdit {
            checklist.name = textField.text!
            delegate?.listDetailViewController(controller: self, didFinishEditingChecklist: checklist)
        } else {
            let checklist = CheckList(name: textField.text!)
            delegate?.listDetailViewController(controller: self, didFinishAddingChecklist: checklist)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range:NSRange, replacementString string:String) -> Bool {

        let oldText:NSString = textField.text! as NSString
        let newText:NSString = oldText.replacingCharacters(in: range, with: string) as NSString
        
        doneBarButton.isEnabled = (newText.length > 0)
        
        return true
    }
}
