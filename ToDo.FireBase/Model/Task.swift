//
//  Task.swift
//  ToDo.FireBase
//
//  Created by Aleksandr Kurdiukov on 28.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import Foundation
import Firebase

struct Task{
    let title: String
    let userID: String
    let ref: DatabaseReference?
    var completed = false
    
    init(title: String, userID: String){
        self.title = title
        self.userID = userID
        self.ref = nil
    }
    
    init (snapshot: DataSnapshot){
        let snapshotValue = snapshot.value as! [String: AnyObject]
        title = snapshotValue["title"] as! String
        userID = snapshotValue["userID"] as! String
        completed = snapshotValue["completed"] as! Bool
        ref = snapshot.ref
    }
    
    func convertToDict() -> Any {
        return ["title": title, "userID": userID, "completed": completed]
    }
    
}
