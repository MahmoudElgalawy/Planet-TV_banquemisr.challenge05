//
//  MoviesDetailsModel.swift
//  PlanetTV_banquemisr.challenge05
//
//  Created by Mahmoud  on 07/10/2024.
//

import Foundation

struct MoviesDetailsResponse: Decodable {
    let results: [MoviesDetails]
}

struct MoviesDetails: Decodable {
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
    let productionCompanies: [ProductionCompany]?
    let productionCountries: [ProductionCountry]?
    
}


struct Genre: Decodable {
    let id: Int
    let name: String
}

// Model for production company
struct ProductionCompany: Decodable {
    let id: Int
    let name: String
}

// Model for production country
struct ProductionCountry: Codable {
    let iso3166_1: String?  // استخدم Optional هنا لأن المفتاح قد يكون غير موجود
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case iso3166_1 = "iso_3166_1"
        case name
    }
}
