//
//  LaunchViewController.swift
//  worldAirports
//
//  Created by Mario Acero on 9/9/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet weak var progressBar: UIProgressView!
    
    lazy var viewModel: LaunchViewModel = {
        return LaunchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDataBinding()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        viewModel.getAirportsData()
    }
    
    func setDataBinding() {
        viewModel.updateProgressBar = { [weak self] (value) in
            guard let strongSelf = self else { return }
            strongSelf.progressBar.setProgress(value, animated: true)
        }
        
        viewModel.goToSearchAirports = { [weak self] () in
            guard let strongSelf = self else { return }
            
            strongSelf.progressBar.setProgress(1.0, animated: true)
            strongSelf.performSegue(withIdentifier: "goToSearchAirport", sender: self)
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        print(segue.identifier)
    }
}
