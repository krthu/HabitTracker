//
//  HabitListView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//
import SwiftData
import SwiftUI

struct TodayListView: View {
    
    @ObservedObject var habitsVM: HabitsViewModel
    @State var showAddHabitSheet = false
    @Query var habits: [Habit]
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(UIColor.systemGroupedBackground) // Byt ut mot önskad bakgrundsfärg.
                    .edgesIgnoringSafeArea(.all)
                List{
                    
                    ForEach(Array(habits.enumerated()), id: \.element) { index, habit in
                        HabitRow(habitsVM: habitsVM, habit: habit, habitIndex: index)
                        .onTapGesture {
                            habitsVM.toggleHabitDone(habit: habit, on: Date())
                        }
                    }
                    .listRowSeparator(.hidden)
                }
                .listStyle(PlainListStyle())
                .background(Color.clear)
                .navigationTitle("Today")
                .toolbar{
                    Button("Hello", systemImage: "plus"){
                        showAddHabitSheet = true
                    }
                }
                .sheet(isPresented: $showAddHabitSheet, content: {
                   // AddHabitSheet(habitVM: habitsVM, showHabbitSheet: $showAddHabitSheet)
                    NewHabitView(habitsVM: habitsVM)
                })
                Spacer()
            }
        }
    }
}


struct HabitRow: View {
    @ObservedObject var habitsVM: HabitsViewModel
    var habit: Habit
    var habitIndex: Int
    var body: some View {

        VStack(alignment: .trailing) {
            HStack {

                Image(systemName: habitsVM.isHabitDone(habit: habit, on: Date()) ? "checkmark.circle.fill": "circle")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
                    .padding()
                   // .foregroundStyle(.linearGradient(colors: [.blue, .purple], startPoint: .top, endPoint: .bottom))
                   // .foregroundStyle(LinearGradient.bluePurpleGradient)
//                    .foregroundStyle(LinearGradient.blueLightBlueGradient)
              
                HStack {
                    VStack(alignment: .leading) {
                        Text(habit.name)
                            .font(.headline)
                            .bold()
                        Text("Reminder")
                            .font(.subheadline)
                            .foregroundColor(.gray)
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

// -----------------Remove if not in use----------
//struct AddHabitSheet: View {
//    
//    @ObservedObject var habitVM: HabitsViewModel
//    @State var name = ""
//    @Binding var showHabbitSheet: Bool
//    
//    var body: some View {
//        VStack{
//            Text("New Habit")
//                .font(.title)
//                .bold()
//                .padding()
//            Form{
//                Section("Habit"){
//                    TextField("Habit", text: $name)
//                }
//                
//            }
//            Button("Save"){
//                if !name.isEmpty{
//                    habitVM.addHabit(withName: name)
//                }
//                showHabbitSheet = false
//            }
//        }
//    }
//}
    
    #Preview {
        TodayListView(habitsVM: HabitsViewModel())
    }
