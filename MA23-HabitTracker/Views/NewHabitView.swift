//
//  NewHabitView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct NewHabitView: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @State var name: String = ""
    @State private var selectedTime = Date()
    @State var isReminderOn: Bool = false
    
    var body: some View {
       // NavigationStack{
            ZStack{
                Color(.secondarySystemBackground)
                    .ignoresSafeArea()
                VStack(alignment: .leading){
                    HabitNameCard(name: $name)
                    
                    ReminderCard(selectedTime: $selectedTime, isReminderOn: $isReminderOn )
                
                    Button(action: {
                        habitsVM.addHabit(withName: name)
                        isReminderOn = false
                        selectedTime = Date()
                        name = ""
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
            }
    }
}

struct ReminderCard: View {

    @Binding var selectedTime: Date
    @Binding var isReminderOn: Bool
    
    var body: some View {
        VStack(alignment: .leading){
            Text("Reminder")
                .font(.headline)
                .bold()
                .frame(maxWidth: .infinity, alignment: .leading)
            Toggle("Set a reminder", isOn: $isReminderOn)
                .tint(LinearGradient.bluePurpleGradient)
            if isReminderOn{
            DatePicker("Pick a time", selection: $selectedTime, displayedComponents: .hourAndMinute)
                .disabled(!isReminderOn)
         
            //    .foregroundColor(isReminderOn ? .primary : .secondary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(10)
 
    }
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

#Preview {
    NewHabitView(habitsVM: HabitsViewModel())
}
