//
//  NotificationManager.swift
//  MA23-HabitTracker
//
//  Created by Kristian Thun on 2024-04-28.
//

import Foundation
import UserNotifications

class NotificationManager: NSObject, UNUserNotificationCenterDelegate {
    let notifikationsCenter = UNUserNotificationCenter.current()
    
    func requestAuthorization(completion: @escaping (Bool) -> Void){
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        
        notifikationsCenter.requestAuthorization(options: options) { (didAllow, error) in
            if let error = error {
                print("Error: \(error)")
                completion(false)
                
            } else {
                if didAllow{
                    
                    completion(true)
                } else {
                    
                    completion(false)
                }
            }
        }
    }
    
    func addNotifikation(title: String, subTitle: String, dateComponents: DateComponents, identifier: String){
        let title = title
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = subTitle
        content.sound = .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
        
        removeNotifikation(with: identifier)
        notifikationsCenter.add(request)
        
        
    }
    
    func removeNotifikation(with identifier: String){
        notifikationsCenter.removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.banner, .sound])
        
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: () -> Void) {
        
        completionHandler()
    }
    
}
