//
//  SwiftUIView.swift
//  MapApp
//
//  Created by Akbarkhon Akramov on 19/08/24.
//

import SwiftUI
import MapKit
import LocationsServiceKit


struct LocationsView: View {
    @EnvironmentObject private var vm: LocationsViewModel
    let maxWidthForIpad: CGFloat = 700

    var body: some View {
        Group {
            if let selected = vm.mapLocation {
                ZStack {
                    mapLayer
                    VStack(spacing: 0) {
                        header(for: selected)
                        Spacer()
                        infoLayer
                    }
                }
                .sheet(item: $vm.sheetLocation) { location in
                    LocationDetailView(location: location)
                }
            } else {
                ProgressView("Loading locations…")
                    .font(.headline)
            }
        }
        .animation(.easeInOut, value: vm.mapLocation) 
    }
}

// MARK: - Private subviews
private extension LocationsView {
    func header(for loc: Location) -> some View {
        VStack {
            Text("\(loc.name), \(loc.cityName)")
                .font(.title2).fontWeight(.black)
                .foregroundStyle(.primary)
                .frame(height: 55)
                .frame(maxWidth: .infinity)
                .overlay(alignment: .leading) {
                    Image(systemName: "chevron.down")
                        .font(.headline)
                        .padding()
                        .rotationEffect(Angle(degrees: vm.showLocationsList ? 180 : 0))
                }
                .onTapGesture { vm.toggleLocationsList() }

            if vm.showLocationsList {
                LocationsListView()
            }
        }
        .background(.thinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .padding()
        .frame(maxWidth: maxWidthForIpad)
        .shadow(color: .black.opacity(0.3), radius: 20, x: 0, y: 15)
    }

    var infoLayer: some View {
        ZStack {
            ForEach(vm.locations) { location in
                if vm.mapLocation == location {
                    LocationPreviewView(location: location)
                        .shadow(color: .black.opacity(0.3), radius: 20)
                        .padding()
                        .frame(maxWidth: maxWidthForIpad)
                        .transition(.asymmetric(
                            insertion: .move(edge: .trailing),
                            removal: .move(edge: .leading)))
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }

    var mapLayer: some View {
        Map(coordinateRegion: $vm.mapRegion,
            annotationItems: vm.locations) { location in
            MapAnnotation(coordinate: location.coordinates) {
                LocationMapAnnotationView()
                    .scaleEffect(vm.mapLocation == location ? 1 : 0.7)
                    .shadow(radius: 10)
                    .onTapGesture { vm.showNextLocation(location: location) }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    LocationsView()
        .environmentObject(LocationsViewModel())
}
