//
//  MovieAppTests.swift
//  MovieAppTests
//
//  Created by Münevver Elif Ay on 6.11.2023.
//

import XCTest
@testable import MovieApp

final class MovieAppTests: XCTestCase {
    
    private var movieService : MockMoviesService!
    private var moviesViewModel : MoviesViewModel!
    private var movieDetailViewModel : MovieDetailViewModel!
    private var moviesOutput : MockMoviesViewModelOutput!
    private var movieDetailOutput : MockMovieDetailViewModelOutput!
    
    override func setUpWithError() throws {
        movieService = MockMoviesService()
        
        moviesViewModel = MoviesViewModel(moviesService: movieService)
        movieDetailViewModel = MovieDetailViewModel(moviesService: movieService)
        
        moviesOutput = MockMoviesViewModelOutput()
        moviesViewModel.delegate = moviesOutput
        
        movieDetailOutput = MockMovieDetailViewModelOutput()
        movieDetailViewModel.delegate = movieDetailOutput
    }
    
    override func tearDownWithError() throws {
        moviesViewModel = nil
        movieDetailViewModel = nil
        movieService = nil
    }
    
    func testMovieUpdateView_whenAPISuccess_showsMovies() throws {
        let typeEnum : TypeEnum = .movie
        let search = Search(title: "Movie", year: "2023", imdbID: "tt7286456", type: typeEnum, poster: "")
        let mockMovies = MoviesData(search: [search], totalResults: "50", response: "True", error: nil)
        
        movieService.fetchMoviesMockResult = .success(mockMovies)
        moviesViewModel.fetchMovies(page: "1")
        XCTAssertEqual(moviesOutput.moviesArray.count, 1)
        XCTAssertEqual(moviesOutput.moviesArray[0]?.title, "Movie")
        XCTAssertEqual(moviesOutput.moviesArray[0]?.year, "2023")
        XCTAssertEqual(moviesOutput.moviesArray[0]?.imdbID, "tt7286456")
        XCTAssertEqual(moviesOutput.moviesArray[0]?.type, .movie)
        XCTAssertEqual(moviesOutput.moviesArray[0]?.poster, "")
    }
    
    func testSearchUpdateView_whenAPISuccess_showsMovies() throws {
        let typeEnum : TypeEnum = .movie
        let search = Search(title: "Joker", year: "2023", imdbID: "tt7286456", type: typeEnum, poster: "")
        let mockMovieDetail = MoviesData(search: [search], totalResults: "50", response: "True", error: nil)
        movieService.fetchSearcedMoviesMockResult = .success(mockMovieDetail)
        moviesViewModel.fetchSerchedMovies(page: "1", movie: "tt7286456")
        XCTAssertEqual(moviesOutput.moviesSearchArray?.search?.count, 1)
        XCTAssertEqual(moviesOutput.moviesSearchArray?.search?[0]?.title, "Joker")
        XCTAssertEqual(moviesOutput.moviesSearchArray?.search?[0]?.year, "2023")
        XCTAssertEqual(moviesOutput.moviesSearchArray?.search?[0]?.imdbID, "tt7286456")
        XCTAssertEqual(moviesOutput.moviesSearchArray?.search?[0]?.type, .movie)
        XCTAssertEqual(moviesOutput.moviesSearchArray?.search?[0]?.poster, "")
    }
    
    func testMovieDetailUpdateView_whenAPISuccess_showsMovieDetail() throws {
        let mockMovieDetail = MovieDetailData(title: "Lady Bird", year: "2017", rated: "R", released: "01 Dec 2017", runtime: "94", genre: "Comedy, Drama", director: "Greta Gerwig", writer: "Greta Gerwig", actors: "Saoirse Ronan, Laurie Metcalf, Tracy Letts", plot: "In 2002, an artistically inclined 17-year-old girl comes of age in Sacramento, California.", language: "English, Spanish", country: "United States", awards: "Nominated for 5 Oscars. 122 wins & 226 nominations total", poster: "", imdbRating:  "7.4", imdbVotes: "314,545", imdbID: "tt4925292", type: "movie", boxOffice: "$48,958,273", response: "True")
        
        movieService.fetchMovieDetailsMockResult = .success(mockMovieDetail)
        movieDetailViewModel.fetchMovieDetail(id: "tt4925292")
        if let movieDetail = movieDetailOutput.movieDetailArray {
            XCTAssertEqual(movieDetail.title.count, 1)
            XCTAssertEqual(movieDetail.title,"Lady Bird")
            XCTAssertEqual(movieDetail.released,"01 Dec 2017")
            XCTAssertEqual(movieDetail.runtime,"94")
            XCTAssertEqual(movieDetail.genre,"Comedy, Drama")
            XCTAssertEqual(movieDetail.director,"Greta Gerwig")
            XCTAssertEqual(movieDetail.actors,"Saoirse Ronan, Laurie Metcalf, Tracy Letts")
            XCTAssertEqual(movieDetail.plot,"In 2002, an artistically inclined 17-year-old girl comes of age in Sacramento, California.")
            XCTAssertEqual(movieDetail.poster,"")
            XCTAssertEqual(movieDetail.imdbRating,"7.4")
        }
    }
    
    func testSearchedUpdateView_whenAPIFailure_showsNoMovie() throws {
        let serverError = CustomError.serverError
        movieService.fetchMoviesMockResult = .failure(serverError)
        moviesViewModel.fetchMovies(page: "")
        XCTAssertEqual(moviesOutput.moviesArray.count, 0)
        XCTAssertEqual(moviesOutput.moviesArray.isEmpty, true)
    }
    
    func testMovieDetailUpdateView_whenAPIFailure_showsNoMovies() throws {
        let serverError = CustomError.serverError
        
        movieService.fetchMovieDetailsMockResult = .failure(serverError)
        movieDetailViewModel.fetchMovieDetail(id: "")
    
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.title, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.released, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.runtime, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.genre, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.director, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.actors, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.plot, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.poster, nil)
        XCTAssertEqual(movieDetailOutput.movieDetailArray?.imdbRating, nil)
    }
}

class MockMoviesService : MoviesService {
    var fetchMoviesMockResult : Result<MoviesData, CustomError>?
    var fetchMovieDetailsMockResult : Result<MovieApp.MovieDetailData, MovieApp.CustomError>?
    var fetchSearcedMoviesMockResult : Result<MoviesData, CustomError>?
    
    func fetchMovies(page: String?, completion: @escaping (Result<MoviesData, CustomError>) -> ()) {
        if let result = fetchMoviesMockResult {
            completion(result)
        }
    }
    func fetchSearchedMovies(page: String?, movie: String?, completion: @escaping (Result<MoviesData, CustomError>) -> ()) {
        if let result = fetchSearcedMoviesMockResult {
            completion(result)
        }
    }
    
    func fetchMovieDetails(id: String?, completion: @escaping (Result<MovieApp.MovieDetailData, MovieApp.CustomError>) -> ()) {
        if let result = fetchMovieDetailsMockResult {
            completion(result)
        }
    }
}

class MockMoviesViewModelOutput: MovieViewModelOutput {

    var moviesArray: [Search?] = []
    var moviesSearchArray: MoviesData?
    var errorMessage: String?
    

    func updateView(movies: MoviesData?) {
        self.moviesArray = movies?.search ?? []
        self.moviesSearchArray = movies
    }

    func updateErrorView(error: String?) {
        self.errorMessage = error
    }
    
    func showError(error: CustomError?) {
       
    }
}

class MockMovieDetailViewModelOutput : MovieDetailViewModelOutput {
    var movieDetailArray : MovieDetailData?
    func updateView(movieDetail: MovieApp.MovieDetailData?) {
        if (movieDetailArray != nil) {
            movieDetailArray = movieDetail
        }
    }
    
    func showError(error: MovieApp.CustomError?) {
    
    }
}
