//
//  AirPortSearchViewModel.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

class AirPortSearchViewModel: BaseViewModel {
    
    var showAutoComplete: (()->())?
    var closeAutoComplete: (()->())?
    var notSchedulesAlert: (()->())?
    var gotToSchedule: ((SchedulesList)->())?
    var isContinueButtonEnbled: ((Bool)->())?
    var showLoadingAnimated: ((Bool)->())?
    
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
    
    override init() {
        super.init()
    }
    
    func getSchedules() {
        showLoadingAnimated?(true)
        networkProvider.getSchedules(departCode: departAirport!.airportCode,
                                     arriveCode: arriveAirport!.airportCode,
                                     date: "2018-09-12") { [weak self] (response) in
            guard let strongSelf = self else { return }
                                        
            strongSelf.showLoadingAnimated?(false)
            switch response {
            case .success(let jsonData):
                let decoder = JSONDecoder()
                if let schedules = try? decoder.decode(SchedulesList.self, from: jsonData!.data) {
                    strongSelf.gotToSchedule?(schedules)
                }
            case .failure(let error):
                switch error?.response?.statusCode {
                case 401:
                    strongSelf.networkProvider.getAccesToken(completion: { (tokenResponse) in
                        strongSelf.getAccesToken{
                            strongSelf.getSchedules()
                        }
                    })
                case 404:
                    strongSelf.notSchedulesAlert?()
                default:
                    break
                }
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
