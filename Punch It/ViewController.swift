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
    var name:[String] = []
    var staff: [Staff] = []
    var modelName = Model()
    @IBOutlet weak var myTableView: UITableView!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "endShift"{
//            let destination = segue.destination as! AuthenticationViewController
//            destination.screenLabel.text = "End Shift"
        }
    }
    public func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete
        {
            self.name.remove(at: indexPath.row)
            performSegue(withIdentifier: "endShift", sender: nil)
            myTableView.reloadData()
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        myTableView.reloadData()
       
    }
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return name.count
    }
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
        cell.textLabel?.text = name[indexPath.row]
        return cell
    }
    override func viewDidLoad() {
        super.viewDidLoad()
       let ref = Database.database().reference()
//       ref.child("Users").child("13456").setValue(["name": "Trung"])
       print(staff.count)
      
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
     
        //dispose any recources that can be recreated
    }


}

