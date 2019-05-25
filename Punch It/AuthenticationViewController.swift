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
    var dictionary:[String:String] = [:]
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child("Users").observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchUserName()
        })
    }
    
    
    func fetchUserName(){
        for i in self.savedPIN{
            ref.child("Users").child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["Name"] as? String ?? ""
                self.savedName.append(name)
        })
        }
    }
    //    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    //        if segue.identifier == "confirm"
    //        {
    //            let tabBar = segue.destination as! TabBarController
    //            let destinationVC = tabBar.viewControllers![0] as! ViewController
    //                //            destinationVC.name.append(getName)
    //            let staff = Staff(self.pinField.text!, getName)
    //            destinationVC.staff.append(staff)
    //        }
    //    }
    @IBOutlet weak var pinField: UITextField!
    @IBAction func confirmTapped(_ sender: Any) {
        if pinField.text! == "1111" {
            performSegue(withIdentifier: "manageSegue", sender: nil)
        }
        
        for (key, value) in self.savedPIN.enumerated(){
            self.dictionary[value] = self.savedName[key]
        }
        for i in savedPIN{
            if i == pinField.text!
            {
                getName = dictionary[pinField.text!]
                let newShift = Staff(self.pinField.text!, getName)
                self.staff.append(newShift)
            }
              
            }
            
        print(staff.count)
       
        print(self.savedPIN)
        print(self.savedName)
        
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
