//
//  MovieViewModelOutput.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 6.11.2023.
//

import Foundation

protocol MovieViewModelOutput {
    func updateView(movies: MoviesData?)
    func updateErrorView(error: String?)
}

