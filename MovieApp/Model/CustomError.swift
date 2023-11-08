//
//  CustomError.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import Foundation

enum CustomError: Error {
    case urlError
    case serverError
    case decodingError
    case networkError
    case parameterError
}
