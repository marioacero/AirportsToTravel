//
//  SchedulesViewController.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit

class SchedulesViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: SchedulesViewModel = {
        return SchedulesViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.registerNib(SchedulesTableViewCell.stringRepresentation)
    }
}

extension SchedulesViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SchedulesTableViewCell = tableView.dequeueReusableCell(withIdentifier: SchedulesTableViewCell.stringRepresentation) as! SchedulesTableViewCell
        
        let row = viewModel.dataSource.bookings[indexPath.row]
        cell.setCell(row: row)
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.bookings.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToMaps", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let controller: MapsViewController = segue.destination as! MapsViewController
        controller.viewModel.originDetination = (viewModel.departAirport, viewModel.arrivalAirport)
        let backItem = UIBarButtonItem()
        backItem.title = "Schedules"
        navigationItem.backBarButtonItem = backItem
    }
}
