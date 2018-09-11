//
//  AutoCompleteViewController.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit

class AutoCompleteViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    lazy var viewModel: AutoCompleteViewModel = {
        return AutoCompleteViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        
    }

    

}

extension AutoCompleteViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        <#code#>
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
}

