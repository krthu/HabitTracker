//
//  HabitsViewModel.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import Foundation

class HabitsViewModel: ObservableObject{
    // -> Handled by swift Data
    @Published var habits: [Habit] = []
    var notifikationsManager = NotificationManager()
    @Published var today = Date()
    var dateManager = DateManager()
    
    init() {

    }
    
    func toggleReminder(habit: Habit) {

        notifikationsManager.requestAuthorization{ didAllow in
            DispatchQueue.main.async {
                if didAllow{

                    habit.reminderSet = true
                    habit.reminderDate = Date()
                    self.setNotifikation(habit: habit)
                } else {

                    habit.reminderSet = false

                    self.notifikationsManager.removeNotifikation(with: habit.id.uuidString)
                }
            }
            
        }
    }
    
    func setNotifikation(habit: Habit){
        let title = "Don´t forget \(habit.name)!"
        let subtitle = habit.name
        

        let dateComponents = dateManager.getHourMinuteDateComponents(from: habit.reminderDate)
        notifikationsManager.addNotifikation(title: title, subTitle: subtitle, dateComponents: dateComponents, identifier: habit.id.uuidString)

        
    }
    
    func removeNotifikation(habit: Habit){
        notifikationsManager.removeNotifikation(with: habit.id.uuidString)
    }
    
//    
//    // -> DateManager
//    func getWeekDays(for date: Date) -> [Date] {
//        let calendar = Calendar.current
//        let interval = calendar.dateInterval(of: .weekOfYear, for: date)
//        var weekDays: [Date] = []
//        if let interval = interval{
//            for i in 0..<7{
//                if let dateOfWeek = calendar.date(byAdding: .day, value: i, to: interval.start){
//                    weekDays.append(dateOfWeek)
//                }
//            }
//        }
//        return weekDays
//    }
//    // -> DateManager
//    func getWeekNumber(from date: Date) -> Int{
//        let calender = Calendar.current
//        let weekNumber = calender.component(.weekOfYear, from: date)
//        return weekNumber
//    }
//    
//    // -> DateManager
//    func getDaysOfMonth(from date: Date) -> [Date]{
//        let calendar = Calendar.current
//        var daysInMonth: [Date] = []
//        if let monthInterval = calendar.range(of: .day, in: .month, for: date){
//            for day in monthInterval{
//                var dateComponents = DateComponents()
//                dateComponents.day = day
//                if let date = calendar.date(byAdding: dateComponents, to: date){
//                    daysInMonth.append(date)
//                }
//            }
//        }
//        return daysInMonth
//    }
//    
//    func getHourMinuteDateComponents(from date: Date) -> DateComponents{
//        let calendar = Calendar.current
//        return calendar.dateComponents([.hour, .minute], from: date)
//    }
//    
//    // -> DateManager
//    func getDate(numberOfDaysFrom: Int, from startDate: Date) -> Date {
//        let calendar = Calendar.current
//        var dateComponents = DateComponents()
//        dateComponents.day = numberOfDaysFrom
//        if let newDate = calendar.date(byAdding: dateComponents, to: startDate){
//            return newDate
//        }
//        return startDate // Kanske borde vara nil
//    }
    
//    func addHabit(withName name: String){
//        habits.append(Habit(name: name, createdAt: Date()))
//    }
    
    // -> ViewModel / Model
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
    
    // -> ViewModel / Model
    func isHabitDone(habit: Habit, on date: Date) -> Bool{
        return habit.doneDays.contains{ doneDate in
            Calendar.current.isDate(doneDate, equalTo: date, toGranularity: .day)
        }
    }
    
    // ViewModel if needed
//    func getIndex(of habit: Habit) -> Int {
//        return habits.firstIndex(where: {$0.id == habit.id}) ?? 0
//    }
    
    // -> ViewModel / Model
    func getProgress(for habit: Habit, inWeekOf date: Date) -> Double {
        let days = dateManager.getWeekDays(for: date)
        
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

 // -> Date Manager
//extension Date {
//    var startDateOfMonth: Date {
//        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: self)) else {
//            fatalError("Unable to get start date from date")
//        }
//        return date
//    }
//
//    var endDateOfMonth: Date {
//        guard let date = Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: self.startDateOfMonth) else {
//            fatalError("Unable to get end date from date")
//        }
//        return date
//    }
//    
//    var getDaysInMonth: [Date]{
//        let startDate = self.startDateOfMonth
//        let endDate = self.endDateOfMonth
//        
//        var currentDate = startDate
//        
//        var allDays: [Date] = []
//        while currentDate <= endDate{
//            allDays.append(currentDate)
//            if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: currentDate){
//                currentDate = newDate
//            }
//        }
//        return allDays
//    }
//    
//    var monthName: String {
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "MMMM"
//        return dateFormatter.string(from: self)
//        
//    }
//    
//    func nextMonth(_ monthsToMove: Int = 1) -> Date? {
//        let calendar = Calendar.current
//        return calendar.date(byAdding: .month, value: monthsToMove, to: self)
//    }
//    
//    func previousMonth(_ monthsToMove: Int = 1) -> Date? {
//        let calendar = Calendar.current
//        return calendar.date(byAdding: .month, value: -monthsToMove, to: self)
//    }
//}


