//
//  DataModel.swift
//  CheckLists
//
//  Created by human on 2018. 12. 3..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import Foundation

class DataModel {
    
    //MARK: - Initialize
    init(){
        loadChecklists()
        registerDefaults()
        handleFirstTime()
    }
    
    //MARK: - Load and Save Checklist
    
    var lists = [CheckList]()
    
    let checklistsArchiveURL:NSURL = {
        
        let documentsDirectoryes = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = documentsDirectoryes.first!
        
        return documentDirectory.appendingPathComponent("checklists8800.archive") as NSURL
    }()
    
    var indexOfSelectedChecklist: Int{
        get {
            return UserDefaults.standard.integer(forKey: "ChecklistIndex")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "ChecklistIndex")
            UserDefaults.standard.synchronize()
        }
    }
    func documentsDirectory() -> String{
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        return path[0]
    }
    
    func saveChecklists(){
        let success = saveChanges()
        
        if(success){
            print("Saved all of the Items")
        } else {
            print("Could not save any of the Items")
        }
    }
    
    func loadChecklists(){
        if let archivedItems = NSKeyedUnarchiver.unarchiveObject(withFile: checklistsArchiveURL.path!) as? [CheckList] {
            lists += archivedItems
        }
    }
    
    
    func saveChanges() -> Bool {
        print("Saving items to: \(String(describing: checklistsArchiveURL.path))")
        
        return NSKeyedArchiver.archiveRootObject(lists, toFile:checklistsArchiveURL.path!)
    }
    
    func registerDefaults(){
        let dictionary:[String:Any] = ["ChecklistIndex": -1, "FirstTime": true, "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
    }
    
    func handleFirstTime(){
        let userDefaults = UserDefaults.standard
        let firstTime = userDefaults.bool(forKey: "FirstTime")

        if firstTime {
            let checklist = CheckList(name: "List")
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            UserDefaults.standard.set(false, forKey: "FirstTime")
        }
    }
    
    func sortChecklists(){
        lists.sort(by: {checklist1, checklist2 in return
            checklist1.name.localizedStandardCompare(checklist2.name) == ComparisonResult.orderedAscending
        })
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        
        return itemID
    }
}
