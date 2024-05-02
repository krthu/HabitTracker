//
//  NewHabitView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct NewHabitView: View {
    
    @Bindable var habit: Habit
    @Environment(\.modelContext) var modelContext
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {

        ZStack{
            Color(.secondarySystemBackground)
                .ignoresSafeArea()
            MainView(viewModel: ViewModel(selectedTime: habit.reminderDate, isReminderOn: habit.reminderSet, habitName: habit.name, habit: habit))

            .padding()
        }
        .navigationBarBackButtonHidden()

        .navigationBarItems(leading: Button(
            action: {
                presentationMode.wrappedValue.dismiss()
            },
            label: {
                Text("Cancel")
            })
        )
    }
}

extension NewHabitView{
    class ViewModel: ObservableObject{
        var notifikationManager = NotificationManager()
        var dateManager = DateManager()
        @Published var selectedTime: Date
        @Published var isReminderOn: Bool
        @Published var habitName: String
        var habit: Habit
        
        init( selectedTime: Date = Date(), isReminderOn: Bool, habitName: String, habit: Habit) {

            self.selectedTime = selectedTime
            self.isReminderOn = isReminderOn
            self.habitName = habitName
            self.habit = habit
        }
        
        func toggleReminder() {

            notifikationManager.requestAuthorization{ didAllow in
                DispatchQueue.main.async {
                    if didAllow{
                        self.isReminderOn = true
                    } else {
                        self.isReminderOn = false
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
        func saveHabit(){
            removeNotifikation(habit: habit)
            habit.name = habitName
            habit.reminderSet = isReminderOn
            habit.reminderDate = selectedTime
            if habit.reminderSet{
                setNotifikation(habit: habit)
            }
        }
    }
}

struct MainView: View{
    @Environment(\.modelContext) var modelContext
    @StateObject var viewModel: NewHabitView.ViewModel
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View{
        VStack(alignment: .leading){

            HabitNameCard(name: $viewModel.habitName)
            
            ReminderCard(selectedTime: $viewModel.selectedTime, isReminderOn: $viewModel.isReminderOn, viewModel: viewModel)
        
            Button(action: {

                viewModel.saveHabit()
                presentationMode.wrappedValue.dismiss()
            }, label: {
                Text("Save")
                    .frame(maxWidth: .infinity)
                    .padding()

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
    func deleteEmptyHabit(){
        if viewModel.habit.name == "" {
            modelContext.delete(viewModel.habit)
        }
    }
    
}


struct ReminderCard: View {
    
    @Binding var selectedTime: Date
    @Binding var isReminderOn: Bool
    
    @ObservedObject var viewModel: NewHabitView.ViewModel
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Reminder")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Toggle("Set a reminder", isOn: $viewModel.isReminderOn)
                .tint(LinearGradient.bluePurpleGradient)
                .onChange(of: viewModel.isReminderOn) { oldValue, newValue in
                    if newValue {
                        //viewModel.toggleReminder(habit: habit)
                        viewModel.toggleReminder()
                    }
                }
            if viewModel.isReminderOn{
                DatePicker("Pick a time", selection: $viewModel.selectedTime, displayedComponents: .hourAndMinute)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
    }
}

struct HabitNameCard: View {
    @Binding var name: String
 
    var body: some View {
        VStack(alignment: .leading){
            Text("Habit name")
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
