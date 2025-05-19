//
//  LocationsViewModel.swift
//  MapApp
//
//  Created by Akbarkhon Akramov on 19/08/24.
//

import SwiftUI
import MapKit
import LocationsServiceInterface
import LocationsServiceImplementation

class LocationsViewModel: ObservableObject {
    // MARK: – State
    @Published var locations: [Location] = []
    @Published var mapLocation: Location?
    @Published var mapRegion: MKCoordinateRegion = MKCoordinateRegion()
    @Published var showLocationsList: Bool = false
    @Published var sheetLocation: Location? = nil
    
    // MARK: – Private
    private let service = LocationsService()
    let mapSpan = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)

    // MARK: – Init
    init() {
        fetchLocations()
    }
    
    // MARK: – Networking
    private func fetchLocations() {
        Task {
            do {
                let locs = try await service.fetchLocations()
                DispatchQueue.main.async {
                    self.locations = locs
                    if let first = locs.first {
                        self.setMapLocation(to: first)
                    }
                }
            } catch {
                print("❌ Failed loading locations:", error)
            }
        }
    }
    
    // MARK: – Helpers
    private func setMapLocation(to location: Location) {
        mapLocation = location
        mapRegion = MKCoordinateRegion(
            center: location.coordinates,
            span: mapSpan
        )
    }
    
    // MARK: – User Actions
    func toggleLocationsList() {
        withAnimation { showLocationsList.toggle() }
    }
    
    func showNextLocation(location: Location) {
        withAnimation {
            setMapLocation(to: location)
            showLocationsList = false
        }
    }
    
    func nextButtonPressed() {
        guard
            let current = mapLocation,
            let idx = locations.firstIndex(of: current)
        else { return }
        
        let nextIndex = locations.index(after: idx)
        let next = nextIndex < locations.endIndex
            ? locations[nextIndex]
            : locations.first!
        
        showNextLocation(location: next)
    }
}

// I am writing this message to test out the git tasks I have been given, please ignore
