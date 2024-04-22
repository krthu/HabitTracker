//
//  HabitListView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import SwiftUI

struct HabitListView: View {
    var habtisViewModel = HabitsViewModel()
    
    
    var body: some View {
        NavigationStack{
            List{
                ForEach(habtisViewModel.habits){ habit in
                    Text(habit.name)
                }
            }
            .navigationTitle("Habits")
            .toolbar{
                Button("Hello", systemImage: "plus"){
                }
            }
        }
    }
}

#Preview {
    HabitListView()
}