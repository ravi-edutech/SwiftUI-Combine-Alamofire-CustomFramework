//
//  ContentView.swift
//  MainApp
//
//  Created by Mr Ravi on 05/02/24.
//

import SwiftUI

import FindMyIPFramework

struct ContentView: View {
    
    @StateObject var ipaddressvm = IPAddressViewModel()
    
    var body: some View {
        VStack {
            if ipaddressvm.isLoading {
                ProgressView("Loading...")
            } else if ipaddressvm.displayError {
                Text(ipaddressvm.errorMessage)
            } else {
                Text(ipaddressvm.ipaddress?.ip ?? "")
                    .font(.title)
                Text(ipaddressvm.ipaddress?.city ?? "")
                    .font(.headline)
                Text(ipaddressvm.ipaddress?.countryName ?? "")
            }
        }
        .padding()
        .task {
            ipaddressvm.fetchIPAddressData()
        }
    }
}

#Preview {
    ContentView()
}
