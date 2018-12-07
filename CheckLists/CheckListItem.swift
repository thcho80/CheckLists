//
//  CheckListItem.swift
//  CheckLists
//
//  Created by human on 2018. 11. 21..
//  Copyright © 2018년 com.humantrion. All rights reserved.
//

import Foundation
import UIKit

class CheckListItem : NSObject, NSCoding{
    
    var text = ""
    var checked = false
    var dueDate = NSDate()
    var shouldRemind = false
    var itemID: Int
    
    //MARK: NSCoding protocol method impl
    func encode(with aCoder: NSCoder) {
        aCoder.encode(text, forKey: "Text")
        aCoder.encode(checked, forKey: "Checked")
        aCoder.encode(dueDate, forKey: "DueDate")
        aCoder.encode(shouldRemind, forKey: "ShouldRemind")
        aCoder.encode(itemID, forKey: "ItemID")
    }
    
    required init?(coder aDecoder: NSCoder) {
        text = aDecoder.decodeObject(forKey: "Text") as! String
        checked = aDecoder.decodeBool(forKey: "Checked")
        dueDate = aDecoder.decodeObject(forKey: "DueDate") as! NSDate
        shouldRemind = aDecoder.decodeBool(forKey: "ShouldRemind")
        itemID = aDecoder.decodeInteger(forKey: "ItemID")
        
        super.init()
    }
    
    override init(){
        itemID = DataModel.nextChecklistItemID()
        super.init()
    }
    
    deinit {
        let existingNotification = notificationForThisItem()
        
        if let notification = existingNotification {
            print("removing existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
    }
    
    
    func toggleChecked(){
        checked = !checked
    }
    
    func scheduleNotification(){
        
        let existingNotification = notificationForThisItem()
        if let notification = existingNotification {
            print("Found an existing notification \(notification)")
            UIApplication.shared.cancelLocalNotification(notification)
        }
        
        if shouldRemind && dueDate.compare(NSDate() as Date) != ComparisonResult.orderedAscending {
        
            let localNotification = UILocalNotification()
            localNotification.fireDate = dueDate as Date
            localNotification.timeZone = NSTimeZone.default
            localNotification.alertBody = text
            localNotification.soundName = UILocalNotificationDefaultSoundName
            localNotification.userInfo = ["ItemID": itemID]
            UIApplication.shared.scheduledLocalNotifications?.append(localNotification)
            
            print("Scheduled notification \(localNotification) for itemID \(itemID)")
        }
    }
    
    func notificationForThisItem()->UILocalNotification? {
        let allNotification = UIApplication.shared.scheduledLocalNotifications as! [UILocalNotification]
        
        for notification in allNotification {
            if let number = notification.userInfo?["ItemID"] as? NSNumber {
                return notification
            }
        }
        return nil
    }
    
}
