//
//  ContentView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//

import SwiftUI

struct ContentView: View {
    @StateObject var habitsVM = HabitsViewModel()

    var body: some View {
        TabView{
   
            TodayListView(habitsVM: habitsVM)
                .tabItem {
                    Label("Today", systemImage:
                            "\(getSymbol(for:Date())).square")
                            //"list.bullet")
                }
            NewHabitView(habitsVM: habitsVM)
                .tabItem {
                    Label("Add Habit", systemImage:
                            "plus.circle")
                            //"list.bullet")
                }
            
            HabitsListView(habitsVM: habitsVM)
                .tabItem{
                    Label("Habits", systemImage: "list.bullet.rectangle.portrait")
                }
        }
        
    }
    func getSymbol(for date: Date) -> String{
        let components = Calendar.current.dateComponents([.day], from: date)
        if let day = components.day{
            return String(day)
        }
        return "0"
    }
}

//extension Color {
//static let bluePurpleGradient = LinearGradient(
//    gradient: Gradient(colors: [Color(UIColor(red: 73/255, green: 153/255, blue: 255/255, alpha: 1)), Color(UIColor(red: 79/255, green: 96/255, blue: 254/255, alpha: 1))]),
//startPoint: .topLeading,
//endPoint: .bottomTrailing
//)
//}

extension LinearGradient {
static let bluePurpleGradient = LinearGradient(
    gradient: Gradient(colors: [Color(UIColor(red: 80/255, green: 156/255, blue: 255/255, alpha: 1)), Color(UIColor(red: 79/255, green: 96/255, blue: 254/255, alpha: 1))]),
startPoint: .topLeading,
endPoint: .bottomTrailing
)
    
static let blueLightBlueGradient = LinearGradient(
    gradient: Gradient(colors: [Color(UIColor(red: 80/255, green: 156/255, blue: 255/255, alpha: 1)), Color(UIColor(red: 107/255, green: 223/255, blue: 254/255, alpha: 1))]),
startPoint: .topLeading,
endPoint: .bottomTrailing
)
}

#Preview {
    ContentView()
}
