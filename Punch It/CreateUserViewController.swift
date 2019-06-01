//
//  CreateUserViewController.swift
//  Punch It
//
//  Created by Phan Thế Trung on 24/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import UIKit
import FirebaseDatabase
class CreateUserViewController: UIViewController {
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var initialPIN: UITextField!
    @IBOutlet weak var staffName: UITextField!
    @IBOutlet weak var role: UITextField!
    @IBOutlet weak var helperText: UILabel!
    @IBOutlet weak var createButton: UIButton!
    var backToManageTask: Bool = false
    let form = validatedForm()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    //Function to control the back button
    @IBAction func backButtonTapped(_ sender: Any) {
        if backToManageTask == true {
            performSegue(withIdentifier: SegueName.backManageTask.rawValue, sender: nil)
        }
        performSegue(withIdentifier: SegueName.toShiftView.rawValue, sender: nil)
    }
    
    //Function to create new user
    @IBAction func okay(_ sender: Any) {
    //Perform validation for the form before adding new user 
    if (form.validateForm(helperText, phoneNumber.text!, initialPIN.text!, role.text!, staffName.text!, address.text!)){
        let user = [pathName.name.rawValue: staffName.text!,
                    pathName.address.rawValue: address.text!,
                    pathName.phone.rawValue: phoneNumber.text!,
                    pathName.role.rawValue: role.text!]
        Database.database().reference().child(pathName.users.rawValue).child(initialPIN.text!).setValue(user)
        performSegue(withIdentifier: SegueName.success.rawValue, sender: nil)
    }
}
}
