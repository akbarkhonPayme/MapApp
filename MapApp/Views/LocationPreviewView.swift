//
//  LocationPreviewView.swift
//  MapApp
//
//  Created by Akbarkhon Akramov on 20/08/24.
//

import SwiftUI
import LocationsServiceInterface
import LocationsServiceImplementation

struct LocationPreviewView: View {
    
    @EnvironmentObject private var vm: LocationsViewModel
    
    let location: Location
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 0) {
            VStack(alignment: .leading, spacing: 16.0) {
                imageSection
                
                titleSection
            }
            
            VStack(spacing: 8) {
                learnMoreButton
                nextButton
            }
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(.ultraThinMaterial)
                .offset(y: 65)
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

extension LocationPreviewView {
    private var imageSection: some View {
        ZStack {
                if let url = location.imageURLs.first {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            Color.gray
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        case .failure:
                            Image(systemName: "photo")
                                .frame(width: 100, height: 100)
                        @unknown default:
                            EmptyView()
                        }
                    }
                } else {
                    Color.gray
                        .frame(width: 100, height: 100)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
            }
        .padding(6)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    private var titleSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.bold)
            
            Text(location.cityName)
                .font(.subheadline)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var learnMoreButton: some View {
        Button {
            vm.sheetLocation = location
        } label: {
            Text("Learn more")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(BorderedProminentButtonStyle())
    }
    
    private var nextButton: some View {
        Button {
            vm.nextButtonPressed()
        } label: {
            Text("Next")
                .font(.headline)
                .frame(width: 125, height: 35)
        }
        .buttonStyle(BorderedButtonStyle())
    }
}
//
//#Preview {
//    LocationPreviewView(location: LocationsService.locations.first!)
//        .environmentObject(LocationsViewModel())
//}
