//
//  ContentView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView{
            HabitListView()
            .tabItem {
                Label("Habits", systemImage: "list.bullet")
            }
        }
    }
}

#Preview {
    ContentView()
}
