//
//  MoviesServices.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 27/09/2024.
//

import Foundation

protocol MoviesServices {
    func fetchMovies (endPoint:MovieListEndPoint, completion: @escaping(Result<MoviesResponse,MoviesError>)->())
    func fetchMovie (id:Int, completion: @escaping(Result<Movies,MoviesError>)->())
}


enum MovieListEndPoint:String,CaseIterable{
    case nowPlaying = "now_playing"
    case upcoming
    case topRated = "top_rated"
    case popular
    var description:String {
        switch self{
            
        case .nowPlaying:
            return  "Now Playing"
        case .upcoming:
            return "Upcoming"
        case .topRated:
            return "Top Rated"
        case .popular:
            return "Popular"
        }
    }
}


enum MoviesError : Error,CustomNSError{
    case apiError
    case invalidResponse
    case invalidEndPoint
    case noData
    case serializationError
    
    var localizedDescription:String{
        switch self{
        case .apiError:
            return "Failed to fetch data"
        case .invalidResponse:
            return "Invalid response"
        case .invalidEndPoint:
            return "Invalid endPoint"
        case .noData:
            return "No data"
        case .serializationError:
            return "Failed to decode data"
        }
    }
    
    var errorUserInfo :[String : Any] {
        [NSLocalizedDescriptionKey:localizedDescription]
    }
}
