//
//  AutoCompleteViewController.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit

protocol AutoCompleteDelegate: class {
    func selectAirport(airPort: AirportsRealm )
}

class AutoCompleteViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: AutoCompleteViewModel = {
        return AutoCompleteViewModel()
    }()
    
    weak var autoCompleteDelegate: AutoCompleteDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setDataBinding()
    }
    
    func setDataBinding() {
        viewModel.reloadData = { [weak self] in
            guard let strongSelf = self else { return }
            
            strongSelf.tableView.reloadData()
        }
    }
}

extension AutoCompleteViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell=UITableViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: "mycell")
        let row = viewModel.dataSource[indexPath.row]
        
        cell.textLabel?.text = row.name
        cell.backgroundColor = UIColor.init(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let rowSelected = viewModel.dataSource[indexPath.row]
        autoCompleteDelegate?.selectAirport(airPort: rowSelected)
    }
}

