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
    var currentDate: String = ""
    var currentTime: String = ""
    var savedPIN:[String] = []
    var savedName:[String] = []
    var savedManage = "1111"
    var getName: String!
    var endHours: Int = 0
    var endMinutes: Int = 0
    var loginHour: Int = 0
    var loginMinutes: Int = 0

    let ref = Database.database().reference()
  
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
        self.currentDate = String(nowDay[..<index])
        self.currentTime = String(nowDay[endIndex...])
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
    func parseIntEndTime(_ time: String){
        let index = time.index(time.startIndex, offsetBy: 2)
        let endIndex = time.index(time.endIndex, offsetBy: -2)
        self.endHours = (String(time[..<index]) as NSString).integerValue
        self.endMinutes = (String(time[endIndex...]) as NSString).integerValue
    }
    
    func parseIntLoginTime(_ time: String){
        let index = time.index(time.startIndex, offsetBy: 2)
        let endIndex = time.index(time.endIndex, offsetBy: -2)
        self.loginHour = (String(time[..<index]) as NSString).integerValue
        self.loginMinutes = (String(time[endIndex...]) as NSString).integerValue
    }
    
    @IBOutlet weak var pinField: UITextField!
    fileprivate func validation() {
        getName = dictionary[pinField.text!]
        ref.child("LiveShift").child(pinField.text!).setValue(["Working": getName])
        dateFormatter(Date())
        ref.child("AccessLog").child("Login").child(pinField.text!).child(currentDate).setValue(["Time": currentTime])
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        if pinField.text! == "1111" {
            performSegue(withIdentifier: SegueName.toManageTask.rawValue, sender: nil)
        }
        for (key, value) in self.savedPIN.enumerated(){
            self.dictionary[value] = self.savedName[key]
        }
        for i in savedPIN{
            if i == pinField.text!{
                validation()
                performSegue(withIdentifier: SegueName.confirm.rawValue, sender: nil)
            }
        }
        pinField.placeholder = "Incorrect PIN"
    }
    
    fileprivate func calculateWorkHour() {
        ref.child("LiveShift").child(pinField.text!).removeValue()
        dateFormatter(Date())
        ref.child("AccessLog").child("Logout").child(pinField.text!).child(currentDate).setValue(["Time": currentTime])
        ref.child("AccessLog").child("Login").child(pinField.text!).child(currentDate).observe(DataEventType.value, with: {(snapshot) in
            let value  = snapshot.value as? [String: AnyObject] ?? [:]
            let getLoginTime = value["Time"] as? String ?? ""
            self.parseIntLoginTime(getLoginTime)
            self.parseIntEndTime(self.currentTime)
            let workingHour = self.endHours - self.loginHour
            let workingMinutes = abs(self.endMinutes - self.loginMinutes)
            self.ref.child("Work").child(self.currentDate).child(self.pinField.text!).setValue(["Time": "\(workingHour)h \(workingMinutes)min"])
        })
    }
    
    @IBAction func stopButton(_ sender: Any) {
        for i in savedPIN{
            if i == pinField.text!{
                calculateWorkHour()
                performSegue(withIdentifier: SegueName.confirm.rawValue, sender: nil)
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
