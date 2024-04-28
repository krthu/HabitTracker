//
//  NewHabitView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct NewHabitView: View {
    
    @ObservedObject var habitsVM: HabitsViewModel
//    @State var name: String = ""
    @State private var selectedTime = Date()
    @State var isReminderOn: Bool = false
    @Bindable var habit: Habit
    @Environment(\.modelContext) var modelContext
//    @Bindable var habit: Habit
    
    var body: some View {
       // NavigationStack{
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            VStack(alignment: .leading){
                //HabitNameCard(name: $name)
                HabitNameCard(name: $habit.name)
                
                ReminderCard(habitsVM: habitsVM, selectedTime: $selectedTime, isReminderOn: $isReminderOn, habit: habit)
            
                Button(action: {
                    //habitsVM.addHabit(withName: name)
//                       let newHabit = Habit(name: name, createdAt: Date())
//                       modelContext.insert(newHabit)
                    
//                        isReminderOn = false
//                        selectedTime = Date()
//                        name = ""
                    
                }, label: {
                    Text("Add new Habit")
                        .frame(maxWidth: .infinity)
                        .padding()
                       // .background(Color.bluePurpleGradient)
                       // .background(LinearGradient.bluePurpleGradient)
                        .background(LinearGradient.blueLightBlueGradient)
                        .foregroundColor(.white)
                        .bold()
                        .cornerRadius(20)
                })
            }
            .padding()
            .onDisappear{
                deleteEmptyHabit()
            }
        }
        
        
    }
    func deleteEmptyHabit(){
        if habit.name == "" {
            modelContext.delete(habit)
        }
    }
}

struct ReminderCard: View {
    var habitsVM: HabitsViewModel
    @Binding var selectedTime: Date
    @Binding var isReminderOn: Bool
    @Bindable var habit: Habit
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Reminder")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Toggle("Set a reminder", isOn: $habit.reminderSet)
                .tint(LinearGradient.bluePurpleGradient)
                .onChange(of: habit.reminderSet) { oldValue, newValue in
                    if newValue {
                        habitsVM.toggleReminder(habit: habit)
                    }
                }
            if habit.reminderSet{
                DatePicker("Pick a time", selection: $habit.reminderDate, displayedComponents: .hourAndMinute)
                    .disabled(!habit.reminderSet)
                    .onChange(of: habit.reminderDate) { oldValue, newValue in
                        print(newValue.timeIntervalSince1970)
                        habitsVM.setNotifikation(habit: habit)
                    }
         
            //    .foregroundColor(isReminderOn ? .primary : .secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
 
    }
    // Move to TimeManager or VM
    var timeFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }
}

struct HabitNameCard: View {
    @Binding var name: String
 
    var body: some View {
        VStack(alignment: .leading){
            Text("Create a habit name")
                .font(.headline)
                .bold()
            TextField("Name", text: $name)
                .padding(10)
                .background(Color(.secondarySystemBackground))
                .cornerRadius(10)
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
        
    }
}

//#Preview {
//    NewHabitView(habitsVM: HabitsViewModel())
//}
