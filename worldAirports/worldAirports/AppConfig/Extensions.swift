//
//  Extensions.swift
//  worldAirports
//
//  Created by Mario Acero on 9/12/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import UIKit


extension NSObject {
    
    /// Name of the class
    class var stringRepresentation: String {
        let name = String(describing: self)
        return name
    }
}

extension UITableView {
    
    internal func registerNib(_ nibName: String) {
        //print(nibName)
        let cellNib = UINib.init(nibName: nibName, bundle: nil)
        register(cellNib, forCellReuseIdentifier: nibName)
    }
}
