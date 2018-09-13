//
//  NetworkAPI.swift
//  worldAirports
//
//  Created by Mario Acero on 9/8/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import Moya

enum NetworkAPI {
    case getToken()
    case getAirports(offSet: Int)
    case getSchedule(depart: String, arrive: String, date: String)
    case getGoogleData(depart: AirportsRealm, arrival:AirportsRealm)
}

extension NetworkAPI: TargetType {
    
    var baseURL: URL {
        switch self {
        case .getAirports, .getSchedule, .getToken:
            guard let url = URL(string: EnvironmentConfiguration.shared.APIEndpoint()!) else { fatalError("baseURL could not be configured.")}
            return url
        case .getGoogleData:
            guard let url = URL(string: EnvironmentConfiguration.shared.googleAPI()!) else { fatalError("google url could not be configured.")}
            return url
        }
        
    }
    
    var path: String {
        switch self {
        case .getToken:
            return EndPointsConfiguration.sharedInstance.getPath(endPointPath: BasicKeys.Oauth, endPointKey: BasicKeys.OauthKeys.getToken)
        case .getAirports:
            return EndPointsConfiguration.sharedInstance.getPath(endPointPath: BasicKeys.References, endPointKey: BasicKeys.ReferencesKeys.getAirPorts)
        case .getSchedule(let departCode, let arriveCode, let date):
            let URl = EndPointsConfiguration.sharedInstance.getPath(endPointPath: BasicKeys.Operations, endPointKey: BasicKeys.OperationsKeys.getSchedule)
            return String(format: URl, departCode, arriveCode, date)
        case .getGoogleData:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getToken:
            return .post
        case .getAirports, .getSchedule, .getGoogleData :
            return .get
        }
        
    }
    
    var sampleData: Data {
        return MockLocator.shared.getMockData(action: self).data(using: String.Encoding.utf8)!
    }
    
    var failureData: Data {
        switch self {
        case .getToken:
            return "{failure data test}".data(using: String.Encoding.utf8)!
        case .getAirports:
            return "{failure data test}".data(using: String.Encoding.utf8)!
        case .getSchedule, .getGoogleData:
            return "{failure data }".data(using: String.Encoding.utf8)!
        }
    }
    
    var task: Task {
        switch self {
        case .getToken :
            guard let apiKey = EnvironmentConfiguration.shared.apiKey(), let secretKey = EnvironmentConfiguration.shared.secretKey() else {
                fatalError("Keys not configured")
            }
            
            return .requestParameters(parameters: ["client_id": apiKey,
                                                   "client_secret": secretKey,
                                                   "grant_type": "client_credentials"], encoding: URLEncoding.httpBody )
        case .getAirports(let offset):
            return .requestParameters(parameters: ["limit": 100,
                                                   "offset": offset ], encoding: URLEncoding.queryString )
        case .getSchedule:
            return .requestParameters(parameters: ["directFlights": 1 ], encoding: URLEncoding.queryString )
        case .getGoogleData:
            return .requestPlain
            
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        case .getAirports, .getSchedule, .getGoogleData:
            return ["Accept": "application/json",
                    "Authorization" : "Bearer \(EnvironmentConfiguration.accesToken!)"
            ]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
    
    
}
