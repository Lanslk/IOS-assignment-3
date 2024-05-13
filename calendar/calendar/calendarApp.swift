//
//  calendarApp.swift
//  calendar
//
//  Created by yuteng Lan on 2024/5/8.
//

import SwiftUI
import SwiftData

@main
struct calendarApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .modelContainer(for: Activity.self)
        }
    }
}
