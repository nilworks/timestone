//
//  timestoneApp.swift
//  timestone
//
//  Created by 이상민 on 12/19/24.
//

import SwiftUI
import KakaoMapsSDK

@main
struct timestoneApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    SDKInitializer.InitSDK(appKey: Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as! String)
                }
        }
    }
}
