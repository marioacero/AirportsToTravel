//
//  AirportsRealm.swift
//  worldAirports
//
//  Created by Mario Acero on 9/10/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit
import RealmSwift

class AirportsRealm: Object {
    
    @objc dynamic var airportCode: String!
    @objc dynamic var name: String!
    
    var latitude = RealmOptional<Double>()
    var longitude = RealmOptional<Double>()
    
    
    override static func primaryKey() -> String {
        return "airportCode"
    }
}

