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
    
    @IBOutlet weak var datePicker: UIDatePicker!

    
    
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
        cell.textLabel?.text = "\(savedName[indexPath.row])     \(savedHours[indexPath.row])"
        return cell
    }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Users").observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchUserName()
            self.fetchWorkHours()
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
    
    func fetchWorkHours(){
        for i in self.savedPIN
        {
            ref.child("Work").child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
//                for j in self.savedName{
                let time = value?["Time"] as? String ?? ""
//                    if time != ""{
                self.savedHours.append(time)
//                }
//                }
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
