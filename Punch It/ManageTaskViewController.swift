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
    override func viewDidLoad() {
        super.viewDidLoad()
        datePicker = UIDatePicker()
        datePicker?.datePickerMode = .date
        datePicker?.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        dateField.inputView = datePicker
        datePicker?.resignFirstResponder()
        if dateField.text == ""{
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-MM-yyyy"
            dateField.text = dateFormatter.string(from: Date())
        }
        // Do any additional setup after loading the view.
    }
    @IBAction func addStaffTapped(_ sender: Any) {
         performSegue(withIdentifier: "createStaff", sender: nil)
    }

    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateField.text = dateFormatter.string(from: sender.date)
        self.view.endEditing(true)
        self.viewWillAppear(true)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewStaffSegue"{
            let destination = segue.destination as! AdminController
            destination.date = dateField.text!
        }
        if segue.identifier == "createStaff"{
            let landing = segue.destination as! CreateUserViewController
            landing.backToManageTask = true
    }
    }
    
   
    @IBAction func viewTapped(_ sender: Any) {
        performSegue(withIdentifier: "viewStaffSegue", sender: nil)
    }
    
}
