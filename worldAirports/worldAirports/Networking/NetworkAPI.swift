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
}

extension NetworkAPI: TargetType {
    
    var baseURL: URL {
        guard let url = URL(string: EnvironmentConfiguration.shared.APIEndpoint()!) else { fatalError("baseURL could not be configured.")}
        return url
    }
    
    var path: String {
        switch self {
        case .getToken:
            return EndPointsConfiguration.sharedInstance.getPath(endPointPath: BasicKeys.Oauth, endPointKey: BasicKeys.OauthKeys.getToken)
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getToken:
            return .post
        }
        
    }
    
    var sampleData: Data {
        switch self {
        case .getToken:
            return "{success data }".data(using: String.Encoding.utf8)!
        }
    }
    
    var failureData: Data {
        switch self {
        case .getToken:
            return "{failure data test}".data(using: String.Encoding.utf8)!
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
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .getToken:
            return ["Content-Type": "application/x-www-form-urlencoded"]
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
