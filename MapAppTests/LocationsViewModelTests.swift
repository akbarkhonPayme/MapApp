//
//  MapAppTests.swift
//  MapAppTests
//
//  Created by Akramov Akbarkhon on 02/05/25.
//
import XCTest
import Combine
import MapKit
@testable import MapApp
import LocationsServiceKit

final class LocationsViewModelTests: XCTestCase {
    private var cancellables = Set<AnyCancellable>()
    
    /// Test that toggling the list flag works as expected.
    func testToggleLocationsList() {
        let vm = LocationsViewModel()
        
        XCTAssertFalse(vm.showLocationsList,
                       "By default the list should be hidden")
        
        vm.toggleLocationsList()
        XCTAssertTrue(vm.showLocationsList,
                      "After one toggle it should be shown")
        
        vm.toggleLocationsList()
        XCTAssertFalse(vm.showLocationsList,
                       "After two toggles it should be hidden again")
    }
    @MainActor
    func testInitialFetchSetsMapLocationAndRegion() async {
        let vm = LocationsViewModel()
        let expect = expectation(description: "mapLocation set")

        vm.$mapLocation
          .compactMap { $0 }
          .sink { location in
            let center = vm.mapRegion.center
            let coords = location.coordinates

            XCTAssertEqual(center.latitude,  coords.latitude,  accuracy: 0.0001)
            XCTAssertEqual(center.longitude, coords.longitude, accuracy: 0.0001)
            expect.fulfill()
          }
          .store(in: &cancellables)

        await fulfillment(of: [expect], timeout: 5.0)
    }
}
