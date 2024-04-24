//
//  HabtiDetailsView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-24.
//

import SwiftUI

struct HabitDetailsView: View {
    @ObservedObject var habitsVM: HabitsViewModel
    @ObservedObject var habit: Habit

    
    
    var body: some View {
        
        VStack{
            habitCalendarView()
        }
        .navigationBarTitle("Calendar")
        
    }
}

struct habitCalendarView: View{
    var body: some View{
        VStack{
            HStack{
                Button(action: {
                   
                }, label: {
                    Image(systemName: "chevron.left")
                })
                .padding()
                //  Spacer()
                Text("MonthName")
                    .frame(width: 150)
                //   Spacer()
                Button(action: {
                   
                }, label: {
                    Image(systemName: "chevron.right")
                })
                .padding()
            }
        }
    }
}




#Preview {
    HabitDetailsView(habitsVM: HabitsViewModel(), habit:  Habit(name: "Dricka vatten", createdAt: Date()))
}

