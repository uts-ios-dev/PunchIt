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
    let formatterDay = DateFormatter()
    var loginDate: String = ""
    var loginTime: String = ""
    var savedPIN:[String] = []
    var savedName:[String] = []
    var savedManage = "1111"
    var getName: String!
    var hours: Int = 0
    var minutes: Int = 0
    var loginHour: Int = 0
    var loginMinutes: Int = 0

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
    
    func dateFormatter(_ : Date){
        formatterDay.dateFormat = "dd-MM-yyyyHH:mm"
        let nowDay  = formatterDay.string(from: Date())
        let index = nowDay.index(nowDay.startIndex, offsetBy: 10)
        let endIndex = nowDay.index(nowDay.endIndex, offsetBy: -5)
        self.loginDate = String(nowDay[..<index])
        self.loginTime = String(nowDay[endIndex...])
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
    func calculateWork(_ time: String){
        let index = time.index(time.startIndex, offsetBy: 2)
        let endIndex = time.index(time.endIndex, offsetBy: -2)
        self.hours = (String(time[..<index]) as NSString).integerValue
        self.minutes = (String(time[endIndex...]) as NSString).integerValue
    
    }
    func calculateWorkingHours(_ time: String){
        let index = time.index(time.startIndex, offsetBy: 2)
        let endIndex = time.index(time.endIndex, offsetBy: -2)
        self.loginHour = (String(time[..<index]) as NSString).integerValue
        self.loginMinutes = (String(time[endIndex...]) as NSString).integerValue
    }
    
    @IBOutlet weak var pinField: UITextField!
    @IBAction func confirmTapped(_ sender: Any) {
        if pinField.text! == "1111" {
            performSegue(withIdentifier: "manageSegue", sender: nil)
        }
        for (key, value) in self.savedPIN.enumerated(){
            self.dictionary[value] = self.savedName[key]
        }
        for i in savedPIN{
            if i == pinField.text!{
                getName = dictionary[pinField.text!]
                ref.child("LiveShift").child(pinField.text!).setValue(["Working": getName])
                dateFormatter(Date())
                ref.child("AccessLog").child("Login").child(pinField.text!).child(loginDate).setValue(["Time": loginTime])
                performSegue(withIdentifier: "confirm", sender: nil)
            }
        }
    }
    @IBAction func stopButton(_ sender: Any) {
        for i in savedPIN{
            if i == pinField.text!{
                ref.child("LiveShift").child(pinField.text!).removeValue()
                dateFormatter(Date())
            ref.child("AccessLog").child("Logout").child(pinField.text!).child(loginDate).setValue(["Time": loginTime])
            ref.child("AccessLog").child("Login").child(pinField.text!).child(loginDate).observe(DataEventType.value, with: {(snapshot) in
                    let value  = snapshot.value as? [String: AnyObject] ?? [:]
                    let getLoginTime = value["Time"] as? String ?? ""
                    self.calculateWorkingHours(getLoginTime)
                    self.calculateWork(self.loginTime)
                    let workingHour = self.hours - self.loginHour
                    let workingMinutes = abs(self.minutes - self.loginMinutes)
            self.ref.child("Work").child(self.pinField.text!).setValue(["Time": "\(workingHour)h \(workingMinutes)min"])
                })
                performSegue(withIdentifier: "confirm", sender: nil)
            }
            
    }
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
