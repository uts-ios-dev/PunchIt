//
//  ErrorHandling.swift
//  Punch It
//
//  Created by Phan Thế Trung on 1/6/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import Foundation
class formValidation {
    func phoneNumValid(_ phoneNum: String) throws {
        guard Int(phoneNum) != nil else{
            throw validationError.invalidPhoneNumFormat
        }
        guard phoneNum != "" else{
            throw validationError.missingInput
        }
    }
    func pinNumValid(_ pinNum: String) throws {
        guard Int(pinNum) != nil else{
            throw validationError.invalidPINFormat
        }
        guard pinNum != "" else{
            throw validationError.missingInput
        }
    }
    func otherInfoValid(_ text: String) throws {
        guard text != "" else{
            throw validationError.missingInput
        }
    }
    
}
