//
//  AirPortsSearchViewController.swift
//  worldAirports
//
//  Created by Mario Acero on 9/11/18.
//  Copyright © 2018 MarioAcero. All rights reserved.
//

import UIKit

class AirPortsSearchViewController: UIViewController {
    
    @IBOutlet weak var departTextField: UITextField!
    @IBOutlet weak var arriveTextField: UITextField!
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var activity: UIActivityIndicatorView!
    
    var autocompleteview:AutoCompleteViewController!
    var textFieldToShowAutoComplete: UITextField!
    var enabledColor = UIColor(red: 32/255, green: 199/255, blue: 214/255, alpha: 1)
    var disabledColor = UIColor(red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
    
    lazy var viewModel: AirPortSearchViewModel = {
        return AirPortSearchViewModel()
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        departTextField.inputAccessoryView = addDoneButtonToolbar()
        arriveTextField.inputAccessoryView = addDoneButtonToolbar()
        activity.isHidden = true
        setDataBinding()
    }

    func setDataBinding() {
        viewModel.showAutoComplete = { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.autocompleteview == nil {
                strongSelf.autocompleteview = AutoCompleteViewController()
                strongSelf.autocompleteview.autoCompleteDelegate = self
                strongSelf.autocompleteview.viewModel.dataSource = strongSelf.viewModel.objectsToAutoComplete
            }else {
                strongSelf.autocompleteview.viewModel.dataSource = strongSelf.viewModel.objectsToAutoComplete
            }
            
            if !strongSelf.autocompleteview.isViewLoaded && !(strongSelf.autocompleteview.view.window != nil) {
                let width = strongSelf.textFieldToShowAutoComplete.frame.width
                let height = strongSelf.textFieldToShowAutoComplete.frame.height + 3
                strongSelf.autocompleteview.view.frame = CGRect(x: strongSelf.textFieldToShowAutoComplete.frame.origin.x, y: strongSelf.textFieldToShowAutoComplete.frame.origin.y + height, width: width, height: 120)
                strongSelf.view.addSubview(strongSelf.autocompleteview.view)
            }
        }
        
        viewModel.closeAutoComplete = { [weak self] in
            guard let strongSelf = self else { return }
            
            if strongSelf.autocompleteview != nil {
                strongSelf.autocompleteview.view.removeFromSuperview()
                strongSelf.autocompleteview = nil
            }
        }
        
        viewModel.isContinueButtonEnbled = { [weak self] (isEnabled) in
            guard let strongSelf = self else { return }
            
            strongSelf.continueButton.isEnabled = isEnabled
            var color = strongSelf.disabledColor
            if isEnabled {
                color = strongSelf.enabledColor
            }
            strongSelf.continueButton.backgroundColor = color
        }
        
        viewModel.showLoadingAnimated = { [weak self] (isAnimated) in
            guard let strongSelf = self else { return }
            
            strongSelf.activity.isHidden = !isAnimated
            if isAnimated {
                strongSelf.activity.startAnimating()
                return
            }
            strongSelf.activity.stopAnimating()
        }
        
        viewModel.gotToSchedule = { [weak self]  (schedules) in
            guard let strongSelf = self else { return }
            
            strongSelf.performSegue(withIdentifier: "showSchedules", sender: schedules)
        }
        
        viewModel.notSchedulesAlert = {[weak self] in
            guard let strongSelf = self else { return }
            
            let alert = UIAlertController(title: "Oooopss", message: "Looks like not there direct flights for you, try again or change your destination", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            strongSelf.present(alert, animated: true)
        }
    }
    
    // Editing Changed
    @IBAction func departEditChange(_ sender: UITextField) {
        validateTextType(sender)
    }
    
    
    @IBAction func arriveEditChange(_ sender: UITextField) {
        validateTextType(sender)
    }
    
    // End Editing
    
    @IBAction func departEndEditing(_ sender: UITextField) {
        if sender.text!.isEmpty {
            viewModel.departAirport = nil
        }else {
            sender.text = viewModel.departAirport?.name
        }
    }
    
    @IBAction func arriveDidEndEditing(_ sender: UITextField) {
        if sender.text!.isEmpty {
            viewModel.arriveAirport = nil
        }else {
            sender.text = viewModel.arriveAirport?.name
        }
    }
    
    
    @IBAction func continueAction(_ sender: UIButton) {
        viewModel.getSchedules()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showSchedules" {
            let controller: SchedulesViewController = segue.destination as! SchedulesViewController
            if let schedules = sender as? SchedulesList {
                controller.viewModel.dataSource = schedules
                controller.viewModel.departAirport = viewModel.departAirport
                controller.viewModel.arrivalAirport = viewModel.arriveAirport
            }
        }
        
        let backItem = UIBarButtonItem()
        backItem.title = "Back"
        navigationItem.backBarButtonItem = backItem
    }
    
    private func validateTextType(_ sender: UITextField) {
        if let text = sender.text, text.count > 2 {
            textFieldToShowAutoComplete = sender
            viewModel.getDataSourceAutoComplete(textToSearch: text)
        }
    }
    
    private  func addDoneButtonToolbar()-> UIToolbar {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(AirPortsSearchViewController.donePressed))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        return keyboardToolbar
    }
    
    @objc private func donePressed() {
        self.view.endEditing(true)
        viewModel.closeAutoComplete?()
    }
}

extension AirPortsSearchViewController: AutoCompleteDelegate {
    
    func selectAirport(airPort: AirportsRealm) {
        textFieldToShowAutoComplete.resignFirstResponder()
        textFieldToShowAutoComplete.text = airPort.name
        viewModel.closeAutoComplete?()
        
        if textFieldToShowAutoComplete == departTextField {
            viewModel.departAirport = airPort
            return
        }
        viewModel.arriveAirport = airPort
    }
}
