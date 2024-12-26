//
//  timestoneApp.swift
//  timestone
//
//  Created by 이상민 on 12/19/24.
//

import SwiftUI

@main
struct timestoneApp: App {
    @StateObject private var calendarVM = CalendarVM()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(calendarVM)
        }
    }
}
