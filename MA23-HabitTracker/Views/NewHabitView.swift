//
//  NewHabitView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct NewHabitView: View {
    

    
    @State private var selectedTime = Date()
    @State var isReminderOn: Bool = false
    @Bindable var habit: Habit
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel = ViewModel()

    
    var body: some View {
       // NavigationStack{
        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            VStack(alignment: .leading){
                //HabitNameCard(name: $name)
                HabitNameCard(name: $habit.name)
                
                ReminderCard(selectedTime: $selectedTime, isReminderOn: $isReminderOn, habit: habit, viewModel: viewModel)
            
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

extension NewHabitView{
    class ViewModel: ObservableObject{
        var notifikationManager = NotificationManager()
        var dateManager = DateManager()
        
        
        func toggleReminder(habit: Habit) {

            notifikationManager.requestAuthorization{ didAllow in
                DispatchQueue.main.async {
                    if didAllow{

                        habit.reminderSet = true
                        habit.reminderDate = Date()
                        self.setNotifikation(habit: habit)
                    } else {

                        habit.reminderSet = false

                        self.notifikationManager.removeNotifikation(with: habit.id.uuidString)
                    }
                }
                
            }
        }
        
        func setNotifikation(habit: Habit){
            let title = "Don´t forget \(habit.name)!"
            let subtitle = habit.name
            

            let dateComponents = dateManager.getHourMinuteDateComponents(from: habit.reminderDate)
            notifikationManager.addNotifikation(title: title, subTitle: subtitle, dateComponents: dateComponents, identifier: habit.id.uuidString)

            
        }
        
        func removeNotifikation(habit: Habit){
            notifikationManager.removeNotifikation(with: habit.id.uuidString)
        }
        
        
    }
}


struct ReminderCard: View {
 //   var habitsVM: HabitsViewModel
    @Binding var selectedTime: Date
    @Binding var isReminderOn: Bool
    @Bindable var habit: Habit
    var viewModel: NewHabitView.ViewModel
    
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
                        viewModel.toggleReminder(habit: habit)
                    }
                }
            if habit.reminderSet{
                DatePicker("Pick a time", selection: $habit.reminderDate, displayedComponents: .hourAndMinute)
                    .disabled(!habit.reminderSet)
                    .onChange(of: habit.reminderDate) { oldValue, newValue in
                        print(newValue.timeIntervalSince1970)
                        viewModel.setNotifikation(habit: habit)
                    }
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
