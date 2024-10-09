//
//  MoviesDetailsViewModel.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 28/09/2024.
//

import Foundation

protocol DetailsProtocol{
    func loadImageData(posterPath: String, completion: @escaping (Data?) -> Void)
    func getDetails(completion: @escaping () -> Void)
    func fetchMovieVideos(id: Int, completion: @escaping (Result<[MovieVideo], MoviesError>) -> Void)
    var movieDetails:MoviesDetails!{get set}
    var movieId:Int!{get set}
}
class MoviesDetailsViewModel:DetailsProtocol{
    let networt: MoviesServices?
    var movieId:Int!
    var movieDetails:MoviesDetails!
    init(){
        networt = RemoteNetwork.shared
    }
    func getDetails(completion: @escaping () -> Void) {
        networt?.fetchMovie(id: movieId, completion: {[weak self] result in
            switch result {
            case .success(let moviesResponse):
                DispatchQueue.main.async {
                    self?.movieDetails = moviesResponse
                    completion()
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        })
    }
    func loadImageData(posterPath: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: posterPath) else {
            completion(nil)
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                completion(data)
            } else {
                completion(nil)
            }
        }.resume()
    }
    func fetchMovieVideos(id: Int, completion: @escaping (Result<[MovieVideo], MoviesError>) -> Void) {
        networt?.fetchMovieVideos(id: id) { result in
               switch result {
               case .success(let videos):
                   completion(.success(videos))
               case .failure(let error):
                   completion(.failure(error))
               }
           }
       }
}

