//
//  defaultValues.swift
//  ProjectLLC
//
//  Created by Pike on 4/13/18.
//  Copyright © 2018 Minh. All rights reserved.
//

import Foundation
import UIKit

struct defaultVariables
{
    // Gray color #5e6a71.
    static var backgroundColor = UIColor(hex: 0x5e6a71, alpha: 1)
    // Default logo.
    static var appLogoImage = UIImage(named: "appLogo")
    // Drop down view background color.
    static var dropDownBackgroundColor = UIColor.clear
    // Drop down view cell background color.
    static var dropDownCellBackgroundColor = UIColor.clear
    // Supported language
    static var supportedLanguages = ["English","Tiếng Việt","Frances","中文"]
    // Default cell width (dropdown)
    static var cellWidthDropdown = 50
    // Default cell size (dropdown)
    static var cellHeightDropdown = 50
    // Drop down menu number of item
    static var numberOfDropDownItem = 3
    // loginView content offset when editing the textfields inside the loginview
    static var offsetWhenEditingTextfieldInLoginView = 20
    // registerview content offset when editing the textfields inside the registerview
    static var offsetWhenEditingTextfieldInRegisterView = 12
    // registerview content offset when editing the textfields inside the registerview Landscape
    static var offsetWhenEditingTextfieldInRegisterViewLandscape = 14
    
    // Supported user
    static var supporteduser = ["User1","User2"]
    
    
    /* Eror messeage */
    // (missing email)
    static var missingEmail = "Missing Email!"
    // (missing password)
    static var missingPassword = "Mising Password!"
    // (missing firstname)
    static var missingFirstname = "Mising Firstname!"
    // (missing lastname)
    static var missingLastname = "Mising Lastname!"
    // (missing retype password)
    static var missingRetypePassword = "Mising Retype Password!"
    // (passwords are not matched!)
    static var passwordNotMatched = "Password Fields are not matched!"
    // (Failed to Login)
    static var failedToLogin = "Failed to login!"
    
    
    
    
    
}
