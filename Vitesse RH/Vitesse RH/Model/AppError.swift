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
    case invalidMail
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
        case .invalidMail:
            return "Email is invalid! Change your email and try again."
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
