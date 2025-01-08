//
//  Event.swift
//  timestone
//
//  Created by 조성빈 on 1/8/25.
//

import Foundation

struct Event {
    let title: String?
    let alarm: Bool
    let startTime: String
    let endTime: String
    let notes: String?
    let url: URL?
    let location: String?
    let images: [String]?
}
