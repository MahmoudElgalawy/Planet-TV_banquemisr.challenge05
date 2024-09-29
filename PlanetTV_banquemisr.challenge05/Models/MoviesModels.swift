//
//  MoviesModels.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 27/09/2024.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movies]
}

struct Movies: Decodable {
    let id: Int
    let title: String
    let backdropPath: String?
    let posterPath: String?
    let overview: String
    let voteAverage: Double?
    let voteCount: Int?
    let runtime: Int?
    let releaseDate: String
    let genres: [Genre]? 
    let tagline: String?
    
}


struct Genre: Decodable {
    let id: Int
    let name: String
}
