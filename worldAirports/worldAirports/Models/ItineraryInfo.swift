//
//  ItineraryInfo.swift
//  worldAirports
//
//  Created by Mario Acero on 9/12/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import Foundation

struct SchedulesList: Decodable {
    
    var bookings: [Schedule] = []
    
    struct Schedule {
        var duration: String?
        var departCode: String?
        var departTime: String?
        var arrivalCode: String?
        var arrivalTime: String?
        var flightNumber: Int?
        var airline: String?
    }
    
    enum CodingKeys: String, CodingKey {
        case ScheduleResource
        case Schedule
        case TotalJourney
        case Duration
        case Flight
        case Departure
        case AirportCode
        case ScheduledTimeLocal
        case DateTime
        case Arrival
        case MarketingCarrier
        case AirlineID
        case FlightNumber
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let ScheduleResource = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ScheduleResource)
        var scheduleObject = try ScheduleResource.nestedUnkeyedContainer(forKey: .Schedule)
        
        while !scheduleObject.isAtEnd {
            let scheduleRow = try scheduleObject.nestedContainer(keyedBy: CodingKeys.self)
            
            let journey = try scheduleRow.nestedContainer(keyedBy: CodingKeys.self, forKey: .TotalJourney)
            let duration = try journey.decode(String.self, forKey: .Duration)
            
            let flight = try scheduleRow.nestedContainer(keyedBy: CodingKeys.self, forKey: .Flight)
            
            let departInfo = try flight.nestedContainer(keyedBy: CodingKeys.self, forKey: .Departure)
            let departCode = try departInfo.decode(String.self, forKey: .AirportCode)
            
            let departTimeObject = try departInfo.nestedContainer(keyedBy: CodingKeys.self, forKey: .ScheduledTimeLocal)
            let departTime = try departTimeObject.decode(String.self, forKey: .DateTime)
            
            let arrivalInfo = try flight.nestedContainer(keyedBy: CodingKeys.self, forKey: .Arrival)
            let arrivalCode = try arrivalInfo.decode(String.self, forKey: .AirportCode)
            
            let arrivalTimeObject = try arrivalInfo.nestedContainer(keyedBy: CodingKeys.self, forKey: .ScheduledTimeLocal)
            let arrivalTime = try arrivalTimeObject.decode(String.self, forKey: .DateTime)
            
            let marketing = try flight.nestedContainer(keyedBy: CodingKeys.self, forKey: .MarketingCarrier)
            let airline = try marketing.decode(String.self, forKey: .AirlineID)
            let flightNumber = try marketing.decode(Int.self, forKey: .FlightNumber)
            
            let booking = Schedule(duration: duration,
                                 departCode: departCode,
                                 departTime: departTime,
                                 arrivalCode: arrivalCode,
                                 arrivalTime: arrivalTime,
                                 flightNumber: flightNumber,
                                 airline: airline)
            self.bookings.append(booking)
        }
    }
}
