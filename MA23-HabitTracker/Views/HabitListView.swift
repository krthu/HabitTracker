//
//  HabitListView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import SwiftUI

struct HabitListView: View {
    
    @ObservedObject var habitsVM: HabitsViewModel
    @State var showAddHabitSheet = false
    
    var body: some View {
        NavigationStack{
            VStack{
                List{
                    Section{
                        ForEach(habitsVM.habits){ habit in
                            HabitRow(habitsVM: habitsVM, habit: habit)
                                .onTapGesture {
                                    habitsVM.toggleDone(habit: habit, onDate: Date())
                                }
                        }
                        .navigationTitle("Today")
                    }

                }
            }
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


struct HabitRow: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @ObservedObject var habit: Habit
    
    var body: some View {
        HStack {
            Image(systemName: habitsVM.isDone(habit: habit, on: Date()) ? "checkmark.circle.fill": "circle")
                .foregroundColor(.blue)
                .font(.title)
            HStack{
            VStack(alignment: .leading){
                    Text(habit.name)
                        .font(.headline)
                        .bold()
                    Text("Reminder")
                        .font(.footnote)
                        .foregroundStyle(.secondary)
                }
                Spacer()
                Text("\(habit.currentStreak)")
                
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)

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
        HabitListView(habitsVM: HabitsViewModel())
    }
