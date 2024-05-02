//
//  DateManager.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-30.
//

import Foundation

class DateManager{
  
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
        return date.getDaysInMonth
    }
    
    
    func getHourMinuteDateComponents(from date: Date) -> DateComponents{
        let calendar = Calendar.current
        return calendar.dateComponents([.hour, .minute], from: date)
    }
    

    func getDate(numberOfDaysFrom: Int, from startDate: Date) -> Date {
        let calendar = Calendar.current
        var dateComponents = DateComponents()
        dateComponents.day = numberOfDaysFrom
        if let newDate = calendar.date(byAdding: dateComponents, to: startDate){
            return newDate
        }
        return startDate 
    }
    
    func getFirstWeekdayIndex(from days: [Date]) -> Int{
        guard let firstDay = days.first else {return 0}
        let weekday = Calendar.current.component(.weekday, from: firstDay)
        return (weekday + 5) % 7
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
    
    var monthName: String {
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

