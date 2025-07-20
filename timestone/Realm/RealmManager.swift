//
//  RealmManager.swift
//  timestone
//
//  Created by 조성빈 on 7/20/25.
//

import RealmSwift
import Foundation

class RealmManager {
    static let shared = RealmManager()
    
    
}

class EventRealm: Object {
    @Persisted(primaryKey: true) var id: ObjectId
    
    @Persisted var title: String?
    @Persisted var alarm: Bool
    @Persisted var startTime: String
    @Persisted var endTime: String
    @Persisted var notes: String?
    @Persisted var urlString: String? // @Persisted에는 URL 타입이 지원되지 않음.
    @Persisted var location: String?
    @Persisted var images: List<String>
    
    var url: URL? {
        if let urlString = urlString {
            return URL(string: urlString)
        }
        return nil
    }
}
