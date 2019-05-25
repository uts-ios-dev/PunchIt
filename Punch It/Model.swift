//
//  Model.swift
//  Punch It
//
//  Created by Phan Thế Trung on 21/5/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import Foundation

class Model
{
    var modelName : String = ""
    func setName(_ name: String)
    {
        self.modelName = name;
    }
    func getName() -> String
    {
        return modelName
    }
}
