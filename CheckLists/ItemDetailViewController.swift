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
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    
    var itemToEdit: CheckListItem?
    var dueDate = NSDate()
    var datePickerVisible = false
    
    @IBAction func cancel(){
        delegate?.itemDetailViewControllerDidCancel(controller: self)
    }
    
    @IBAction func done(){
        
        if let item = itemToEdit {
            item.text = textField.text ?? "test"
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(controller: self, didFinishEditingItem: item)
        }else {
            let item = CheckListItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailViewController(controller: self, didFinishAddingItem: item)
        }
        
    }
 
    @IBAction func shouldRemindToggled(switchControl: UISwitch){
        textField.resignFirstResponder()
        if switchControl.isOn {
            let notificationSettings = UIUserNotificationSettings(types: .alert, categories: nil)
            UIApplication.shared.registerUserNotificationSettings(notificationSettings)
        }
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
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideDatePicker()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneBarButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        
        updateDueDateLabel()
        
    }
    
    func updateDueDateLabel(){
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        dueDateLabel.text = formatter.string(from: dueDate as Date)
    }
    
    //MARK: - datePicker method
    func showDatePicker(){
        datePickerVisible = true
        
        let indexPathDateRow = NSIndexPath(row: 1, section: 1)
        let indexPathDatePicker = NSIndexPath(row: 2, section: 1)
        
        if let dateCell = tableView.cellForRow(at: indexPathDateRow as IndexPath) {
            dateCell.detailTextLabel!.textColor = dateCell.detailTextLabel!.tintColor
        }
        
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPathDatePicker as IndexPath], with: .fade)
        tableView.reloadRows(at: [indexPathDateRow as IndexPath], with: .none)
        tableView.endUpdates()
        
        if let pickerCell = tableView.cellForRow(at: indexPathDatePicker as IndexPath) {
            let datePicker = pickerCell.viewWithTag(1000) as! UIDatePicker
            datePicker.setDate(dueDate as Date, animated: false)
        }
    }
    
    func hideDatePicker(){
        if datePickerVisible {
            datePickerVisible = false
            
            let indexPathDateRow = NSIndexPath(row: 1, section: 1)
            let indexPathDatePicker = NSIndexPath(row: 2, section: 1)
            
            if let cell = tableView.cellForRow(at: indexPathDateRow as IndexPath) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow as IndexPath], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker as IndexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //1
        if indexPath.section == 1 && indexPath.row == 2 {
            
            //2
            var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "DatePickerCell")
            
            if cell == nil{
                cell = UITableViewCell(style: .default, reuseIdentifier: "DatePickerCell")
                cell.selectionStyle = .none
                
                //3
                let datePicker = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 320, height: 216))
                datePicker.tag = 1000
                cell.contentView.addSubview(datePicker)
                
                //4
                datePicker.addTarget(self, action: #selector(ItemDetailViewController.dateChanged(datePicker:)), for: .valueChanged)
            }
            return cell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1 && datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        
        if indexPath.section == 1 && indexPath.row == 1 {
            if !datePickerVisible {
                showDatePicker()
            } else {
                hideDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1 && indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
 
        if indexPath.section == 1 && indexPath.row == 2{
            let indexPathNew = NSIndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: indexPathNew as IndexPath)
        }
        
        return super.tableView(tableView, indentationLevelForRowAt: indexPath as IndexPath)
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1 && indexPath.row == 1{
            return indexPath
        } else {
            return nil
        }
    }
    
    @objc func dateChanged(datePicker: UIDatePicker){
        dueDate = datePicker.date as NSDate
        updateDueDateLabel()
    }
    
    
}
