//
//  Habit.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//
import SwiftData
import Foundation

@Model
class Habit: Identifiable, Hashable{
    var id: UUID
    var name: String
    var createdAt: Date
    var doneDays: [Date]
    var reminderSet: Bool
    var reminderDate: Date
    
    
//    init(name: String, createdAt: Date){
//        self.name = name
//        self.createdAt = createdAt
//    }
    
    init(id: UUID = UUID(), name: String, createdAt: Date, doneDays: [Date] = [], reminderSet: Bool = false) {//
        self.id = id
        self.name = name
        self.createdAt = createdAt
        self.doneDays = doneDays
        self.reminderSet = reminderSet
        self.reminderDate = Date()
    }
    
    // Move to vm perhaps
    var currentStreak: Int{
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        
        var streak = 0
        var currentDate = calendar.date(byAdding: .day, value: -1, to: today)
        let doneDaysReversed = doneDays.reversed()
        
        for date in doneDaysReversed{
            if let previousDate = currentDate{
                if calendar.isDate(date, inSameDayAs: previousDate){
                    streak += 1
                    currentDate = calendar.date(byAdding: .day, value: -1, to: previousDate)
                } else if calendar.isDate(date, equalTo: today, toGranularity: .day){
                    streak += 1
                } else{
                    break
                }
            }
        }
        return streak
    }
    
    func isHabitDone(on date: Date) -> Bool{
        return doneDays.contains{ doneDate in
            Calendar.current.isDate(doneDate, equalTo: date, toGranularity: .day)
        }
    }
    
    func toggleDone(on date: Date){
        if !isHabitDone( on: date){
            doneDays.append(date)
        } else {
            doneDays.removeAll { habitDate in
                Calendar.current.isDate(habitDate, equalTo: date, toGranularity: .day)
            }
        }
    }
    
    func getProgress(days: [Date]) -> Double {
        
        let totalDays = days.count
        var daysDone = 0.0
        
        for day in days{
            if isHabitDone(on: day){
                daysDone += 1
            }
        }
        return daysDone/Double(totalDays)
    }
    
    
    
    
    
//    func done(onDate date: Date){
//        doneDays.append(date)
//    }
    
}
