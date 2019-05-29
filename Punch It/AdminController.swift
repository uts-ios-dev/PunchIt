//
//  AdminController.swift
//  Punch It
//
//  Created by Phan Thế Trung on 24/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import UIKit
import FirebaseDatabase
class AdminController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var datePicker: UIDatePicker?
    @IBOutlet weak var dateField: UITextField!
    
    var savedPIN:[String] = []
    var savedName:[String] = []
    var savedHours:[String] = []
    let ref = Database.database().reference()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedHours.count
    }
    
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(savedName[indexPath.row]) worked \(savedHours[indexPath.row])"
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        dateField.addTarget(self, action: #selector(textFieldDidBeginEditing), for: .editingDidBegin)
        dateField.addTarget(self, action: #selector(textFieldDidEndEditing), for: .editingDidEnd)
     
    }
    
    override func viewWillAppear(_ animated: Bool) {
        Database.database().reference().child("Users").observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchUserName()
            self.fetchWorkHours()
        })
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
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
            cell.textLabel?.text = "\(savedName[indexPath.row]) worked \(savedHours[indexPath.row])"
            return cell
        }
        
        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return savedHours.count
        }
        
        
    }
    
    @objc func textFieldDidBeginEditing(_ textField: UITextField) {
        self.savedHours.removeAll()
        self.savedName.removeAll()
        self.myTableView.reloadData()
    }
    
    @objc func textFieldDidEndEditing(_ textField: UITextField) {
        self.fetchUserName()
        self.fetchWorkHours()
        self.myTableView.reloadData()
        
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker){
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        dateField.text = dateFormatter.string(from: sender.date)
        self.view.endEditing(true)
//        self.viewWillDisappear(true)
        self.viewWillAppear(true)
       
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
    
    func fetchWorkHours(){
        for i in self.savedPIN
        {
            ref.child("Work").child(dateField.text!).child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let time = value?["Time"] as? String ?? ""
                self.savedHours.append(time)
                print(time)
            })
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
