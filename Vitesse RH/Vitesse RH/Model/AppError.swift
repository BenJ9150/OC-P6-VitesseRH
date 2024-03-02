//
//  AppError.swift
//  Vitesse RH
//
//  Created by Benjamin LEFRANCOIS on 23/02/2024.
//

import Foundation

enum AppError: Error {
    case serverErr
    case invalidUrl
    case badStatusCode
    case invalidData
    case invalidJson
    case invalidMail
    case linkedInUrlEmpty
    case invalidLinkedInUrl
    case unknown

    // MARK: Message Builder

    /// Call example: let ErrorMess = ApiError.invalidUrl.message
    var message: String {
        let start = "Please restart the application."

        switch self {
        case .serverErr:
            return "\(start)\nError: 101, launch server"
        case .invalidUrl:
            return "\(start)\nError: 102"
        case .badStatusCode:
            return "\(start)\nError: 103"
        case .invalidData:
            return "\(start)\nError: 104"
        case .invalidJson:
            return "\(start)\nError: 105"
        case .invalidMail:
            return "Email is invalid! Change your email and try again."
        case .linkedInUrlEmpty:
            return "LinkedIn url is empty! Add the url and try again."
        case .invalidLinkedInUrl:
            return "LinkedIn url is invalid! Change the url and try again."
        case .unknown:
            return "\(start)\nError: 100"
        }
    }

    var title: String {
        return "Sorry, a problem occurred!"
    }
}
