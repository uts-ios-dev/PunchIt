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

        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
//            if (savedHours[indexPath.row] != ""){
         
            cell.textLabel?.text = "\(savedName[indexPath.row]) \(savedHours[indexPath.row])"
//            cell.textLabel?.text = "\(savedHours[indexPath.row]) "
            return cell
//            }
//            cell.textLabel?.text = "\(savedName[indexPath.row]) has not worked"
//            return cell
        }
    
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
        }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Database.database().reference().child("Users").observe(.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchWorkHours()
            self.fetchUserName()
        })
        dateLabel.text = date
}
    
    func fetchUserName(){
        for i in self.savedPIN{
           Database.database().reference().child("Users").child(i).observeSingleEvent(of: .value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["Name"] as? String ?? ""
                self.savedName.append(name)
                print(self.savedName)
            })
        }
    }

    func fetchWorkHours(){
        for i in self.savedPIN
        {
            Database.database().reference().child("Work").child(date).child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let time = value?["Time"] as? String ?? ""
                self.savedHours.append(time)
               print(self.savedHours)
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
