//
//  HabitsViewModel.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import Foundation

class HabitsViewModel{
    var habits: [Habit] = []
    
    init() {
        addMockData()
    }
    
    func addMockData(){
        habits.append(Habit(name: "Löpa 5km", createdAt: Date()))
        habits.append(Habit(name: "Dricka vatten", createdAt: Date()))
    }
    
}
