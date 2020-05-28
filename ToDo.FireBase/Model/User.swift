//
//  User.swift
//  ToDo.FireBase
//
//  Created by Aleksandr Kurdiukov on 28.05.20.
//  Copyright © 2020 Zizlak. All rights reserved.
//

import Foundation
import Firebase

struct UserT {
    let uid: String
    let email: String
    
    init (user: User){
        self.uid = user.uid
        self.email = user.email!
    }
}
