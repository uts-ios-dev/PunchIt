//
//  ValidationError.swift
//  Punch It
//
//  Created by Phan Thế Trung on 1/6/19.
//  Copyright © 2019 Harry Ta. All rights reserved.
//

import Foundation
enum validationError: Error{
    case invalidPhoneNumFormat
    case invalidPINFormat
    case missingInput
}
