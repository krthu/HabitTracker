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

    var body: some View {
        TabView{
   
            TodayListView()
                .tabItem {
                    Label("Today", systemImage:
                            "\(getSymbol(for:Date())).square")
                        
                }
            
            HabitsListView()
                .tabItem{
                    Label("Habits", systemImage: "list.bullet.rectangle.portrait")
                }
        }
        .onAppear{
//            do {
//                try modelContext.delete(model: Habit.self)

//            } catch {
//                print("Failed to clear all Country and City data.")
//            }
        //    addMockData()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
        // Need to fix this In today list
//habitsVM.today = Date()
            print("Changed Date")
        }
    
        
    }
    func getSymbol(for date: Date) -> String{
        let components = Calendar.current.dateComponents([.day], from: date)
        if let day = components.day{
            return String(day)
        }
        return "0"
    }
    
    func addMockData(){
        var data: [Habit] = []
        
        data.append(Habit(name: "Löp 5km", createdAt: getDate(year: 2024, month: 2, day: 2), doneDays: [getDate(year: 2024, month: 4, day: 21), getDate(year: 2024, month: 4, day: 22), getDate(year: 2024, month: 4, day: 23), getDate(year: 2024, month: 4, day: 24)]))

        data.append(Habit(name: "Gå 10 000 steg", createdAt: getDate(year: 2024, month: 2, day: 5), doneDays: [
            getDate(year: 2024, month: 4, day: 21),
            getDate(year: 2024, month: 4, day: 24),
            getDate(year: 2024, month: 5, day: 1),
            getDate(year: 2024, month: 5, day: 2)
        ]))

        data.append(Habit(name: "Drick 2 liter vatten", createdAt: getDate(year: 2024, month: 2, day: 10), doneDays: [
            getDate(year: 2024, month: 4, day: 25),
            getDate(year: 2024, month: 4, day: 26),
            getDate(year: 2024, month: 4, day: 27),
            getDate(year: 2024, month: 4, day: 28)
        ]))

        data.append(Habit(name: "Läs 30 minuter", createdAt: getDate(year: 2024, month: 2, day: 15), doneDays: [
            getDate(year: 2024, month: 4, day: 22),
            getDate(year: 2024, month: 4, day: 23),
            getDate(year: 2024, month: 4, day: 24),
            getDate(year: 2024, month: 4, day: 27)
        ]))

        
        
        
        for habit in data {
            modelContext.insert(habit)
        }
    }
    func getDate(year: Int, month: Int, day: Int ) -> Date{
        let calendar = Calendar.current
 
        
        if let date = calendar.date(from: DateComponents(year: year, month: month, day: day)){
            print(date)
            return date
          
        }
        return Date()
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
