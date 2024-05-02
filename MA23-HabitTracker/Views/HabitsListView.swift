//
//  statusView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-23.
//
import SwiftData
import SwiftUI

struct HabitsListView: View {

    @StateObject var viewModel = ViewModel()

    @Query var habits: [Habit]

    
    var body: some View {
        NavigationStack{
            VStack{
                
                    HStack{
                        Button(action: {
                       //     dateSet = dateManager.getDate(numberOfDaysFrom: -daysBetween, from: dateSet)
                            viewModel.previousWeek()
                        }, label: {
                            Image(systemName: "chevron.left")
                        })
                        .padding()
                       
                        Text("Week \(viewModel.weekNR)")
                            .frame(width: 150)
                        
                        Button(action: {
                          //  dateSet = dateManager.getDate(numberOfDaysFrom: daysBetween, from: dateSet)
                            viewModel.nextWeek()
                        }, label: {
                            Image(systemName: "chevron.right")
                        })
                        .padding()
                    }

            }
            
            List{
                ForEach(habits){ habit in
                    Section{
                        NavigationLink(destination: HabitDetailsView(habit: habit)){

                            HabitStatsRowView(habit: habit, viewModel: viewModel)
                                .padding(.vertical, 10)
                            
                        }
                    }
                }
            }
        }
    }
}
extension HabitsListView{
    class ViewModel: ObservableObject{
        var dateSet = Date()
        var daysBetween = 7
        var dateManager = DateManager()
        @Published var weekDays: [Date]
        @Published var weekNR: Int

        
        
        init(dateSet: Date = Date(), daysBetween: Int = 7) {
            self.dateSet = dateSet
            self.daysBetween = daysBetween
            self.weekDays = dateManager.getWeekDays(for: dateSet)
            self.weekNR = dateManager.getWeekNumber(from: dateSet)
            
        }
        
        func previousWeek(){
            dateSet = dateManager.getDate(numberOfDaysFrom: -daysBetween, from: dateSet)
            weekDays = dateManager.getWeekDays(for: dateSet)
            weekNR = dateManager.getWeekNumber(from: dateSet)
        }
        func nextWeek(){
            dateSet = dateManager.getDate(numberOfDaysFrom: daysBetween, from: dateSet)
            weekDays = dateManager.getWeekDays(for: dateSet)
            weekNR = dateManager.getWeekNumber(from: dateSet)
        }
        
        func getProgress(for habit: Habit) -> Double {

            
            let totalDays = weekDays.count
            var daysDone = 0.0
            
            for day in weekDays{
                if isHabitDone(habit: habit, on: day){
                    daysDone += 1
                }
            }
            return daysDone/Double(totalDays)
        }
        
        func isHabitDone(habit: Habit, on date: Date) -> Bool{
            return habit.doneDays.contains{ doneDate in
                Calendar.current.isDate(doneDate, equalTo: date, toGranularity: .day)
            }
        }
    }
}


struct HabitStatsRowView: View {

    var habit: Habit
    @ObservedObject var viewModel: HabitsListView.ViewModel

    var dateManager = DateManager()
    var body: some View {
        VStack(alignment: .leading){
            
            Text("\(habit.name)")
                .font(.headline)
                .bold()

            ProgressView(value: viewModel.getProgress(for: habit))
            

            weekView(viewModel: viewModel, habit: habit, weekDays: viewModel.weekDays)
            
        }
    }
}


struct weekView: View {

    @ObservedObject var viewModel: HabitsListView.ViewModel
    var habit: Habit
    let calendar = Calendar.current

    var weekDays: [Date]
    
    var body: some View {
        HStack {
            ForEach(weekDays, id: \.self) { date in

                let dateFormatter = DateFormatter()
                let weekday = calendar.component(.weekday, from: date)
                let dayName = dateFormatter.shortWeekdaySymbols[weekday - 1]
                let components = calendar.dateComponents([.day], from: date)
                
                
                if let dayNumber = components.day{
                    DayView(dayNumber: dayNumber, weekdayName: dayName, isDone: viewModel.isHabitDone(habit: habit, on: date))
                }
            }
        }
    }
}

struct DayView: View {
    var dayNumber: Int
    var weekdayName: String
    var isDone: Bool
    var body: some View {
        VStack{
            Text("\(weekdayName)")
                .foregroundColor(.secondary)
                .font(.caption)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Image(systemName: isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(.blue)
                .font(.title)
        }
        .frame(width: 20)
        .padding(.horizontal, 8)
    }
}





//#Preview {
//    HabitsListView(habitsVM: HabitsViewModel())
//}
