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
    }
    
    func setCell(row: SchedulesList.Schedule) {
        departTime.text = row.departTime
        arrivalTime.text = row.arrivalTime
        departCode.text = row.departCode
        arrivalCode.text = row.arrivalCode
        durationTime.text = row.duration
        flightNumber.text = String(row.flightNumber!)
    }
    
}
