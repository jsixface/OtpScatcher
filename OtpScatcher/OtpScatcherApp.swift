import SwiftUI
import os

private let logger = Logger(subsystem: "MainMenu", category: "UI")

@main
struct OtpScatcherApp: App {

    init() {
        Task.init {
            for await code in MessageProcessor.codes {
                if let authCode = code.code {
                    copyToClipboard(code: authCode)
                    await NotificationHelper.sendNotification(currentCode: authCode)
                }
            }
        }
    }

    var body: some Scene {
        MenuBarExtra("Otp Scatcher", systemImage: "message.badge") {

            Button("Test Notification") {
                Task.init {
                    await NotificationHelper.sendNotification(currentCode: "0000")
                }
            }
            Divider()
            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
    }
}

private func copyToClipboard(code: String) {
    let pasteboard = NSPasteboard.general
    pasteboard.clearContents()
    pasteboard.setString(code, forType: .string)
}
