//
//  MockLocator.swift
//  worldAirports
//
//  Created by Mario Acero on 9/13/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

class MockLocator {
    
    static var shared = MockLocator()
    
    func getMockData(action: NetworkAPI)-> String {
        var fileName: String!
        let txtFile = "json"
        
        switch action {
        case .getToken:
            fileName = "OauthResponse"
        case .getAirports:
            fileName = "getAirportsResponse"
        case .getSchedule:
            fileName = "getSchedulesResponse"
        default:
            break
        }
        
        let bundle = Bundle(for: type(of: self))
        let path = bundle.path(forResource: fileName, ofType: txtFile)!
        return try! String(contentsOfFile: path)
    }
}
