//
//  NetworkProvider.swift
//  worldAirports
//
//  Created by Mario Acero on 9/8/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

import Moya

typealias NetworkCustomClosure = (NetworkAPI) -> Endpoint

class NetworkProvider: Network {
    
    var provider: MoyaProvider<NetworkAPI>
    
    required init(customClosure: NetworkCustomClosure? = nil) {
        if customClosure == nil {
            provider = MoyaProvider<NetworkAPI> (plugins: [NetworkLoggerPlugin(verbose: true)])
            return
        }
        provider = MoyaProvider<NetworkAPI>(endpointClosure: customClosure!, stubClosure: MoyaProvider.immediatelyStub)
    }
    
    func sendRequest(completion: @escaping (ApiServiceResponse)->()){
        provider.request(.getToken()) { (response) in
            print(response)
        }
    }
}
