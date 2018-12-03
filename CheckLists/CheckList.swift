//
//  CheckList.swift
//  CheckLists
//
//  Created by human on 2018. 11. 28..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import UIKit

class CheckList: NSObject, NSCoding {
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "Name")
        aCoder.encode(items, forKey: "Items")
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: "Name") as! String
        items = aDecoder.decodeObject(forKey: "Items") as! [CheckListItem]
    }
    
    var name = ""
    var items = [CheckListItem]()
    
    init(name: String){
        self.name = name
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
}
