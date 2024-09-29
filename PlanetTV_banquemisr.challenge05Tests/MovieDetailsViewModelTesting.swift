//
//  MovieDetailsViewModelTesting.swift
//  PlanetTV_banquemisr.challenge05Tests
//
//  Created by Mahmoud  on 29/09/2024.
//

import XCTest
@testable import PlanetTV_banquemisr_challenge05

final class MovieDetailsViewModelTesting: XCTestCase {
    var viewModel:DetailsProtocol?
    override func setUpWithError() throws {
        viewModel = MoviesDetailsViewModel()
        viewModel?.movieId = 550
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func testGetDetails() {
            let expectation = XCTestExpectation(description: "Fetch Movie Details")
            
        viewModel?.getDetails {
            XCTAssertNotNil(self.viewModel?.movieDetails, "Movie details should not be nil")
            XCTAssertEqual(self.viewModel?.movieDetails.id, self.viewModel?.movieId, "Fetched movie ID should match the expected movie ID")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }

        
        func testLoadImageData() {
            let expectation = XCTestExpectation(description: "Load Movie Image Data")
            let validPosterPath = "https://image.tmdb.org/t/p/w500/valid_image.jpg"
            
            viewModel?.loadImageData(posterPath: validPosterPath) { data in
                XCTAssertNotNil(data, "Image data should not be nil for valid image path")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
        
        
        func testLoadImageDataFailure() {
            let expectation = XCTestExpectation(description: "Fail to Load Movie Image Data")
            let invalidPosterPath = "https://invalid_url/invalid_image.jpg"
            
            viewModel?.loadImageData(posterPath: invalidPosterPath) { data in
                XCTAssertNil(data, "Image data should be nil for invalid image path")
                expectation.fulfill()
            }
            
            wait(for: [expectation], timeout: 5)
        }
}


