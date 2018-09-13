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
        let dateFormatter = DateFormatter()
        let calendar = Calendar.current
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        
        
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let ScheduleResource = try container.nestedContainer(keyedBy: CodingKeys.self, forKey: .ScheduleResource)
        var scheduleObject = try ScheduleResource.nestedUnkeyedContainer(forKey: .Schedule)
        
        while !scheduleObject.isAtEnd {
            let scheduleRow = try scheduleObject.nestedContainer(keyedBy: CodingKeys.self)
            
            let journey = try scheduleRow.nestedContainer(keyedBy: CodingKeys.self, forKey: .TotalJourney)
            let duration = try journey.decode(String.self, forKey: .Duration).replacingOccurrences(of: "P", with: "").replacingOccurrences(of: "T", with: "")
            
            let flight = try scheduleRow.nestedContainer(keyedBy: CodingKeys.self, forKey: .Flight)
            
            let departInfo = try flight.nestedContainer(keyedBy: CodingKeys.self, forKey: .Departure)
            let departCode = try departInfo.decode(String.self, forKey: .AirportCode)
            
            let departTimeObject = try departInfo.nestedContainer(keyedBy: CodingKeys.self, forKey: .ScheduledTimeLocal)
            let departDate = try departTimeObject.decode(String.self, forKey: .DateTime)
            var date = dateFormatter.date(from: departDate)
            var comp = calendar.dateComponents([.hour, .minute], from: date!)
            let departTime = "\(comp.hour!):\(comp.minute!)"
            
            let arrivalInfo = try flight.nestedContainer(keyedBy: CodingKeys.self, forKey: .Arrival)
            let arrivalCode = try arrivalInfo.decode(String.self, forKey: .AirportCode)
            
            let arrivalTimeObject = try arrivalInfo.nestedContainer(keyedBy: CodingKeys.self, forKey: .ScheduledTimeLocal)
            let arrivalDate = try arrivalTimeObject.decode(String.self, forKey: .DateTime)
            date = dateFormatter.date(from: arrivalDate)
            comp = calendar.dateComponents([.hour, .minute], from: date!)
            let arrivalTime = "\(comp.hour!):\(comp.minute!)"
            
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
