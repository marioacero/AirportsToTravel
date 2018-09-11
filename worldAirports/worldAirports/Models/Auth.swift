//
//  Auth.swift
//  worldAirports
//
//  Created by Mario Acero on 9/9/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

protocol Auth {
    var access_token: String { get }
    var token_type: String { get }
    var expires_in: Int { get }
}

struct RawAuth: Auth, Codable {
    var access_token: String
    var token_type: String
    var expires_in: Int
}
