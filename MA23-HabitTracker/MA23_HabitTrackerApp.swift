//
//  MA23_HabitTrackerApp.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-22.
//
import SwiftData
import SwiftUI

@main
struct MA23_HabitTrackerApp: App {
    

    var center = NotificationManager()
    init(){
        UNUserNotificationCenter.current().delegate = center
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
               
        }
        .modelContainer(for: Habit.self)
    }
}

