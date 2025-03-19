//
//  NotificationHelper.swift
//  OtpScatcher
//
//  Created by Arumugam Jeganathan on 3/18/25.
//

import Foundation
import UserNotifications
import os

struct NotificationHelper {
    private static let logger = Logger(subsystem: "Notification", category: "UI")
    private static var oldNotificationCode = ""

    static func sendNotification(currentCode: String) async {
        if currentCode == oldNotificationCode { return }
        oldNotificationCode = currentCode
        let content = UNMutableNotificationContent()
        content.title = "Security code received"
        content.body = "Dectected code \(currentCode)"
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let uuidString = UUID().uuidString

        let request = UNNotificationRequest(
            identifier: uuidString, content: content, trigger: trigger)

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        let settings = await notificationCenter.notificationSettings()

        // Verify the authorization status.
        if (settings.authorizationStatus == .authorized)
            || (settings.authorizationStatus == .provisional)
        {
            do {
                try await notificationCenter.add(request)
                logger.debug("Notification scheduled successfully")
            } catch {
                logger.error("Failed to add notification: \(error.localizedDescription)")
            }
        } else {
            do {
                try await notificationCenter.requestAuthorization(options: [.alert, .provisional])
            } catch {
                logger.error("Failed to add notification: \(error.localizedDescription)")
            }
        }
    }
}
