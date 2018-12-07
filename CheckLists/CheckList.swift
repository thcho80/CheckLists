//
//  CheckList.swift
//  CheckLists
//
//  Created by human on 2018. 11. 28..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import UIKit

class CheckList: NSObject, NSCoding {
    
    var name = ""
    var items = [CheckListItem]()
    var iconName:String
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
        aCoder.encode(iconName, forKey: "IconName")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [CheckListItem]
        iconName = aDecoder.decodeObject(forKey: "IconName") as! String
    }
    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name:String, iconName:String){
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    func countUnCheckedItems()->Int {
        var count = 0
        for item in items {
            if !item.checked {
                count += 1
            }
        }
        return count
    }
    
    func sort(){
        items.sort(by: {items1, items2 in return
            items1.text.localizedStandardCompare(items2.text) == ComparisonResult.orderedAscending
        })
    }
    
}
