//
//  AirPort.swift
//  worldAirports
//
//  Created by Mario Acero on 9/9/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import UIKit

protocol AirPort {
    
    var name: String? { get }
    var airportCode: String? { get }
    var latitude: Double? { get }
    var longitude: Double? { get }
    
}

struct RawAirPort: AirPort {
    
    var name: String?
    var airportCode: String?
    var latitude: Double?
    var longitude: Double?
    
    init?(jsonData: [String: Any]) {
        guard let names = jsonData["Names"] as? [String: Any],
            let nameDict =  names["Name"] as? [[String: Any]] else {
                return nil
        }
        
        var cityName = ""
        for i in 0..<nameDict.count {
            if nameDict[i]["@LanguageCode"] as? String == "en" {
                guard let name = nameDict[i]["$"] as? String else {
                    return nil
                }
                cityName = name
                break
            }
        }
        
        guard let code = jsonData["AirportCode"] as? String else {
            return nil
        }
        
        self.airportCode = code
        self.name = "\(cityName) \(code)"
        
        guard let position = jsonData["Position"] as? [String: Any],
        let coord = position["Coordinate"] as? [String: Any] else {
                return nil
        }
        
        guard let lat =  coord["Latitude"] as? Double, let long =  coord["Longitude"] as? Double else {
            return nil
        }
        
        self.latitude = lat
        self.longitude = long
        
    }
}
