//
//  CoreDataTesting.swift
//  PlanetTV_banquemisr.challenge05Tests
//
//  Created by Mahmoud  on 29/09/2024.
//

import XCTest
@testable import PlanetTV_banquemisr_challenge05
import CoreData


final class CoreDataTesting: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var moviesStorage: MoviesStorage!

    override func setUpWithError() throws {
    persistentContainer = NSPersistentContainer(name: "PlanetTV_banquemisr_challenge05")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        persistentContainer.loadPersistentStores { _, error in
            if let error = error as NSError?{
                fatalError("Failed to lead in-memory store: \(error)")
            }
        }
        moviesStorage = MoviesStorage.shared
    }

    override func tearDownWithError() throws {
        persistentContainer = nil
        moviesStorage = nil
    }

    func testStoreMovies() throws {
        let movie1 = Movies(id: 1, title: "move1", backdropPath: "backdropPath1.png", posterPath: "posterPath1.png", overview: "overViewMovieOne", voteAverage: 7.5, voteCount: 100, runtime: 120, releaseDate: "01-09-2024", genres: nil, tagline: "tagLine1")
        let movie2 = Movies(id: 2, title: "move2", backdropPath: "backdropPath1.png", posterPath: "posterPath2.png", overview: "overViewMovieOne", voteAverage: 7.5, voteCount: 100, runtime: 120, releaseDate: "01-09-2024", genres: nil, tagline: "tagLine2")
        moviesStorage.storeMovies([movie1,movie2],category: "playingNow")
        let fectchMovies = moviesStorage.fetchMovies(category: "playingNow")
        XCTAssertEqual(fectchMovies.count, 2, "Movies were not stored correctly")
    }
    

    func testFetchMoviesByCategory() throws {
        let mymovie = Movies(id: 1, title: "my movie", backdropPath: nil, posterPath: nil, overview: "overViewmymovie", voteAverage:nil, voteCount: nil, runtime: nil, releaseDate: "01-09-2024", genres: nil, tagline: nil)
        moviesStorage.storeMovies([mymovie], category: "upcoming")
        let fectchMovies = moviesStorage.fetchMovies(category: "upcoming")
        XCTAssertEqual(fectchMovies.count, 1, "fetch Movie return incorrect number")
        XCTAssertEqual(fectchMovies.first?.title, mymovie.title, "my movie title doesn't match")
    }

    func testDeleteMovies() throws{
        let movietest = Movies(id: 6, title: "movie test", backdropPath: nil, posterPath: nil, overview: "overViewMovietest", voteAverage: nil, voteCount: nil, runtime: nil, releaseDate: "16-07-2018", genres: nil, tagline: nil)
        let movieTest = Movies(id: 7, title: "movie Test", backdropPath: nil, posterPath: nil, overview: "overViewMovieTest", voteAverage: nil, voteCount: nil, runtime: nil, releaseDate: "20-04-2015", genres: nil, tagline: nil)
        moviesStorage.storeMovies([movietest,movieTest], category: "popular")
        moviesStorage.deleteAllMovies()
        let fectchMovies = moviesStorage.fetchMovies(category: "popular")
        XCTAssertTrue(fectchMovies.isEmpty, "all movie should be deleted")
    }
}
