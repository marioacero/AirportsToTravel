//
//  NetworkProvider.swift
//  worldAirports
//
//  Created by Mario Acero on 9/8/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import Result
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
    
    func getAccesToken(completion: @escaping ApiServiceResponseClosure) {
        provider.request(.getToken()) { [weak self] (response) in
            guard let strongSelf = self else {
                completion(.failure(error: nil))
                return
            }
            
            strongSelf.validateResponse(response: response, completion: completion)
        }
    }
    
    func getAirPorts(offset: Int, completion: @escaping ApiServiceResponseClosure) {
        provider.request(.getAirports(offSet: offset)) { [weak self] (response) in
            guard let strongSelf = self else {
                completion(.failure(error: nil))
                return
            }
            
            strongSelf.validateResponse(response: response, completion: completion)
        }
    }
    
    func getSchedules(departCode: String, arriveCode: String, date: String, completion: @escaping ApiServiceResponseClosure) {
        provider.request(.getSchedule(depart: departCode, arrive: arriveCode, date: date)) { [weak self] (response) in
            guard let strongSelf = self else {
                completion(.failure(error: nil))
                return
            }
            
            strongSelf.validateResponse(response: response, completion: completion)
        }
    }
    
    func getGoogleData() {
        
    }
    
    private func validateResponse( response: Result<Moya.Response, MoyaError>, completion: @escaping ApiServiceResponseClosure) {
        switch response {
        case .success(let result):
            completion(.success(response: result))
        case .failure(let error):
            completion(.failure(error: error))
        }
    }
}
