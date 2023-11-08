//
//  MovieDetailViewModelOutput.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import Foundation

protocol MovieDetailViewModelOutput {
    func updateView(title: String, released : String, poster: String, genre: String, runtime: String, director: String, language: String, plot: String, imdbRating: String, actors: String)
}
