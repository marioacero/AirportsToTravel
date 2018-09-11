//
//  Network.swift
//  worldAirports
//
//  Created by Mario Acero on 9/8/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation
import Moya

enum ApiServiceResponse {
    case failure(error: Any?)
    case notConnectedToInternet
    case success(response: Response?)
}

typealias ApiServiceResponseClosure = (ApiServiceResponse) -> Void

protocol Network {
    associatedtype T: TargetType
    var provider: MoyaProvider<T> { get }
}
