//
//  BaseViewModel.swift
//  worldAirports
//
//  Created by Mario Acero on 9/12/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation


class BaseViewModel {
    var networkProvider: NetworkProvider!
    
    init() {
        networkProvider = NetworkProvider()
    }
    
    func getAccesToken(completion: @escaping (()->())) {
        networkProvider.getAccesToken { (response) in
            switch response {
            case .success(let jsonData):
                let jsonDecoder = JSONDecoder()
                let authResponse: Auth = try! jsonDecoder.decode(RawAuth.self, from: jsonData!.data)
                let authCache = AuthRealm()
                authCache.accesToken = authResponse.access_token
                RealmManager.shared.addObject(object: authCache, update: true)
            case .notConnectedToInternet:
                break
            case .failure:
                break
            }
            completion()
        }
    }
}
