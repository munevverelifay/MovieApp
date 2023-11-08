//
//  MoviesViewModel.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 6.11.2023.
//

import Foundation

class MoviesViewModel {

    //dependency injection
    private let moviesService : MoviesService
    
    //delegate pattern
    var delegate : MovieViewModelOutput?
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
 
    func fetchMovies(page: String?) {
        moviesService.fetchMovies(page: page) { result in
            switch result {
            case .success(let movies):
                self.delegate?.updateView(movies: movies)
            case .failure(_):
                print("a")
                
            }
        }
    }
    
    func fetchSerchedMovies(page: String?, movie: String?) {
        moviesService.fetchSearchedMovies(page: page, movie: movie) { result in
            switch result {
            case .success(let movies):
                print(movies)
                if (movies.error != nil) {
                    self.delegate?.updateErrorView(error: movies.error)
                } else {
                    self.delegate?.updateView(movies: movies)
                }
            case .failure(_):
                print("b")
            }
        }
    }
}

