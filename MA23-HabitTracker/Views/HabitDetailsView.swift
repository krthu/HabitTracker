//
//  HabtiDetailsView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct HabitDetailsView: View {
    @ObservedObject var habitsVM: HabitsViewModel
    var habit: Habit
    var habitIndex: Int
  //  @State var date = Date()
    @State var date: Date = {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components)!
    }()
    
    var body: some View {
        
        ZStack{
            Color(.systemGray6)
                .ignoresSafeArea()
            
            VStack{
                HStack{
                    Text("Calendar")
                        .font(.title2)
                        .bold()
                    Spacer()
                }
                habitCalendarView(habitsVM: habitsVM, habit: habit, date: $date, doneDays: habit.doneDays, habitIndex: habitIndex)
                    .padding()
                    .background()
                   
                    .cornerRadius(20)
            }
            .padding()
        }
        .navigationTitle(habit.name)
    }
}

struct habitCalendarView: View{
    @ObservedObject var habitsVM: HabitsViewModel
    var habit: Habit
    @Binding var date: Date
    var doneDays: [Date]
    var habitIndex: Int
    var body: some View{
        VStack{
            CalendarHeader(date: $date)
            CalendarBodyView(habitsVM: habitsVM, habit: habit, days: date.getDaysInMonth, habitIndex: habitIndex)
        }
    }
}

struct CalendarBodyView: View{
 
    @ObservedObject var habitsVM: HabitsViewModel
    var habit: Habit
    var days: [Date]
    var habitIndex: Int
  
    let columns = Array(repeating: GridItem(.flexible(), spacing: 0), count: 7)
    var body: some View{
        LazyVGrid(columns: columns, spacing: 0) {
            Text("Mo")
            Text("Tu")
            Text("We")
            Text("Th")
            Text("Fr")
            Text("Sa")
            Text("Su")
            ForEach(0..<firstWeekdayIndex, id: \.self) { _ in
                Spacer()
            }
            ForEach(days, id: \.self) { day in
                let dayNumber = Calendar.current.component(.day, from: day)
                CalendarDayView(dayNumber: dayNumber, isDone: habitsVM.isDone(index: habitIndex, on: day))
            }
        }
        
    }
    private var firstWeekdayIndex: Int {
        guard let firstDay = days.first else { return 0 }
        let weekday = Calendar.current.component(.weekday, from: firstDay)
        return (weekday + 5) % 7 // Justera indexet för att börja på måndag
    }
}


struct CalendarHeader: View {
    @Binding var date: Date
    
    var body: some View {
        HStack{
            Button(action: {
                if let newDate = date.previousMonth(){
                    date = newDate
                }
            }, label: {
                Image(systemName: "chevron.left")
            })
            .padding()

            Text(date.monthName)
                .frame(width: 150)

            Button(action: {
                if let newDate = date.nextMonth(){
                    date = newDate
                }
            }, label: {
                Image(systemName: "chevron.right")
            })
            .padding()
        }
    }
}

struct CalendarDayView: View {
    var dayNumber: Int

    var isDone: Bool
    var body: some View {
        VStack{
            Text("\(dayNumber)")
                .font(.caption)
                .bold()
        }
        .frame(width: 20, height: 30)
        .padding(8)
        .background(isDone ? Color.blue : Color.clear)
        
        .foregroundColor(isDone ? Color.white : .primary)
        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    HabitDetailsView(habitsVM: HabitsViewModel(), habit:  Habit(name: "Dricka vatten", createdAt: Date()), habitIndex: 0)
}

