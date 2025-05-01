//
//  MapAppApp.swift
//  MapApp
//
//  Created by Akbarkhon Akramov on 19/08/24.
//

import SwiftUI

@main
struct MapAppApp: App {
    
    @StateObject private var vm = LocationsViewModel()
    
    var body: some Scene {
        WindowGroup {
            LocationsView()
                .environmentObject(vm)
        }
    }
}
