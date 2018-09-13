//
//  NetworkProviderTest.swift
//  worldAirportsTests
//
//  Created by Mario Acero on 9/13/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import XCTest
@testable import worldAirports

class NetworkProviderTest: XCTestCase {
    
    var networkProvider: NetworkProvider?
    var expectation: XCTestExpectation!
    var succesClosure: NetworkCustomClosure?
    var failureClosure: NetworkCustomClosure?
    
    override func setUp() {
        expectation = XCTestExpectation(description: "Network expectation")
        succesClosure = CustomClosureBuilder.provider(statusCode: 200, isSuccess: true)
        failureClosure = CustomClosureBuilder.provider(statusCode: 401, isSuccess: true)
        continueAfterFailure = false
        super.setUp()
    }
    
    override func tearDown() {
        networkProvider = nil
        succesClosure = nil
        failureClosure = nil
        super.tearDown()
    }
    
    func testGetToken() {
        networkProvider = NetworkProvider.init(customClosure: succesClosure!)
        
        networkProvider?.getAccesToken(completion: { [weak self ] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let jsonData):
                let jsonDecoder = JSONDecoder()
                let authResponse: Auth = try! jsonDecoder.decode(RawAuth.self, from: jsonData!.data)
                XCTAssertEqual(authResponse.access_token, "y8cv7aeph3vgp5vybwm3fgdz", "The values should be equals" )
            default:
                XCTAssert(false, "The response should be success ")
            }
            strongSelf.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetAirportsSuccess() {
        networkProvider = NetworkProvider.init(customClosure: succesClosure!)
        
        networkProvider?.getAirPorts(offset: 0, completion: {  [weak self ] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let jsonData):
                
                var json: [String:Any]?
                if let data = jsonData?.data {
                    do {
                        json = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String:Any]
                    } catch {
                        XCTAssert(false, "error json format")
                    }
                }
                XCTAssertNotNil(json, "The valuen don't be nil")
            default:
                break
            }
            strongSelf.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetAirportsFailure() {
        networkProvider = NetworkProvider.init(customClosure: failureClosure!)
        
        networkProvider?.getAirPorts(offset: 0, completion: { [weak self ] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false, "The response should be false")
            }
            strongSelf.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testGetSchedulesSuccess() {
        networkProvider = NetworkProvider.init(customClosure: succesClosure!)
        
        networkProvider?.getSchedules(departCode: "CUC", arriveCode: "BOG", date: "2018-09-12", completion: {  [weak self ] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .success(let jsonData):
                let decoder = JSONDecoder()
                if (try? decoder.decode(SchedulesList.self, from: jsonData!.data)) != nil {
                    XCTAssert(true)
                    strongSelf.expectation.fulfill()
                    return
                }
                XCTAssert(false, "Failed to get object")
            default:
                XCTAssert(false, "The response should be success")
            }
            strongSelf.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 5.0)
    }
    
    func testGetSchedulesFailure() {
        networkProvider = NetworkProvider.init(customClosure: failureClosure!)
        
        networkProvider?.getSchedules(departCode: "CUC", arriveCode: "BOG", date: "2018-09-12", completion: {  [weak self ] (response) in
            guard let strongSelf = self else { return }
            
            switch response {
            case .failure:
                XCTAssert(true)
            default:
                XCTAssert(false, "The response should be failure")
            }
            strongSelf.expectation.fulfill()
        })
        wait(for: [expectation], timeout: 1.0)
    }

}
