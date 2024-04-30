//
//  HabitListView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//
import SwiftData
import SwiftUI

struct TodayListView: View {
    @Environment(\.modelContext) var modelContext
    
    
    @ObservedObject var habitsVM: HabitsViewModel
//    @State var showAddHabitSheet = false
    @Query var habits: [Habit]
    @State private var path = [Habit]()
    
    
    var body: some View {
        NavigationStack(path: $path){
            ZStack{
                Color(UIColor.systemGroupedBackground)
                    .edgesIgnoringSafeArea(.all)
                List{
                    
                    ForEach(Array(habits.enumerated()), id: \.element) { index, habit in
                        HabitRow(habitsVM: habitsVM, habit: habit)
                        .onTapGesture {
                            habitsVM.toggleHabitDone(habit: habit, on: habitsVM.today)
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .navigationTitle("Today")
                .navigationDestination(for: Habit.self){
                    habit in NewHabitView(habitsVM: habitsVM, habit: habit)
                }
                .toolbar{
                    Button("Hello", systemImage: "plus"){
                        addHabit()
                       // showAddHabitSheet = true
                    }
                }
                Spacer()
            }
        }
       
    }
    func addHabit(){
        let newHabit = Habit(name: "", createdAt: Date())
        modelContext.insert(newHabit)
        path.append(newHabit)
    }
}


struct HabitRow: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @Bindable var habit: Habit
//    var today: Date

    var body: some View {

        VStack(alignment: .trailing) {
            HStack {

                Image(systemName: habitsVM.isHabitDone(habit: habit, on: habitsVM.today) ? "checkmark.circle.fill": "circle")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
                    .padding()

                   // .foregroundStyle(LinearGradient.bluePurpleGradient)
//                    .foregroundStyle(LinearGradient.blueLightBlueGradient)
              
                HStack {
                    VStack(alignment: .leading) {
                        Text(habit.name)
                            .font(.headline)
                            .bold()
                        if habit.reminderSet{
                            Text("Reminder: \(habit.reminderDate.formatted(date: .omitted, time: .shortened))")
                                .font(.subheadline)
                                .foregroundColor(.gray)
                        }

                    }
                    Spacer()
                    ZStack{
                        Circle()
                           // .foregroundColor(.blue)
                            .foregroundColor(Color(circleColor(for: habit.currentStreak)))
                            .foregroundStyle(LinearGradient.blueLightBlueGradient)
                            .frame(width: 30, height: 30)
                        Text("\(habit.currentStreak)")
                            .font(.callout)
                            .foregroundColor(.white)
                    }
                }
                .padding()
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).shadow(radius: 1))
                .listRowInsets(EdgeInsets())
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .listRowBackground(Color.clear)
    


    }
    
    
    func circleColor(for streak: Int) -> Color{
        switch streak {
        case 1...2:
            return .blue
        case 3...6:
            return .green
        default:
            return .red
        }
    }
}
    
    #Preview {
        TodayListView(habitsVM: HabitsViewModel())
    }
