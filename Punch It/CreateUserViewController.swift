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
    var backToManageTask: Bool = false;
 
    @IBOutlet weak var helperText: UILabel!
    
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
        helperText.text = "Please fill in all the field"
    if (phoneNumber.text! != "" && address.text! != "" && initialPIN.text! != "" && staffName.text! != "" && role.text! != "" ){
        let user = ["Name": staffName.text!,
                    "Address": address.text!,
                    "PhoneNumber": phoneNumber.text!,
                    "Role": role.text!]
        Database.database().reference().child(pathName.users.rawValue).child(initialPIN.text!).setValue(user)
        performSegue(withIdentifier: SegueName.success.rawValue, sender: nil)
    }
   
}


}
