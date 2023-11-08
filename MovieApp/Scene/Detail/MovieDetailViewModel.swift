//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import Foundation

protocol MovieDetailViewModelOutput {
//    func updateView(title: String, released : String, poster: String, genre: String, runtime: String, director: String, language: String, plot: String, imdbRating: String, actors: String)
    func updateView(movieDetail: MovieDetailData?)
}

class MovieDetailViewModel {

    private let moviesService : MoviesService
    var delegate : MovieDetailViewModelOutput?
    
    init(moviesService: MoviesService) {
        self.moviesService = moviesService
    }
    
    func fetchMovieDetail(id: String?) {
        moviesService.fetchMovieDetails(id: id) { result in
            switch result {
            case .success(let movieDetail):
//                self.delegate?.updateView(title: movieDetail.title, released: movieDetail.released, poster: movieDetail.poster, genre: movieDetail.genre, runtime: movieDetail.runtime, director: movieDetail.director, language: movieDetail.language, plot: movieDetail.plot, imdbRating: movieDetail.imdbRating, actors: movieDetail.actors)
                self.delegate?.updateView(movieDetail: movieDetail)
            case .failure(_):
                print("a")
            }
        }
    }
}
