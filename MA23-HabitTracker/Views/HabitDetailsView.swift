//
//  HabtiDetailsView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct HabitDetailsView: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @ObservedObject var habit: Habit
  //  @State var date = Date()
    @State var date: Date = {
        let calendar = Calendar.current
        let currentDate = Date()
        let components = calendar.dateComponents([.year, .month], from: currentDate)
        return calendar.date(from: components)!
    }()

    
    
    var body: some View {
        
        VStack{
            habitCalendarView(date: $date)
        }
        .navigationBarTitle("Calendar")
        
    }
}

struct habitCalendarView: View{
    @Binding var date: Date
    var body: some View{
        VStack{

            CalendarHeader(date: $date)
        }
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




#Preview {
    HabitDetailsView(habitsVM: HabitsViewModel(), habit:  Habit(name: "Dricka vatten", createdAt: Date()))
}

