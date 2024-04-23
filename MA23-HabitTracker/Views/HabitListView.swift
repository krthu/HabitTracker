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
            List{
                ForEach(habitsVM.habits){ habit in
                    
                    HabitRow(habitsVM: habitsVM, habit: habit)


                }
            }
            .navigationTitle("Habits")
            .toolbar{
                Button("Hello", systemImage: "plus"){
                    showAddHabitSheet = true
                }
            }
        }
        .sheet(isPresented: $showAddHabitSheet, content: {
            AddHabitSheet(habitVM: habitsVM, showHabbitSheet: $showAddHabitSheet)
        })
    }
    
}


struct HabitRow: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @ObservedObject var habit: Habit
    
    var body: some View {
        HStack{
            Text(habit.name)
            
            Spacer()
            
            if !habitsVM.isDone(habit: habit, on: Date()){
                Button("Done"){
                    
                    habitsVM.done(habit: habit, onDate: Date())
                }
                .padding()
                .border(.blue)
            }
        }
        .onTapGesture {
            print("tapped row")
        }
        .border(.blue)
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
