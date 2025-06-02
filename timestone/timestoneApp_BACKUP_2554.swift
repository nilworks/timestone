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
<<<<<<< HEAD
                    SDKInitializer.InitSDK(appKey: Bundle.main.infoDictionary?["KAKAO_APP_KEY"] as! String)
=======
                    SDKInitializer.InitSDK(appKey: APIKey.KAKAO_APP_KEY)
>>>>>>> 4355cdd63eb58986ef4f310a8399e007d3b94bcf
                }
        }
    }
}
