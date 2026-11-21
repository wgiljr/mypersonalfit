//
//  ContentView.swift
//  mypersonalfit
//
//  Created by Wagner Gil Jr. on 10/15/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            Tab("Programs", systemImage: "figure.highintensity.intervaltraining", role: .none, content: {
                ProgramsView()
            })
            
            Tab("Account", systemImage: "person.crop.circle.fill", content: {
                SettingsView()
            })
        }
    }
}

#Preview {
    ContentView()
}
