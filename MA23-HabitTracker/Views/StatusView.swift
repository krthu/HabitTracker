//
//  statusView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-23.
//

import SwiftUI

struct StatusView: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @State var dateSet = Date()
    @State var daysBetweenViews = 7
    
    var body: some View {
        NavigationStack{
            VStack{
                
                ZStack{ // remove if not used
                    HStack{
                        Image(systemName: "calendar")
                            .font(.title)
                            .padding()
                            .onTapGesture {
                                print("show Month")
                                
                            }
                        Spacer()
                    }
                    HStack{
                        Button(action: {
                            dateSet = habitsVM.getDate(numberOfDaysFrom: -daysBetweenViews, from: dateSet)
                        }, label: {
                            Image(systemName: "chevron.left")
                        })
                        .padding()
                        //  Spacer()
                        Text("Week \(habitsVM.getWeekNumber(from: dateSet))")
                            .frame(width: 150)
                        //   Spacer()
                        Button(action: {
                            dateSet = habitsVM.getDate(numberOfDaysFrom: daysBetweenViews, from: dateSet)
                        }, label: {
                            Image(systemName: "chevron.right")
                        })
                        .padding()
                    }
                }
            }
  
            List{
                ForEach(habitsVM.habits){ habit in
                    //weekView(habitsVM: habitsVM, habit: habit, weekDays: habitsVM.getWeekDays(for: Date()))
                    
                    Section{
                        NavigationLink(destination: HabitDetailsView(habitsVM: habitsVM, habit: habit)){
                            HabitStatsRowView(habitsVM: habitsVM, habit: habit, date: dateSet)
                                .padding(.vertical, 10)

                        }
                    }
                }
            }
        }
    }
}

struct HabitStatsRowView: View {
    var habitsVM: HabitsViewModel
    var habit: Habit
    // Perhaps need a date
    var date: Date
    var body: some View {
        VStack{
            Text("\(habit.name)")
            weekView(habitsVM: habitsVM, habit: habit, weekDays: habitsVM.getWeekDays(for: date))
        }
    }
}



struct weekView: View {
    var habitsVM: HabitsViewModel
    var habit: Habit
    let calendar = Calendar.current
//    let today = Date()
//    let dateFormatter = DateFormatter()
    var weekDays: [Date]
    
    var body: some View {
        HStack {
            ForEach(weekDays, id: \.self) { date in
                let dateFormatter = DateFormatter()
                let weekday = calendar.component(.weekday, from: date)
                let dayName = dateFormatter.shortWeekdaySymbols[weekday - 1]
                
                
                let components = calendar.dateComponents([.day], from: date)
                if let dayNumber = components.day{
                    DayView(dayNumber: dayNumber, weekdayName: dayName, isGreen: habitsVM.isDone(habit: habit, on: date))
                }
                
                
            }
//            ForEach(0..<7) { index in
 //               let day = calendar.date(byAdding: .day, value: index, to: calendar.startOfDay(for: today))!
//                let dayNumber = calendar.component(.day, from: day)
//                let weekday = calendar.component(.weekday, from: day)
//                let weekdayName = dateFormatter.shortWeekdaySymbols[weekday - 1]
//                
//                DayView(dayNumber: dayNumber, weekdayName: weekdayName, isGreen: habitsVM.isDone(habit: habit, on: day))
//
//            }
            
        }
    }

}

struct DayView: View {
    var dayNumber: Int
    var weekdayName: String
    var isGreen: Bool
    var body: some View {
        VStack{
            Text("\(dayNumber)")
                .font(.caption)
                .bold()
            Text("\(weekdayName)")
                .foregroundColor(.secondary)
                .font(.footnote)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
                
                
        }
        .frame(width: 20, height: 30)
        .padding(8)
       // .cornerRadius(10)
        //.border(.black)
        .background(isGreen ? Color.green : Color.clear)
        .cornerRadius(10)
        .overlay(
            RoundedRectangle(cornerRadius: 10) // Lägg till en overlay med samma hörnradie
                .stroke(Color.black, lineWidth: 1) // Lägg till en svart ram med en tjocklek på 1 punkt runt de rundade hörnen
        )
        
        


    }
}




#Preview {
    StatusView(habitsVM: HabitsViewModel())
}
