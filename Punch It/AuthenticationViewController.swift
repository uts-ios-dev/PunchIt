//
//  AuthenticationViewController.swift
//  Punch It
//
//  Created by Harry Ta on 21/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import UIKit
import FirebaseUI
import FirebaseDatabase
class AuthenticationViewController: UIViewController {
    //    @IBOutlet weak var label: UILabel!
//    @IBOutlet weak var screenLabel: UILabel!
    var savedPIN:[String] = []
    var savedName:[String] = []
    var savedManage = "1111"
    var getName: String!
    let ref = Database.database().reference()
    var model = Model()
    var staff: [Staff] = []
    var dictionary = ["13009": "Trung", "13457": "Minh", "13478": "Harry"]
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Users").observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
        })
       
        
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "confirm"
    //        {
    //            let tabBar = segue.destination as! TabBarController
    //            let destinationVC = tabBar.viewControllers![0] as! ViewController
    //            getName = dictionary[pinField.text!]
    //            destinationVC.name.append(getName)
    //            let staff = Staff(self.pinField.text!, getName)
    //            destinationVC.staff.append(staff)
    //        }
    //    }
    @IBOutlet weak var pinField: UITextField!
    @IBAction func confirmTapped(_ sender: Any) {
        if pinField.text! == "1111" {
            performSegue(withIdentifier: "manageSegue", sender: nil)
        }
        for i in savedPIN{
            if i == pinField.text!
            {
                performSegue(withIdentifier: "confirm", sender: nil)
                ref.child("Users").child(pinField.text!).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                    //                let name = snapshot.value as? [String: String]
                    let value = snapshot.value as? NSDictionary
                    let name = value?["Name"] as? String ?? ""
                    //                let tabBar = TabBarController()
                    let newShift = Staff(self.pinField.text!, name)
                    self.staff.append(newShift)
                    //                let homeVC = tabBar.viewControllers![0] as! ViewController
                    //                tabBar.staff.append(staff)
                    //                print("inside  \(self.savedName)")
                    
                })
            }
            
        }
        //       print(self.savedPIN)
        print("outside  \(self.savedName)")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
