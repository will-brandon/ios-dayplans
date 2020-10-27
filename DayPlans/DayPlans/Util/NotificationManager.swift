//
//  NotificationManager.swift
//  DayPlans
//
//  Created by Will Brandon on 9/18/20.
//  Copyright © 2020 Will Brandon. All rights reserved.
//

import Foundation
import UserNotifications

class NotificationManager {
    
    static let current = NotificationManager()
    
    private var notificationCenter: UNUserNotificationCenter { UNUserNotificationCenter.current() }
    
    private var notificationAuthorizationWasApproved_mutable: Bool?
    var notificationAuthorizationWasApproved: Bool? { notificationAuthorizationWasApproved_mutable }
    
    private init() {
        notificationAuthorizationWasApproved_mutable = nil
    }
    
    func requestNotificationAuthorization() {
        notificationCenter.requestAuthorization(options: Properties.NOTIFICATION_AUTHORIZATION_OPTIONS, completionHandler: {
            (didAuthorize: Bool, error: Error?) in
            self.notificationAuthorizationWasApproved_mutable = didAuthorize
            if error != nil {
                Console.error(error!)
            }
        })
    }
    
    func notificationIsQueued(withID id: String) -> Bool {
        var notificationIsQueued = false
        var completionHandlerDidExecute = false
        notificationCenter.getPendingNotificationRequests(completionHandler: {
            (requests) in
            for request in requests {
                if request.identifier == id {
                    notificationIsQueued = true
                    completionHandlerDidExecute = true
                    return
                }
            }
            completionHandlerDidExecute = true
        })
        while !completionHandlerDidExecute {
            print("Waiting")
        }
        return notificationIsQueued
    }
    
    func queueNotification(atCalendarLocation dateComponents: DateComponents, id: String, title: String, body: String? = nil, sound: UNNotificationSound? = nil) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body ?? ""
        content.sound = sound ?? .default
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        notificationCenter.add(request, withCompletionHandler: {
            (error: Error?) in
            if error != nil {
                Console.error(error!)
            }
        })
    }
    
    func queueNotification(atDateTime dateTime: DateTime, id: String, title: String, body: String? = nil, sound: UNNotificationSound? = nil) {
        let dateComponents = DateUtil.dateComponents(fromDateTime: dateTime)!
        queueNotification(atCalendarLocation: dateComponents, id: id, title: title, body: body, sound: sound)
    }
    
    func unqueueNotification(withID id: String) {
        notificationCenter.removePendingNotificationRequests(withIdentifiers: [id])
    }
    
}
