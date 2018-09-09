//
//  EndPointsConfiguration.swift
//  worldAirports
//
//  Created by Mario Acero on 9/8/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

struct BasicKeys {
    static let Oauth = "Oauth"
    static let References = "References"
    
    struct OauthKeys {
        static let getToken = "getToken"
    }
    
    struct ReferencesKeys {
        static let getAirPorts = "getAirPorts"
    }
}

class EndPointsConfiguration: NSObject {
    
    struct Constants {
        static let endpointFile = "EndPoints"
        static let endPointExtension = "plist"
    }
    
    var servicesKeys : NSDictionary
    
    private static var instance: EndPointsConfiguration?
    
    static var sharedInstance: EndPointsConfiguration {
        if instance == nil {
            instance = EndPointsConfiguration()
        }
        return instance!
    }
    
    private override init() {
        let bundle = Bundle(for: type(of: self))
        let servicesPath = bundle.path(forResource: Constants.endpointFile, ofType: Constants.endPointExtension)
        let configurationsDic = NSDictionary(contentsOfFile: servicesPath!)
        print("a")
//        self.servicesKeys = configurationsDic?.object(forKey: basicKeys.services) as! NSDictionary
        self.servicesKeys = configurationsDic!
    }
    
    func getPath(endPointPath: String, endPointKey: String )-> String {
        let dictionary  = self.servicesKeys.object(forKey: endPointPath) as! NSDictionary
        return dictionary.object(forKey: endPointKey) as! String
    }
}

