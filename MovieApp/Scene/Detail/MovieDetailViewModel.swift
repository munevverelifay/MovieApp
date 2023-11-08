//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import Foundation

class MovieDetailViewModel {

    //dependency injection
    private let moviesService : MoviesService
    
    //delegate pattern
    var delegate : MovieDetailViewModelOutput?
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
//    func setIMDbID(_ imdbID: String) {
//        self.imdbID = imdbID
//    }
//    
    func fetchMovieDetail(id: String?) {
        moviesService.fetchMovieDetails(id: id) { result in
            switch result {
            case .success(let movieDetail):
                self.delegate?.updateView(title: movieDetail.title, released: movieDetail.released, poster: movieDetail.poster, genre: movieDetail.genre, runtime: movieDetail.runtime, director: movieDetail.director, language: movieDetail.language, plot: movieDetail.plot, imdbRating: movieDetail.imdbRating, actors: movieDetail.actors)
            case .failure(_):
                print("a")
                
            }
        }
    }
}
