//
//  AuthRealm.swift
//  worldAirports
//
//  Created by Mario Acero on 9/9/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import RealmSwift

class AuthRealm: Object {
    
    
    @objc dynamic var id: Int = 1
    @objc dynamic var accesToken: String? = nil
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
