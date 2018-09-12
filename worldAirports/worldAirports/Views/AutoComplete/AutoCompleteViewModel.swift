//
//  AutoCompleteViewModel.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

class AutoCompleteViewModel {
    
    var dataSource:AirportsDictionary! {
        didSet {
            reloadData?()
        }
    }
    
    var reloadData: (()->())?
    
}

