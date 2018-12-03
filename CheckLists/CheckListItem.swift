//
//  CheckListItem.swift
//  CheckLists
//
//  Created by human on 2018. 11. 21..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import Foundation

class CheckListItem : NSObject, NSCoding{
    
    //MARK: NSCoding protocol method impl
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        super.init()
    }
    
    override init(){
        super.init()
    }
        
    var text = ""
    var checked = false
    
    func toggleChecked(){
        checked = !checked
    }
    
}
