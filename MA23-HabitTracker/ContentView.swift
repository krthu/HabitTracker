//
//  ContentView.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//
import SwiftData
import SwiftUI

struct ContentView: View {
    
    @Environment(\.modelContext) var modelContext
    @Query var habits: [Habit]
    var viewModel = ViewModel()
    
    var lastOpenedKey = "lastOpened"
    
    
    var body: some View {
        TabView{
            
            TodayListView()
                .tabItem {
                    Label("Today", systemImage: "\(viewModel.getSymbol(for:Date())).square")
                    
                }
            
            HabitsListView()
                .tabItem{
                    Label("Habits", systemImage: "list.bullet.rectangle.portrait")
                }
        }
        .onAppear{
            setStreaks()
            
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            setStreaks()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            viewModel.saveLastOpenDate()
        }
    }
    func setStreaks(){
        if !viewModel.openOnSameDay(){
            for habit in habits{
                habit.setCurrentStreak()
                
            }
        }
        
    }

}

extension ContentView{
    class ViewModel{
        
        var lastOpenedKey = "lastOpened"
        func getSymbol(for date: Date) -> String{
            let components = Calendar.current.dateComponents([.day], from: date)
            if let day = components.day{
                return String(day)
            }
            return "0"
        }
        
        func saveLastOpenDate(){
            
            UserDefaults.standard.set(Date(), forKey: lastOpenedKey)
        }
        
        func openOnSameDay() -> Bool{
            if let lastOpendDate = UserDefaults.standard.object(forKey: lastOpenedKey) as? Date{
                let dateManager = DateManager()
  
                return dateManager.isSameDay(firstDate: lastOpendDate, secoundDate: Date())
            }
            return false
        }
    }
}

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
