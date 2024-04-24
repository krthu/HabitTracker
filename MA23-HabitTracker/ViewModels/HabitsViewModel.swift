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
        if let date = getDate(year: 2024, month: 3, day: 23){
            toggleDone(habit: habits[0], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 11){
            toggleDone(habit: habits[0], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 12){
            toggleDone(habit: habits[0], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 20){
            toggleDone(habit: habits[0], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 21){
            toggleDone(habit: habits[0], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 22){
            toggleDone(habit: habits[0], onDate: date)
        }

        if let date = getDate(year: 2024, month: 4, day: 23){
            toggleDone(habit: habits[0], onDate: date)
        }


        
        if let date = getDate(year: 2024, month: 4, day: 14){
            toggleDone(habit: habits[1], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 18){
            toggleDone(habit: habits[1], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 20){
            toggleDone(habit: habits[1], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 22){
            toggleDone(habit: habits[1], onDate: date)
        }
        if let date = getDate(year: 2024, month: 4, day: 23){
            toggleDone(habit: habits[1], onDate: date)
        }
        
    }
    
    func getDate(year: Int, month: Int, day: Int) -> Date?{
        let calendar = Calendar.current
        let datecomponent = DateComponents(year: year, month: month, day: day)
        return calendar.date(from: datecomponent)
        
    }
    
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
    
    func getDate(numberOfDaysFrom: Int, from startDate: Date) -> Date{
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDaysFrom
        if let newDate = calendar.date(byAdding: dateComponents, to: startDate){
            return newDate
        }
        return startDate // Kanske borde vara nil
    }
    
    func addHabit(withName name: String){
        habits.append(Habit(name: name, createdAt: Date()))
    }
    
    func toggleDone(habit: Habit, onDate date: Date){
//        habit.done(onDate: date)
        if !isDone(habit: habit, on: date){
            habit.doneDays.append(date)
        }else{
            habit.doneDays.removeAll { habitDate in
                Calendar.current.isDate(habitDate, equalTo: date, toGranularity: .day)
            }
        }
    }
    
    func isDone( habit: Habit, on date: Date) -> Bool{
        return habit.doneDays.contains{ doneDate in
            Calendar.current.isDate(doneDate, equalTo: date, toGranularity: .day)
        }
    }
    
    func removeDone(habit: Habit, onDate date: Date){
//        habit.done(onDate: date)
        habit.doneDays.append(date)
    }
    
    func getProgress(for habit: Habit, in days: [Date]) -> Double{
       // var succes = 0.0
        var totalDays = days.count
        var daysDone = 0.0
        
        for day in days{
            if isDone(habit: habit, on: day){
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
           // currentDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate)
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
