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
    var savedPIN:[String] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedPIN.count
    }
    
    @IBOutlet weak var myTableView: UITableView!
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
         cell.textLabel?.text = savedPIN[indexPath.row]
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
            let savedData = Array(ID.values)
            print(savedData)
        })
//        Database.database().reference().child("Users").observe(.value, with: {(snapshot) in
//            let name  = snapshot.value as? [String: AnyObject] ?? [:]
////            self.savedPIN = Array(name.keys)
//            let value = snapshot.value as? NSDictionary
//            let username = name["Name"] as? String ?? ""
//            print(username)
////            print("ad")
//        })
        
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
