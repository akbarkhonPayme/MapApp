//
//  LocationsService.swift
//  MapAppTests
//
//  Created by Akramov Akbarkhon on 02/05/25.
//

import XCTest
import LocationsServiceInterface
import LocationsServiceImplementation

final class LocationsServiceTest: XCTestCase {

    override func setUpWithError() throws {
        continueAfterFailure = false
    }

    override func tearDownWithError() throws {}

    func testFetchLocationsReturnsAtLeastOne() async throws {
           // Given
           let service = LocationsService()
           
           // When
           let locations = try await service.fetchLocations()
           
           // Then
           XCTAssertGreaterThan(locations.count, 0,
                                "Expected at least one location from the mock API")
       }
}
