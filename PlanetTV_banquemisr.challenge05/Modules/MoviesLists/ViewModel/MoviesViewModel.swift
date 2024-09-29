//
//  MoviesViewModel.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 27/09/2024.
//

import Foundation


protocol MoviesProtocol{
    func loadPlayingNow()
    func loadUpcoming()
    func loadPopular()
    func loadImageData(posterPath: String, completion: @escaping (Data?) -> Void)
    var playingNow:[Movies]?{get set}
    var upcoming: [Movies]?{get set}
    var popular: [Movies]?{get set}
    var bindMoviesToViewController : (()->()) {get set}
}


class MoviesViewModel:MoviesProtocol{
    let networt: MoviesServices?
    var playingNow:[Movies]?
    var upcoming: [Movies]?
    var popular: [Movies]?
    var bindMoviesToViewController : (()->()) = {}
    init() {
        networt = RemoteNetwork.shared
    }
    
    func loadPlayingNow() {
        networt?.fetchMovies(endPoint:.nowPlaying) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                DispatchQueue.main.async {
                    self?.playingNow = moviesResponse.results
                    
                    self?.bindMoviesToViewController()
                }
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
    
    
    func loadUpcoming()  {
        networt?.fetchMovies(endPoint:.upcoming) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                
                self?.upcoming = moviesResponse.results
                self?.bindMoviesToViewController()
            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
    }
    
    func loadPopular()  {
        networt?.fetchMovies(endPoint:.popular) { [weak self] result in
            switch result {
            case .success(let moviesResponse):
                
                self?.popular = moviesResponse.results
                self?.bindMoviesToViewController()

            case .failure(let error):
                print("Failed to fetch movies: \(error.localizedDescription)")
            }
        }
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
    
}



