//
//  ViewController.swift
//  CheckLists
//
//  Created by human on 2018. 11. 20..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import UIKit

class CheckListViewController:UITableViewController, ItemDetailViewControllerDelegate {

    var checklist: CheckList!
 
    //MARK: - initializier
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 44
        title = checklist.name
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
    }
    
    
    // MARK: - AddItemViewController delegate implement
    func itemDetailViewControllerDidCancel(controller: ItemDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishAddingItem item: CheckListItem) {
        checklist.items.append(item)
        checklist.sort()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func itemDetailViewController(controller: ItemDetailViewController, didFinishEditingItem item: CheckListItem){
        checklist.sort()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: - Table method delegate
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: "CheckListitem") as? UITableViewCell
        
        let item = checklist.items[indexPath.row]
        
        configureTextForCell(cell: cell, withTextItem: item)
        configureCheckmarkForCell(cell: cell, withCheckListItem: item)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let cell = tableView.cellForRow(at: indexPath){
            let item = checklist.items[indexPath.row]
            item.toggleChecked()
            configureCheckmarkForCell(cell: cell, withCheckListItem: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {

        checklist.items.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    //MARK: - segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch segue.identifier {
        case "AddItem"?:
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
        case "EditItem"?:
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ItemDetailViewController
            controller.delegate = self
            
            if let indexPath = tableView.indexPath(for: sender as! UITableViewCell){
                controller.itemToEdit = checklist.items[indexPath.row]
            }
            
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
    }
    
    //MARK: - Cell Configure method
    func configureCheckmarkForCell(cell:UITableViewCell, withCheckListItem item:CheckListItem){
        
        let label = cell.viewWithTag(101) as! UILabel
        
        if item.checked {
            label.text = "√"
        }else {
            label.text = ""
        }
    }
    
    func configureTextForCell(cell:UITableViewCell, withTextItem item:CheckListItem){
        let label = cell.viewWithTag(100) as! UILabel
        label.text = item.text
//        label.text = "\(item.itemID): \(item.text)"
    }
   
}

