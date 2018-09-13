//
//  CustomClosureBuilder.swift
//  worldAirportsTests
//
//  Created by Mario Acero on 9/13/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import Moya
@testable import worldAirports

class CustomClosureBuilder: NSObject {
    
    static func provider(statusCode: Int, isSuccess: Bool)-> NetworkCustomClosure {
        let customClosure = { (target: NetworkAPI) -> Endpoint in
            var sampleData: Data = target.sampleData
            if !isSuccess {
                sampleData = target.failureData
            }
            
            return Endpoint(url: URL(target: target).absoluteString,
                            sampleResponseClosure: { .networkResponse(statusCode, sampleData ) },
                            method: target.method,
                            task: target.task,
                            httpHeaderFields: target.headers)
        }
        return customClosure
    }
    
    
}
