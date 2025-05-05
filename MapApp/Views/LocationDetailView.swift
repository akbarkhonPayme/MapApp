//
//  LocationDetailView.swift
//  MapApp
//
//  Created by Akbarkhon Akramov on 20/08/24.
//

import SwiftUI
import MapKit
import LocationsServiceKit

struct LocationDetailView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    let location: Location

    private let detailSpan = MKCoordinateSpan(latitudeDelta: 0.05,
                                              longitudeDelta: 0.05)
    
    var body: some View {
        ScrollView {
            VStack {
                imageSection
                
                VStack(alignment: .leading, spacing: 16) {
                    titleSection
                    
                    Divider()
                    
                    descriptionSection
                    
                    Divider()
                    
                    mapLayer
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            }
        }
        .ignoresSafeArea()
        .background(.ultraThinMaterial)
        .overlay(backButton, alignment: .topLeading)
    }
}

private extension LocationDetailView {
    
    var imageSection: some View {
        TabView {
            ForEach(location.imageURLs, id: \.self) { url in
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .empty:
                        Color.gray
                            .overlay(ProgressView())
                    case .success(let image):
                        image
                            .resizable()
                            .scaledToFill()
                    case .failure:
                        Image(systemName: "xmark.octagon")
                            .font(.largeTitle)
                    @unknown default:
                        EmptyView()
                    }
                }
                .frame(
                  width: UIScreen.main.bounds.width,
                  height: 500
                )
                .clipped()
            }
        }
        .frame(height: 500)
        .shadow(radius: 20, y: 10)
        .tabViewStyle(.page)
    }
    
    var titleSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(location.name)
                .font(.largeTitle)
                .fontWeight(.semibold)
            Text(location.cityName)
                .font(.title)
                .foregroundStyle(.secondary)
        }
    }
    
    var descriptionSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(location.description)
                .font(.subheadline)
                .foregroundStyle(.secondary)
            
            Link("Read more on Wikipedia", destination: location.link)
                .font(.headline)
                .tint(.blue)
        }
    }
    
    var mapLayer: some View {
        Map(
            coordinateRegion: .constant(
                MKCoordinateRegion(
                    center: location.coordinates,
                    span: detailSpan
                )
            ),
            annotationItems: [location]
        ) { loc in
            MapAnnotation(coordinate: loc.coordinates) {
                LocationMapAnnotationView()
                    .shadow(radius: 10)
            }
        }
        .allowsHitTesting(false)
        .aspectRatio(1, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 30))
    }
    
    var backButton: some View {
        Button {
            vm.sheetLocation = nil
        } label: {
            Image(systemName: "xmark")
                .font(.headline)
                .padding(16)
                .foregroundStyle(.primary)
                .background(.thickMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .shadow(radius: 4)
        }
        .padding()
    }
}

//#Preview {
//    // Use the old static service just for previews:
//    let sampleLocation = LocationsService.locations.first!
//    
//    LocationDetailView(location: sampleLocation)
//        .environmentObject(LocationsViewModel())
//}
