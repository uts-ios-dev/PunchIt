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
    var adminPIN: [String]  = []
    var getName: String!
    var endHours: Int = 0
    var endMinutes: Int = 0
    var loginHour: Int = 0
    var loginMinutes: Int = 0
    let ref = Database.database().reference()
    var dictionary:[String:String] = [:]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref.child(pathName.users.rawValue).observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchUserName()
        })
        fetchManagerPIN()
    }
    //Date formatter to convert Date to String
    func dateFormatter(_ : Date){
        formatterDay.dateFormat = dateFormatEnum.dateAndTime.rawValue
        let nowDay  = formatterDay.string(from: Date())
        let index = nowDay.index(nowDay.startIndex, offsetBy: 10)
        let endIndex = nowDay.index(nowDay.endIndex, offsetBy: -5)
        self.currentDate = String(nowDay[..<index])
        self.currentTime = String(nowDay[endIndex...])
    }
    func fetchManagerPIN(){
        ref.child(pathName.admin.rawValue).observe(DataEventType.value, with: {(snapshot) in
            let manageID = snapshot.value as? [String:AnyObject] ?? [:]
            self.adminPIN = Array(manageID.keys)
            print(self.adminPIN)
        })
    }
    
    //Fetech the user's name from Firebase
    func fetchUserName(){
        for i in self.savedPIN{
            ref.child(pathName.users.rawValue).child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?[pathName.name.rawValue] as? String ?? ""
                self.savedName.append(name)
        })
        }
    }
    //Parse the end time to calculate work hour
    func parseIntEndTime(_ time: String){
        let index = time.index(time.startIndex, offsetBy: 2)
        let endIndex = time.index(time.endIndex, offsetBy: -2)
        self.endHours = (String(time[..<index]) as NSString).integerValue
        self.endMinutes = (String(time[endIndex...]) as NSString).integerValue
    }
    
    //Parse the login time to calculate work hour
    func parseIntLoginTime(_ time: String){
        let index = time.index(time.startIndex, offsetBy: 2)
        let endIndex = time.index(time.endIndex, offsetBy: -2)
        self.loginHour = (String(time[..<index]) as NSString).integerValue
        self.loginMinutes = (String(time[endIndex...]) as NSString).integerValue
        
    }
    
    //Perform validation for the control the login
    @IBOutlet weak var pinField: UITextField!
    fileprivate func validation() {
        getName = dictionary[pinField.text!]
        ref.child(pathName.liveShift.rawValue).child(pinField.text!).setValue(["Working": getName])
        dateFormatter(Date())
    ref.child(pathName.accessLog.rawValue).child(pathName.login.rawValue).child(pinField.text!).child(currentDate).setValue([pathName.time.rawValue: currentTime])
    }
    
    @IBAction func confirmTapped(_ sender: Any) {
        //Check if the user logged as admin
        for pin in adminPIN {
        if pinField.text! == pin {
            performSegue(withIdentifier: SegueName.toManageTask.rawValue, sender: nil)
        }
        }
        //Mapping name and the ID of the logged user
        for (key, value) in self.savedPIN.enumerated(){
            self.dictionary[value] = self.savedName[key]
        }
        //Check if user logged as staff
        for i in savedPIN{
            if i == pinField.text!{
                validation()
                performSegue(withIdentifier: SegueName.confirm.rawValue, sender: nil)
            }
    }
}
    //Calculate work hour based on the end time and the current time
    fileprivate func calculateWorkHour() {
        ref.child(pathName.liveShift.rawValue).child(pinField.text!).removeValue()
        dateFormatter(Date())
    ref.child(pathName.accessLog.rawValue).child(pathName.logOut.rawValue).child(pinField.text!).child(currentDate).setValue([pathName.time.rawValue: currentTime])
    ref.child(pathName.accessLog.rawValue).child(pathName.login.rawValue).child(pinField.text!).child(currentDate).observe(DataEventType.value, with: {(snapshot) in
            let value  = snapshot.value as? [String: AnyObject] ?? [:]
            let getLoginTime = value[pathName.time.rawValue] as? String ?? ""
            self.parseIntLoginTime(getLoginTime)
            self.parseIntEndTime(self.currentTime)
            let workingHour = self.endHours - self.loginHour
            let workingMinutes = abs(self.endMinutes - self.loginMinutes)
self.ref.child(pathName.work.rawValue).child(self.currentDate).child(self.pinField.text!).setValue([pathName.time.rawValue: "\(workingHour)h \(workingMinutes)min"])
        })
    }
    
    //Function to end shift
    @IBAction func stopButton(_ sender: Any) {
        for i in savedPIN{
            if i == pinField.text!{
                calculateWorkHour()
                performSegue(withIdentifier: SegueName.confirm.rawValue, sender: nil)
            }
            
    }
}
    
}
