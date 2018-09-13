//
//  SchedulesTableViewCell.swift
//  worldAirports
//
//  Created by Mario Acero on 9/12/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit

class SchedulesTableViewCell: UITableViewCell {

    @IBOutlet weak var departCode: UILabel!
    @IBOutlet weak var departTime: UILabel!
    @IBOutlet weak var arrivalCode: UILabel!
    @IBOutlet weak var arrivalTime: UILabel!
    @IBOutlet weak var durationTime: UILabel!
    @IBOutlet weak var flightNumber: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(row: SchedulesList.Schedule) {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"
        var date = dateFormatter.date(from: row.departTime!)
        let calendar = Calendar.current
        var comp = calendar.dateComponents([.hour, .minute], from: date!)
        departTime.text = "\(comp.hour!):\(comp.minute!)"
        date = dateFormatter.date(from: row.arrivalTime!)
        comp = calendar.dateComponents([.hour, .minute], from: date!)
        arrivalTime.text = "\(comp.hour!):\(comp.minute!)"
        
        departCode.text = row.departCode
        arrivalCode.text = row.arrivalCode
        durationTime.text = row.duration
        flightNumber.text = String(row.flightNumber!)
        
    }
    
}
