//
//  ManageTaskViewController.swift
//  Punch It
//
//  Created by Phan Thế Trung on 29/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import UIKit

class ManageTaskViewController: UIViewController {
    var datePicker: UIDatePicker?
    @IBOutlet weak var dateField: UITextField!
    
    //Create date picker for the keyboard
    fileprivate func addDatePickerKeyboard() {
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateField.inputView = datePicker
        datePicker?.resignFirstResponder()
        if dateField.text == stringCompare.blank.rawValue{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = dateFormatEnum.dateOnly.rawValue
            dateField.text = dateFormatter.string(from: Date())
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addDatePickerKeyboard()
    }
    
    //Perform segue to addStaff scene
    @IBAction func addStaffTapped(_ sender: Any) {
         performSegue(withIdentifier: SegueName.toCreateStaff.rawValue, sender: nil)
    }

    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormatEnum.dateOnly.rawValue
        dateField.text = dateFormatter.string(from: sender.date)
        self.view.endEditing(true)
        self.viewWillAppear(true)
    }
    
    //Perform preparation for each segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueName.toViewStaff.rawValue{
            let destination = segue.destination as! AdminController
            destination.date = dateField.text!
        }
        if segue.identifier == SegueName.toCreateStaff.rawValue{
            let landing = segue.destination as! CreateUserViewController
            landing.backToManageTask = true
    }
        
}
    
    @IBAction func viewTapped(_ sender: Any) {
        performSegue(withIdentifier: SegueName.toViewStaff.rawValue, sender: nil)
    }
    
}
