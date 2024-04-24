//
//  HabitListView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import SwiftUI

struct TodayListView: View {
    
    @ObservedObject var habitsVM: HabitsViewModel
    @State var showAddHabitSheet = false
    
    var body: some View {
        NavigationStack{
            ZStack{
                Color(UIColor.systemGroupedBackground) // Byt ut mot önskad bakgrundsfärg.
                    .edgesIgnoringSafeArea(.all)
                List{
                    ForEach(habitsVM.habits){ habit in
                        
                        HabitRow(habitsVM: habitsVM, habit: habit)
                            .onTapGesture {
                                habitsVM.toggleDone(habit: habit, onDate: Date())
                            }
                            .listRowSeparator(.hidden)
                        
                        
                    }
                    
                    
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
                    AddHabitSheet(habitVM: habitsVM, showHabbitSheet: $showAddHabitSheet)
                })
                Spacer()
            }
        }
        
    }
}


struct HabitRow: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @ObservedObject var habit: Habit
    
    var body: some View {
//        HStack {
//            Image(systemName: habitsVM.isDone(habit: habit, on: Date()) ? "checkmark.circle.fill": "circle")
//                .foregroundColor(.blue)
//                .font(.title)
//            HStack{
//            VStack(alignment: .leading){
//                    Text(habit.name)
//                        .font(.headline)
//                        .bold()
//                    Text("Reminder")
//                        .font(.footnote)
//                        .foregroundStyle(.secondary)
//                }
//                Spacer()
//                VStack{
//     
//                    ZStack{
//                        Circle()
//                            .foregroundColor(.gray)
//                            .frame(width: 30, height: 30)
//                        Text("\(habit.currentStreak)")
//                            .font(.callout)
//                    }
//                    
//                }
//                .padding(.horizontal, 10)
//                
//                
//                
//            }
//        }
//        .frame(maxWidth: .infinity)
//        .padding(.vertical, 10)
        VStack(alignment: .trailing) {
            HStack {
                Image(systemName: habitsVM.isDone(habit: habit, on: Date()) ? "checkmark.circle.fill": "circle")
                    .foregroundColor(.blue)
                    .font(.largeTitle)
                    .padding()
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
                  //  VStack{
                        ZStack{
                            Circle()
                               // .foregroundColor(.blue)
                                .foregroundColor(Color(circleColor(for: habit.currentStreak)))
                                .frame(width: 30, height: 30)
                            Text("\(habit.currentStreak)")
                                .font(.callout)
                                .foregroundColor(.white)
                        }
                   // }

                    
//                    Image(systemName: "chevron.right")
//                        .foregroundColor(.gray)
//                        .padding(.trailing, 15)
                    
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

struct AddHabitSheet: View {
    
    @ObservedObject var habitVM: HabitsViewModel
    @State var name = ""
    @Binding var showHabbitSheet: Bool
    
    var body: some View {
        VStack{
            Text("New Habit")
                .font(.title)
                .bold()
                .padding()
            Form{
                Section("Habit"){
                    TextField("Habit", text: $name)
                }
                
            }
            Button("Save"){
                if !name.isEmpty{
                    habitVM.addHabit(withName: name)
                }
                showHabbitSheet = false
            }
        }
    }
}
    
    #Preview {
        TodayListView(habitsVM: HabitsViewModel())
    }
