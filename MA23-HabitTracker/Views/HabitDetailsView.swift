//
//  HabtiDetailsView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct HabitDetailsView: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    
    @Bindable var habit: Habit
//    var habitIndex: Int

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
                habitCalendarView(habitsVM: habitsVM, habit: habit, date: $date, doneDays: habit.doneDays)
                //.padding()
                    .background()
                
                    .cornerRadius(20)
                Spacer()
                Button(action: {
                    deleteHabit(habit: habit)
                }, label: {
                    Label("Delete", systemImage: "trash")
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(.red)
                        .foregroundColor(.white)
                        .bold()
                        .cornerRadius(20)
                })
            }
            .padding()
        }

        .navigationTitle(habit.name)
        .toolbar{
            NavigationLink(destination: NewHabitView(habitsVM: habitsVM, habit: habit)){
                Text("Edit")
            }
        }
    }
    func editHabit(){
        
    }
    
    func deleteHabit(habit: Habit){
        habitsVM.removeNotifikation(habit: habit)
        modelContext.delete(habit)
        presentationMode.wrappedValue.dismiss()
    }
}




struct habitCalendarView: View{
    @ObservedObject var habitsVM: HabitsViewModel
    var habit: Habit
    @Binding var date: Date
    var doneDays: [Date]

    var body: some View{
        VStack{
            CalendarHeader(date: $date)
                .frame(maxWidth: .infinity)
                .foregroundColor(.white)
                .background(LinearGradient.bluePurpleGradient)
            CalendarBodyView(habitsVM: habitsVM, habit: habit, days: date.getDaysInMonth)
                .padding(10)
        }
    }
}

struct CalendarBodyView: View{
 
    @ObservedObject var habitsVM: HabitsViewModel
    var habit: Habit
    var days: [Date]

  
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
                CalendarDayView(dayNumber: dayNumber, isDone: habitsVM.isHabitDone(habit: habit, on: day))
            }
        }
        
    }
    
    // VM Or dateManager
    
    private var firstWeekdayIndex: Int {
        guard let firstDay = days.first else { return 0 }
        let weekday = Calendar.current.component(.weekday, from: firstDay)
        return (weekday + 5) % 7 // Adjusting Index to start on Monday
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
    HabitDetailsView(habitsVM: HabitsViewModel(), habit:  Habit(name: "Dricka vatten", createdAt: Date()))
}

