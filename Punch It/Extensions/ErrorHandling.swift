//
//  ErrorHandling.swift
//  Punch It
//
//  Created by Phan Thế Trung on 1/6/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import Foundation
import UIKit
class validatedForm {
    let validator = formValidation()
    func validateForm(_ label: UILabel, _ phoneTextField: String, _ pinTextField: String, _ roleTextField: String,_ nameTextField: String,_ addressTextField: String) -> Bool{
        do{
            try validator.otherInfoValid(roleTextField)
            try validator.otherInfoValid(nameTextField)
            try validator.otherInfoValid(addressTextField)
            try validator.phoneNumValid(phoneTextField)
            try validator.pinNumValid(pinTextField)
        }catch validationError.missingInput{
            label.text = "Please fill in all field"
            return false
        }
        catch validationError.invalidPhoneNumFormat{
            label.text = "Invalid phone number format. Please enter number only"
            return false
        }
        catch{
            label.text = "Invalid PIN format. Please enter number only"
            return false
        }
        return true 
    }
}
