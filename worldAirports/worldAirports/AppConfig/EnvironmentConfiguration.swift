//
//  EnvironmentConfiguration.swift
//  worldAirports
//
//  Created by Mario Acero on 9/8/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

class EnvironmentConfiguration {
    
    struct EnvironmentConstants{
        static let ApiEndpointKey = "base-url"
        static let ApiKey = "api-key"
        static let SecretKey = "client_secret"
        static let EnvironmentsFile = "Environments"
    }
    
    var configurationPath : String!
    var servicesKeys : NSDictionary!
    
    static let shared = EnvironmentConfiguration()
    init() {
        let bundle = Bundle(for: type(of: self))
        self.configurationPath = bundle.infoDictionary!["Configuration"] as! String?
        let environmentPath = bundle.path(forResource: EnvironmentConstants.EnvironmentsFile , ofType:"plist")
        let configurationsDic = NSDictionary(contentsOfFile: environmentPath!)
        self.servicesKeys = (configurationsDic?.object(forKey:self.configurationPath.trimmingCharacters(in: CharacterSet.whitespaces))) as! NSDictionary?
    }
    
    func configuration() -> String {
        return EnvironmentConfiguration.shared.configurationPath
    }
    

    func APIEndpoint() -> String? {
        let sharedConfiguration = EnvironmentConfiguration.shared
        let servicesKeysCount = sharedConfiguration.servicesKeys.allKeys.count
        if servicesKeysCount != 0 {
            return sharedConfiguration.servicesKeys.object(forKey: EnvironmentConstants.ApiEndpointKey) as? String
        }
        return nil
    }
    
    func apiKey() -> String? {
        let sharedConfiguration = EnvironmentConfiguration.shared
        let servicesKeysCount = sharedConfiguration.servicesKeys.allKeys.count
        if servicesKeysCount != 0 {
            return sharedConfiguration.servicesKeys.object(forKey: EnvironmentConstants.ApiKey) as? String
        }
        return nil
    }
    
    func secretKey() -> String? {
        let sharedConfiguration = EnvironmentConfiguration.shared
        let servicesKeysCount = sharedConfiguration.servicesKeys.allKeys.count
        if servicesKeysCount != 0 {
            return sharedConfiguration.servicesKeys.object(forKey: EnvironmentConstants.SecretKey) as? String
        }
        return nil
    }
}
