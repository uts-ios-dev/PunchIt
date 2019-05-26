//
//  Staff.swift
//  Punch It
//
//  Created by Phan Thế Trung on 21/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import Foundation
class Staff{
    var name: String
    var ID: String
    var counter = 0
    var timer = Timer()
    init (_ ID: String, _ name: String){
        self.ID = ID
        self.name = name
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(increment), userInfo: nil, repeats: true)
        print("Staff \(name) is \(counter)")
    }
    @objc func increment(){
        print("Staff \(name) \(counter)")
        counter += 1
    }
    func stop(){
        timer.invalidate();
    }
    func getCounter() -> Int {
        return counter
    }
}
