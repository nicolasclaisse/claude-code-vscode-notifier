import Foundation
import UserNotifications

guard CommandLine.arguments.count >= 3 else {
    print("Usage: ClaudeNotifier <title> <message>")
    exit(1)
}

let title = CommandLine.arguments[1]
let body = CommandLine.arguments[2]

let center = UNUserNotificationCenter.current()

center.requestAuthorization(options: [.alert, .sound]) { granted, _ in
    guard granted else { exit(1) }

    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default

    let request = UNNotificationRequest(
        identifier: UUID().uuidString,
        content: content,
        trigger: nil
    )

    center.add(request) { _ in
        Thread.sleep(forTimeInterval: 1.0)
        exit(0)
    }
}

RunLoop.main.run()
