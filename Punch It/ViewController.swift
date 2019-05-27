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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "endShift"{
////            let destination = segue.destination as! AuthenticationViewController
////            destination.screenLabel.text = "End Shift"
//        }
//    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            myTableView.reloadData()
            performSegue(withIdentifier: "endShift", sender: nil)
        }

    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return savedName.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = savedName[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let ref = Database.database().reference()
        ref.child("LiveShift").observe(DataEventType.value, with: {(snapshot) in
            let ID  = snapshot.value as? [String: AnyObject] ?? [:]
            self.savedPIN = Array(ID.keys)
            self.fetchUserName()
        })
        
//       ref.child("Users").child("13456").setValue(["name": "Trung"])
       
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    func fetchUserName(){
        for i in self.savedPIN{
            let ref = Database.database().reference()
            ref.child("Users").child(i).observeSingleEvent(of: DataEventType.value, with: {(snapshot) in
                let value = snapshot.value as? NSDictionary
                let name = value?["Name"] as? String ?? ""
                self.savedName.append(name)
            })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        //dispose any recources that can be recreated
    }


}

