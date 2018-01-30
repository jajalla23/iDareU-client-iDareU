//
//  SignupFormValidationModel.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/22/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

struct SignupFormValidationModel {
    
    // MARK:- VARIABLES
    var userName: String?
    var password: String?
    var email: String?
    
    
    //MARK:- CONSTRUCTORS
    
    init(userEmail: String?, userName: String, userPassword: String) {
        self.email = userEmail
        self.userName = userName
        self.password = userPassword
    }
}
