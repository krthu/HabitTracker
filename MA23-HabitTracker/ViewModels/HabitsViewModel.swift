//
//  HabitsViewModel.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import Foundation

class HabitsViewModel: ObservableObject{
    @Published var habits: [Habit] = []
    
    init() {
        addMockData()
    }
    
    func addMockData(){
        habits.append(Habit(name: "Löpa 5km", createdAt: Date()))
        habits.append(Habit(name: "Dricka vatten", createdAt: Date()))
    }
    
    func addHabit(withName name: String){
        habits.append(Habit(name: name, createdAt: Date()))
    }
    
    func done(habit: Habit, onDate date: Date){
//        habit.done(onDate: date)
        habit.doneDays.append(date)
    }
    
    func isDone( habit: Habit, on date: Date) -> Bool{
        return habit.doneDays.contains{ doneDate in
            Calendar.current.isDate(doneDate, equalTo: date, toGranularity: .day)
        }
    }
    
}
