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
//        MoviesData(search: [], totalResults: nil, response: "False", error: "No movie found")
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
        XCTAssertEqual(movieDetailOutput.movieDetailArray.count, 1)
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.title,"Lady Bird")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.released,"01 Dec 2017")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.runtime,"94")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.genre,"Comedy, Drama")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.director,"Greta Gerwig")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.actors,"Saoirse Ronan, Laurie Metcalf, Tracy Letts")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.plot,"In 2002, an artistically inclined 17-year-old girl comes of age in Sacramento, California.")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.poster,"")
        XCTAssertEqual(movieDetailOutput.movieDetailArray.first?.imdbRating,"7.4")
        
    }
    func testUpdateView_whenAPIFailure_showsNoMovie() throws {
        let serverError = CustomError.serverError
        movieService.fetchMovieDetailsMockResult = .failure(serverError)
        movieDetailViewModel.fetchMovieDetail(id: "")
        XCTAssertEqual(moviesOutput.moviesArray.count, 0)
        XCTAssertEqual(moviesOutput.moviesArray.isEmpty, true)
    }
    
    func testSearchUpdateView_whenAPIFailure_showsNoMovies() throws {

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
}
//düzelt
class MockMovieDetailViewModelOutput : MovieDetailViewModelOutput {
    var movieDetailArray : [(title: String, released: String, poster: String, genre: String, runtime: String, director: String, language: String, plot: String, imdbRating: String, actors: String)] = []
    
    func updateView(title: String, released: String, poster: String, genre: String, runtime: String, director: String, language: String, plot: String, imdbRating: String, actors: String) {
        movieDetailArray.append((title, released, poster, genre, runtime, director, language, plot, imdbRating, actors))
    }
}
