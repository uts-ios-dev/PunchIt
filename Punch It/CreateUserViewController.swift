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
 
   
    override func viewDidLoad() {
        super.viewDidLoad()

//         Do any additional setup after loading the view.
    }
    @IBAction func backButtonTapped(_ sender: Any) {
        if backToManageTask == true {
            performSegue(withIdentifier: "backManageTask", sender: nil)
        }
        performSegue(withIdentifier: "backShiftView", sender: nil)
    }
    @IBAction func okay(_ sender: Any) {
    if (phoneNumber.text! != "" && address.text! != "" && initialPIN.text! != "" && staffName.text! != "" && role.text! != "" ){
        let user = ["Name": staffName.text!,
                    "Address": address.text!,
                    "PhoneNumber": phoneNumber.text!,
                    "Role": role.text!]
        Database.database().reference().child("Users").child(initialPIN.text!).setValue(user)
    }
}
//    @IBAction func addStaff(_ sender: Any) {
//
//            performSegue(withIdentifier: "success", sender: nil)
//        }
//
//}
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
