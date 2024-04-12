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
    case badHttpUrlResponse
    case badStatusCode
    case invalidJson
    case emptyTextField
    case invalidMail
    case invalidFrPhone
    case badPwdConfirm
    case invalidMailOrPwd
    case internalServerError
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
        case .badHttpUrlResponse:
            print("AppError: badHttpUrlResponse")
            return "Our server is currently unavailable."
        case .badStatusCode:
            print("AppError: badStatusCode")
            return "Our server is currently unavailable."
        case .invalidJson:
            print("AppError: invalidJson")
            return "Our server is currently unavailable."
        case .emptyTextField:
            return "Oops! this field must not be empty."
        case .invalidMail:
            return "Email is invalid! Change email and try again."
        case .invalidFrPhone:
            return "Phone is invalid! Change phone and try again."
        case .badPwdConfirm:
            return "Oops! Enter an identical password."
        case .invalidMailOrPwd:
            return "Invalid email or password."
        case .internalServerError:
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
