
//  NetworkingTest.swift
//  PlanetTV_banquemisr.challenge05Tests
//  Created by Mahmoud  on 29/09/2024.

import XCTest
@testable import PlanetTV_banquemisr_challenge05

final class RemoteNetworkTests: XCTestCase {

    var remoteNetwork: RemoteNetwork!
    
    override func setUpWithError() throws {
        
        remoteNetwork = RemoteNetwork.shared
    }

    override func tearDownWithError() throws {
        remoteNetwork = nil
    }
    
    func testFetchMoviesSuccess() {
        let expectation = self.expectation(description: "Fetching movies from API")
        
        remoteNetwork.fetchMovies(endPoint: .nowPlaying) { result in
            switch result {
            case .success(let moviesResponse):
                XCTAssertNotNil(moviesResponse, "Movies response should not be nil")
                XCTAssertFalse(moviesResponse.results.isEmpty, "Movies list should not be empty")
            case .failure(let error):
                XCTFail("Expected successful fetch but got error: \(error)")
            }
            expectation.fulfill()
        }
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchMoviesFailure() {
        let expectation = self.expectation(description: "Fetching movies should fail")
        remoteNetwork.apiKey = "fedf875e78481f6k10d72c1a8d82ac3e"
        
        remoteNetwork.fetchMovies(endPoint: .nowPlaying) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse, "Expected invalid response error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

    func testFetchMovieByIdSuccess() {
        let expectation = self.expectation(description: "Fetching a specific movie by ID")
        let movieId = 550
        
        remoteNetwork.fetchMovie(id: movieId) { result in
            switch result {
            case .success(let movie):
                XCTAssertNotNil(movie, "Movie should not be nil")
                XCTAssertEqual(movie.id, movieId, "Fetched movie ID should match requested ID")
            case .failure(let error):
                XCTFail("Expected successful fetch but got error: \(error)")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }
    
    func testFetchMovieByIdFailure() {
        let expectation = self.expectation(description: "Fetching movie by invalid ID should fail")
        let invalidMovieId = -1 
        
        remoteNetwork.fetchMovie(id: invalidMovieId) { result in
            switch result {
            case .success:
                XCTFail("Expected failure but got success")
            case .failure(let error):
                XCTAssertEqual(error, .invalidResponse, "Expected invalid response error")
            }
            expectation.fulfill()
        }
        
        waitForExpectations(timeout: 10, handler: nil)
    }

}
