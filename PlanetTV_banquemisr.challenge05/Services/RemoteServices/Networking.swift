//
//  Netwrking.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 27/09/2024.
//

import Foundation

class RemoteNetwork:MoviesServices{
    
    static let shared = RemoteNetwork()
    private init(){}
    
    private let apiKey = "fedf785e78418f6f10d72c1a8d82ac4e"
    private let baseUrl = "https://api.themoviedb.org/3"
    private let urlSession = URLSession.shared
    private let jsonDecoder = Utilities.jsonDecoder
    
    func fetchMovies( endPoint: MovieListEndPoint, completion: @escaping (Result<MoviesResponse, MoviesError>) -> ()) {
        guard let url = URL(string: "\(baseUrl)/movie/\(endPoint.rawValue)?api_key=\(apiKey)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
        
        urlSession.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let moviesResponse = try self.jsonDecoder.decode(MoviesResponse.self, from: data)
                completion(.success(moviesResponse))
            } catch {
                print("Serialization Error: \(error)")
                completion(.failure(.serializationError))
            }
            
        }.resume()
    }

    func fetchMovie(id: Int, completion: @escaping (Result<Movies, MoviesError>) -> ()) {
        guard let url = URL(string: "\(baseUrl)/movie/\(id)?api_key=\(apiKey)") else {
            completion(.failure(.invalidEndPoint))
            return
        }
    
        urlSession.dataTask(with: url) { data, response, error in
            if let _ = error {
                completion(.failure(.apiError))
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                completion(.failure(.invalidResponse))
                return
            }
            
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let movie = try self.jsonDecoder.decode(Movies.self, from: data)
                completion(.success(movie))
            } catch {
                print("Serialization Error: \(error)")
                completion(.failure(.serializationError))
            }
            
        }.resume()
    }

    
    
}
