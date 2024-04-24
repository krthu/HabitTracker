//
//  ContentView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habitsVM = HabitsViewModel()
    
    
    var body: some View {
        TabView{
            HabitListView(habitsVM: habitsVM)
            .tabItem {
                Label("Habits", systemImage: "list.bullet")
            }
            StatusView(habitsVM: habitsVM)
            .tabItem{
                Label("Stats", systemImage: "chart.bar")
            }
            
        }
    }
}

#Preview {
    ContentView()
}
