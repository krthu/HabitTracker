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

    }

//    func getDate(year: Int, month: Int, day: Int) -> Date?{
//        let calendar = Calendar.current
//        let datecomponent = DateComponents(year: year, month: month, day: day)
//        return calendar.date(from: datecomponent)
//        
//    }
    
    func getWeekDays(for date: Date) -> [Date] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .weekOfYear, for: date)
        var weekDays: [Date] = []
        if let interval = interval{
            for i in 0..<7{
                if let dateOfWeek = calendar.date(byAdding: .day, value: i, to: interval.start){
                    weekDays.append(dateOfWeek)
                }
            }
        }
        return weekDays
    }
    
    func getWeekNumber(from date: Date) -> Int{
        let calender = Calendar.current
        let weekNumber = calender.component(.weekOfYear, from: date)
        return weekNumber
    }
    
    func getDaysOfMonth(from date: Date) -> [Date]{
        let calendar = Calendar.current
        var daysInMonth: [Date] = []
        if let monthInterval = calendar.range(of: .day, in: .month, for: date){
            for day in monthInterval{
                var dateComponents = DateComponents()
                dateComponents.day = day
                if let date = calendar.date(byAdding: dateComponents, to: date){
                    daysInMonth.append(date)
                }
            }
        }
        return daysInMonth
    }
    
    func getDate(numberOfDaysFrom: Int, from startDate: Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDaysFrom
        if let newDate = calendar.date(byAdding: dateComponents, to: startDate){
            return newDate
        }
        return startDate // Kanske borde vara nil
    }
    
//    func addHabit(withName name: String){
//        habits.append(Habit(name: name, createdAt: Date()))
//    }
    
    func toggleHabitDone(habit: Habit, on date: Date){
        if !isHabitDone(habit: habit, on: date){
            habit.doneDays.append(date)
        } else {
            habit.doneDays.removeAll { habitDate in
                Calendar.current.isDate(habitDate, equalTo: date, toGranularity: .day)
            }
        }
        print("\(isHabitDone(habit: habit, on: date))")
    }
    
    func isHabitDone(habit: Habit, on date: Date) -> Bool{
        return habit.doneDays.contains{ doneDate in
            Calendar.current.isDate(doneDate, equalTo: date, toGranularity: .day)
        }
    }
    

    func getIndex(of habit: Habit) -> Int {
        return habits.firstIndex(where: {$0.id == habit.id}) ?? 0
    }
    
    func getProgress(for habit: Habit, inWeekOf date: Date) -> Double {
        let days = getWeekDays(for: date)
        
        let totalDays = days.count
        var daysDone = 0.0
        
        for day in days{
            if isHabitDone(habit: habit, on: day){
                daysDone += 1
            }
        }
        return daysDone/Double(totalDays)
    }
}

extension Date {
    var startDateOfMonth: Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
            fatalError("Unable to get start date from date")
        }
        return date
    }

    var endDateOfMonth: Date {
        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth) else {
            fatalError("Unable to get end date from date")
        }
        return date
    }
    
    var getDaysInMonth: [Date]{
        let startDate = self.startDateOfMonth
        let endDate = self.endDateOfMonth
        
        var currentDate = startDate
        
        var allDays: [Date] = []
        while currentDate <= endDate{
            allDays.append(currentDate)
            if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate){
                currentDate = newDate
            }
        }
        return allDays
    }
    
    var monthName: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM"
        return dateFormatter.string(from: self)
        
    }
    
    func nextMonth(_ monthsToMove: Int = 1) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: monthsToMove, to: self)
    }
    
    func previousMonth(_ monthsToMove: Int = 1) -> Date? {
        let calendar = Calendar.current
        return calendar.date(byAdding: .month, value: -monthsToMove, to: self)
    }
}


