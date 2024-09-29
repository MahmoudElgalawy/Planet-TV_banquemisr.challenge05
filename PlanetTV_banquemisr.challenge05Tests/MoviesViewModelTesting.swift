
//  MoviesViewModelTesting.swift
//  PlanetTV_banquemisr.challenge05Tests
//  Created by Mahmoud  on 29/09/2024.


import XCTest
@testable import PlanetTV_banquemisr_challenge05

final class MoviesViewModelTesting: XCTestCase {
    var viewModel : MoviesProtocol!
    override func setUpWithError() throws {
        viewModel = MoviesViewModel()
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testLoadPlayingNow() throws {
       let expectation = XCTestExpectation(description: "Load Now Playing Movies")
        viewModel.bindMoviesToViewController = {
            XCTAssertNotNil(self.viewModel.playingNow, "PlayingNow movies should not be nil")
            XCTAssertFalse(self.viewModel.playingNow?.isEmpty ?? true, "playingNow movies shouldn't be nil")
            expectation.fulfill()
        }
        viewModel.loadPlayingNow()
        wait(for: [expectation], timeout: 3)
    }
    func testLoadUpcoming() throws {
       let expectation = XCTestExpectation(description: "Load Now upcoming Movies")
        viewModel.bindMoviesToViewController = {
            XCTAssertNotNil(self.viewModel.upcoming, "upcoming movies should not be nil")
            XCTAssertFalse(self.viewModel.playingNow?.isEmpty ?? true, "upcoming movies shouldn't be nil")
            expectation.fulfill()
        }
        viewModel.loadUpcoming()
        wait(for: [expectation], timeout: 3)
    }
    func testLoadPopular() throws {
       let expectation = XCTestExpectation(description: "Load Now popular Movies")
        viewModel.bindMoviesToViewController = {
            XCTAssertNotNil(self.viewModel.popular, "popular movies should not be nil")
            XCTAssertFalse(self.viewModel.popular?.isEmpty ?? true, "popular movies shouldn't be nil")
            expectation.fulfill()
        }
        viewModel.loadPopular()
        wait(for: [expectation], timeout: 3)
    }
    
    func testLoadImageData(){
        let expectation = XCTestExpectation(description: "Load movie image")
        let validPosterPath = "https://image.tmdb.org/t/p/w500/valid_image.jpg"
        viewModel.loadImageData(posterPath: validPosterPath) { data in
            XCTAssertNotNil(data, "Image data should not be nil for valid image path")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }
    
    func testLoadImageDataFailure(){
        let expectation = XCTestExpectation(description: "Fail to Load movie image")
        let invalidPosterPath = "https://image.tmdb.org/l/k/w500/invalid_image.jpg"
        viewModel.loadImageData(posterPath: invalidPosterPath) { data in
            XCTAssertNil(data, "Image data should  be nil for invalid image path")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 3)
    }

   

}
