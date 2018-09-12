//
//  AirPortSearchViewModel.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

class AirPortSearchViewModel {
    
    var showAutoComplete: (()->())?
    var closeAutoComplete: (()->())?
    var isContinueButtonEnbled: ((Bool)->())?
    var showLoadingAnimated: ((Bool)->())?
    
    var networkProvider: NetworkProvider!
    var objectsToAutoComplete: AirportsDictionary!
    var departAirport: AirportsRealm?  {
        didSet {
            validateDataToContinue()
        }
    }
    var arriveAirport: AirportsRealm? {
        didSet {
            validateDataToContinue()
        }
    }
    
    
    init() {
        networkProvider = NetworkProvider()
    }
    
    
    func getSchedules() {
        showLoadingAnimated?(true)
        networkProvider.getSchedules(departCode: departAirport!.airportCode,
                                     arriveCode: arriveAirport!.airportCode,
                                     date: "2018-09-12") { [weak self] (response) in
                       
            
            guard let strongSelf = self else { return }
                                        
            strongSelf.showLoadingAnimated?(false)
            switch response {
            case .success(let response):
                break
            default:
                break
            }
        }
    }
    
    func getDataSourceAutoComplete(textToSearch: String) {
        let predicate = NSPredicate(format: "name contains[c] %@", textToSearch)
        objectsToAutoComplete = RealmManager.shared.getAllWithPredicate(Class: AirportsRealm.self, equalParam: predicate)
        if !objectsToAutoComplete.isEmpty {
            showAutoComplete?()
        }
    }
    
    private func validateDataToContinue() {
        if departAirport != nil && arriveAirport != nil {
            isContinueButtonEnbled?(true)
            return
        }
        
        isContinueButtonEnbled?(false)
    }
}
