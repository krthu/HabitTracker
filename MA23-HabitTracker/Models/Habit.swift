//
//  Habit.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import Foundation

class Habit: ObservableObject, Identifiable{
    var id = UUID()
    var name: String
    var createdAt: Date
    @Published var doneDays: [Date] = []
    
    init(name: String, createdAt: Date){
        self.name = name
        self.createdAt = createdAt
    }
    
    func done(onDate date: Date){
        doneDays.append(date)
    }
    
}
