//
//  MovieDetailViewModel.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 7.11.2023.
//

import Foundation

protocol MovieDetailViewModelOutput {
    func updateView(movieDetail: MovieDetailData?)
    func showError(error: CustomError?)
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
                self.delegate?.updateView(movieDetail: movieDetail)
            case .failure(let error):
                self.delegate?.showError(error: error)
            }
        }
    }
}
