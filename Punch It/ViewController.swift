//
//  ViewController.swift
//  Punch It
//
//  Created by Harry Ta on 21/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseUI
class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var savedName:[String] = []
    var savedPIN:[String] = []
    @IBOutlet weak var myTableView: UITableView!
    
    
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath){
            myTableView.reloadData()
            performSegue(withIdentifier: SegueName.stop.rawValue, sender: nil)
        }

    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = "\(savedName[indexPath.row]) is now working"
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child(pathName.liveShift.rawValue).observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchUserName()
        })
        
    }
    
    //Fetch the user's name
    func fetchUserName(){
        for i in self.savedPIN{
            let ref = Database.database().reference()
            ref.child(pathName.users.rawValue).child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?[pathName.name.rawValue] as? String ?? ""
                self.savedName.append(name)
            })
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        //dispose any recources that can be recreated
    }


}

