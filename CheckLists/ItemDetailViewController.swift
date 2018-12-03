//
//  AddItemViewController.swift
//  CheckLists
//
//  Created by human on 2018. 11. 22..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import UIKit

protocol ItemDetailViewControllerDelegate: class {
    func itemDetailViewControllerDidCancel(controller:ItemDetailViewController)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item:CheckListItem)
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item:CheckListItem)
}

class ItemDetailViewController: UITableViewController , UITextFieldDelegate{
    
    weak var delegate: ItemDetailViewControllerDelegate?
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var calcelBarButton: UIBarButtonItem!
    @IBOutlet weak var doneBarButton: UIBarButtonItem!
    
    var itemToEdit: CheckListItem?
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done(){
        
        if let item = itemToEdit {
            item.text = textField.text ?? "test"
            
            delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
        }else {
            let item = CheckListItem()
            item.text = textField.text!
            item.checked = false
            
            delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
        }
        
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let oldText: NSString = textField.text! as NSString
        let newText: NSString = oldText.replacingCharacters(in: range, with: string) as NSString

        doneBarButton.isEnabled = (newText.length > 0)
 
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
        }
    }
}
