//
//  APIManager.swift
//  MovieApp
//
//  Created by Münevver Elif Ay on 6.11.2023.
//

import Foundation

protocol MoviesService {
    func fetchMovies(page: String?, completion: @escaping (Result<MoviesData, CustomError>) -> ())
    func fetchMovieDetails(id: String?, completion: @escaping (Result<MovieDetailData, CustomError>) -> ())
    func fetchSearchedMovies(page: String?, movie: String?, completion: @escaping (Result<MoviesData,CustomError>) -> ())
}

class APIManager : MoviesService {
    
    func fetchMovies(page: String?, completion: @escaping (Result<MoviesData, CustomError>) -> ()) {
        guard let page else {
            return completion(.failure(.parameterError))
        }
        
        guard let url = URL(string: Constants.Paths.baseURL + Constants.Paths.movieNameSearch + Constants.Paths.movieStandart + Constants.Paths.moviePage + page) else {
            return completion(.failure(.urlError))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            
            if (error != nil) {
                return completion(.failure(.networkError))
            }
            
            if let data {
                DispatchQueue.main.async {
                    do {
                        let moviesData = try JSONDecoder().decode(MoviesData.self, from: data)
                        completion(.success(moviesData))
                    } catch {
                        completion(.failure(.decodingError))
                    }
                }
            }
        }.resume()
        
    }
    
    func fetchMovieDetails(id: String?, completion: @escaping (Result<MovieDetailData, CustomError>) -> ()) {
        guard let id else {
            return completion(.failure(.parameterError))
        }
        guard let url = URL(string: Constants.Paths.baseURL + Constants.Paths.movieIdSearch + id) else {
            return completion(.failure(.urlError))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
            }
            
            if let data {
                do {
                    let movieDetail = try JSONDecoder().decode(MovieDetailData.self, from: data)
                    completion(.success(movieDetail))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
    
    func fetchSearchedMovies(page: String?, movie: String?, completion: @escaping (Result<MoviesData, CustomError>) -> ()) {
        guard let page, let movie else{
            return completion(.failure(.parameterError))
        }
        
        guard let url = URL(string: Constants.Paths.baseURL + Constants.Paths.movieNameSearch + movie + Constants.Paths.moviePage + page) else {
            return completion(.failure(.urlError))
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                completion(.failure(.networkError))
            }
            
            if let data {
                do {
                    let moviesData = try JSONDecoder().decode(MoviesData.self, from: data)
                    completion(.success(moviesData))
                } catch {
                    completion(.failure(.decodingError))
                }
            }
        }.resume()
    }
}


