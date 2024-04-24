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
                
                HabitsListView(habitsVM: habitsVM)
                    .tabItem{
                        Label("Habits", systemImage: "list.bullet.rectangle.portrait")
                    }
                
                
      
            


           
        }
        .onAppear(){
            print(getSymbol(for: Date()))
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


#Preview {
    ContentView()
}
