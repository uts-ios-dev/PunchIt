//
//  AdminController.swift
//  Punch It
//
//  Created by Phan Thế Trung on 30/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseUI

class AdminController: UIViewController, UITableViewDataSource, UITableViewDelegate {
  
    var savedName = [String]()
    var savedPIN = [String]()
    var savedHours = [String]()
    var date: String = ""
    @IBOutlet weak var myTableView: UITableView!
    @IBOutlet weak var dateLabel: UILabel!
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return savedName.count
        }

    //Print data to the table 
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.value1, reuseIdentifier: "cell")
            cell.textLabel?.font = UIFont(name: fontName.arial.rawValue, size: fontSize.medium.rawValue)
            cell.detailTextLabel?.font = UIFont(name: fontName.arial.rawValue, size: fontSize.medium.rawValue)
        if (savedHours[indexPath.row] != ""){
            cell.textLabel?.text = "\(savedName[indexPath.row])"
            cell.detailTextLabel?.text = "has worked \(savedHours[indexPath.row])"
            return cell
            }
            cell.textLabel?.text = "\(savedName[indexPath.row])"
            cell.detailTextLabel?.text = "has not worked"
            return cell
        }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child(pathName.users.rawValue).observe(.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchWorkHours()
            self.fetchUserName()
        })
        dateLabel.text = date
}
    //Fetch the user's name from databse
    func fetchUserName(){
        for i in self.savedPIN{
           Database.database().reference().child(pathName.users.rawValue).child(i).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?[pathName.name.rawValue] as? String ?? ""
                self.savedName.append(name)
            })
        }
    }
    
    //Fetch the work's hour from Firebase
    func fetchWorkHours(){
        for i in self.savedPIN{
            Database.database().reference().child(pathName.work.rawValue).child(date).child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let time = value?[pathName.time.rawValue] as? String ?? ""
                self.savedHours.append(time)
            })
        }
    }
}
