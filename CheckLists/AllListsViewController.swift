//
//  AllListsViewController.swift
//  CheckLists
//
//  Created by human on 2018. 11. 27..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import UIKit

class AllListsViewController: UITableViewController, ListDetailViewControllerDelegate, UINavigationControllerDelegate{
    
    var dataModel: DataModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func viewDidAppear(_ animated: Bool) {
        print(#function)
        
        super.viewDidAppear(animated)
        navigationController?.delegate = self
        
        let index = dataModel.indexOfSelectedChecklist
        if index != -1 {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: "ShowChecklist", sender: checklist)
        }
    }
    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataModel.lists.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellIdentifier = "Cell"
        var cell:UITableViewCell! = tableView.dequeueReusableCell(withIdentifier: cellIdentifier)
        
        if cell == nil{
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }

        let checklist = dataModel.lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        let remainingCount = checklist.countUnCheckedItems()
        if checklist.items.count == 0{
            cell.detailTextLabel!.text = "(No Items)"
        } else if remainingCount == 0{
            cell.detailTextLabel!.text = "All done!"
        } else {
            cell.detailTextLabel!.text = "\(remainingCount) Remaining"
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(#function)
        
        dataModel.indexOfSelectedChecklist = indexPath.row
        
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: "ShowChecklist", sender:   checklist)
    }
    
    //MARK: - Segue configure
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(#function)
        
        switch segue.identifier {
        case "ShowChecklist"?:
            let controller = segue.destination as! CheckListViewController
            controller.checklist = sender as! CheckList
        case "AddChecklist"?:
            let navigationController = segue.destination as! UINavigationController
            let controller = navigationController.topViewController as! ListDetailViewController

            controller.delegate = self
            controller.checklistToEdit = nil
        default:
            preconditionFailure("Unexpected segue identifier.")
        }
        
    }
    
    //MARK: - ListDetailViewControllerDelegate implement
    func listDetailViewControllerDidCancel(controller: ListDetailViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishAddingChecklist checklist: CheckList) {
        
        
        let newRowIndex = dataModel.lists.count
        dataModel.lists.append(checklist)
        
        let indexPath = NSIndexPath(row: newRowIndex
            , section: 0)
        let indexPaths = [indexPath]
        tableView.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailViewController(controller: ListDetailViewController, didFinishEditingChecklist checklist: CheckList) {

        if let index = dataModel.lists.firstIndex(of: checklist) {
            let indexPath = NSIndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath as IndexPath){
                cell.textLabel!.text = checklist.name
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    //MARK: - table action
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListNavigationController") as! UINavigationController
        let controller = navigationController.topViewController as! ListDetailViewController
        let checklist = dataModel.lists[indexPath.row]
        controller.checklistToEdit = checklist
        
        present(navigationController, animated: true, completion: nil)
    }
    
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
       
        print(#function)
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
}
