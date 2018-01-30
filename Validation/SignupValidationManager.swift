//
//  ValidationManager.swift
//  iDareU
//
//  Created by Jan Jajalla on 1/22/18.
//  Copyright © 2018 Jan Jajalla. All rights reserved.
//

import Foundation

class SignupValidationManager {
    static private let regexEmail = "[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}"
    //static private let regexMobNo = "^[0-9]{6,15}$"
    static private let regexNameType = "^[a-zA-Z]+$"
    
    
    static func validateForm(signUpModel: SignupFormValidationModel) -> ValidationError? {
        
        var validationError: ValidationError? = nil
        validationError = validateEmailId(email: signUpModel.email!)
        if validationError != nil {
            
            return validationError
        }
        
        validationError = validateNameString(string: signUpModel.userName!)
        if validationError != nil {
            
            return validationError
        }
        
        /*
         validationError = validateMobileNumber(string: signUpModel.mobileNo!)
         if validationError != nil {
         
         return validationError
         }
         */
        
        return validationError
    }
    
    //MARK: validate emailID
    
    static private func validateEmailId(email: String) -> ValidationError?
    {
        var validationError : ValidationError? = nil
        
        if email == ""
        {
            validationError = ValidationError(code: ValidationError.ErrorCodes.errorCodeEmptyText, message: ValidationError.ErrorMessages.msgEmptyEmail)
        }
        else {
            let emailTest = NSPredicate(format: "%@%.com", regexEmail)
            let matchEmailId = emailTest.evaluate(with: email)
            if(!matchEmailId)
            {
                validationError = ValidationError(code: ValidationError.ErrorCodes.errorCodeInvalidEmail, message: ValidationError.ErrorMessages.msgInvalidEmail)
            }
        }
        return validationError
    }
    
    //MARK: validate Mobile number
    /*
     private static func validateMobileNumber(string: String) -> ValidationError?
     {
     var validationError : ValidationError? = nil
     if string == "" {
     validationError = ValidationError(code: ValidationError.ErrorCodes.errorCodeEmptyText, message: ValidationError.ErrorMessages.msgEmptyMobileNo)
     }
     else {
     
     let mobileNoTest = NSPredicate(format: stringSelfMatch, regexMobNo)
     let matchMobileNumber = mobileNoTest.evaluate(with: string)
     if(!matchMobileNumber)
     {
     validationError = ValidationError(code: ValidationError.ErrorCodes.errorCodeInvalidMobileNo, message: ValidationError.ErrorMessages.msgInvalidMobileNo)
     }
     }
     return validationError
     }
     */
    
    //MARK: validate name
    
    static private func validateNameString(string: String) -> ValidationError?
    {
        var validationError : ValidationError? = nil
        if string == "" {
            validationError = ValidationError(code: ValidationError.ErrorCodes.errorCodeEmptyText, message: ValidationError.ErrorMessages.msgEmptyName)
        }
        else {
            
            let nameTest = NSPredicate(format: "%", regexNameType)
            let matchNameType = nameTest.evaluate(with: string)
            if !matchNameType
            {
                validationError = ValidationError(code: ValidationError.ErrorCodes.errorCodeInvalidName, message: ValidationError.ErrorMessages.msgInvalidName)
            }
        }
        return validationError
    }
}
