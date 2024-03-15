//
//  AppError.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

/// List of API errors.
///
/// Call example for serverErr:
/// - 'let errorMess = AppError.serverErr.title' + " " + AppError.serverErr.message'

enum AppError: Error {

    case serverErr
    case invalidUrl
    case badStatusCode
    case invalidJson
    case emptyTextField
    case invalidMail
    case badPwdConfirm
    case emailAlreadyExist
    case linkedInUrlEmpty
    case invalidLinkedInUrl
    case unknown

    // MARK: Message Builder

    var message: String {

        switch self {
        case .serverErr:
            print("AppError: serverErr")
            return "Our server is currently unavailable."
        case .invalidUrl:
            print("AppError: invalidUrl")
            return "Our server is currently unavailable."
        case .badStatusCode:
            print("AppError: badStatusCode")
            return "Our server is currently unavailable."
        case .invalidJson:
            print("AppError: invalidJson")
            return "Our server is currently unavailable."
        case .emptyTextField:
            return "Please complete all fields."
        case .invalidMail:
            return "Email is invalid! Change your email and try again."
        case .badPwdConfirm:
            return "The entered password is not the same as the password confirmation."
        case .emailAlreadyExist:
            return "Email already exists, log in with this email or use another email to register."
        case .linkedInUrlEmpty:
            return "LinkedIn url is empty! Add the url and try again."
        case .invalidLinkedInUrl:
            return "LinkedIn url is invalid! Change the url and try again."
        case .unknown:
            print("AppError: unknown")
            return "Please restart the application."
        }
    }

    var title: String {
        return "Sorry, a problem occurred!"
    }
}
