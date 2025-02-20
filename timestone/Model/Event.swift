//
//  Event.swift
//  timestone
//
//  Created by 조성빈 on 1/8/25.
//

import Foundation

struct Event: Hashable {
    let title: String?
    let alarm: Bool
    let startTime: String
    let endTime: String
    let notes: String?
    let url: URL?
    let location: String?
    let images: [String]?
}

struct EventInfo {
    let dummyEvents: [Event] = [
        Event(
            title: "아침 요가",
            alarm: true,
            startTime: "2025-02-02 06:30:00",
            endTime: "2025-02-02 07:30:00",
            notes: "Start your day with some relaxing yoga.",
            url: URL(string: "https://yoga.com/morning-session"),
            location: "Yoga Center, 123 Wellness St.",
            images: ["yoga1.jpg", "yoga2.jpg"]
        ),
        Event(
            title: "점심 요가",
            alarm: true,
            startTime: "2025-02-02 12:30:00",
            endTime: "2025-02-02 13:30:00",
            notes: "Midday yoga for relaxation.",
            url: URL(string: "https://yoga.com/lunch-session"),
            location: "Yoga Center, 123 Wellness St.",
            images: ["yoga1.jpg", "yoga2.jpg"]
        ),
        Event(
            title: "저녁 요가",
            alarm: true,
            startTime: "2025-02-02 18:30:00",
            endTime: "2025-02-02 19:30:00",
            notes: "Unwind with evening yoga.",
            url: URL(string: "https://yoga.com/evening-session"),
            location: "Yoga Center, 123 Wellness St.",
            images: ["yoga1.jpg", "yoga2.jpg"]
        ),
        Event(
            title: "Team Meeting",
            alarm: true,
            startTime: "2025-02-05 10:00:00",
            endTime: "2025-02-05 11:00:00",
            notes: "Weekly team sync-up to discuss ongoing projects.",
            url: URL(string: "https://zoom.com/meeting123"),
            location: "Office Room 301",
            images: nil
        ),
        Event(
            title: "Project Deadline",
            alarm: true,
            startTime: "2025-02-07 17:00:00",
            endTime: "2025-02-07 17:00:00",
            notes: "Submit all project files to the client.",
            url: nil,
            location: nil,
            images: ["deadline.jpg"]
        ),
        Event(
            title: "요리 수업",
            alarm: false,
            startTime: "2025-02-08 19:00:00",
            endTime: "2025-02-08 21:00:00",
            notes: "Learn to cook Italian cuisine.",
            url: URL(string: "https://cookingclass.com/register"),
            location: "Cooking Academy, 789 Culinary St.",
            images: ["cooking1.jpg", "cooking2.jpg"]
        ),
        Event(
            title: "Conference Call",
            alarm: true,
            startTime: "2025-02-09 14:00:00",
            endTime: "2025-02-09 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "Movie Night",
            alarm: false,
            startTime: "2025-02-09 20:00:00",
            endTime: "2025-02-09 22:30:00",
            notes: "Watch the latest blockbuster movie.",
            url: nil,
            location: "Cinema Hall, 15 Entertainment Plaza",
            images: ["movie.jpg"]
        ),
        Event(
            title: "Birthday Party",
            alarm: false,
            startTime: "2025-02-10 18:00:00",
            endTime: "2025-02-10 21:00:00",
            notes: "Celebrate John's 30th birthday.",
            url: nil,
            location: "John's House, 67 Celebration Dr.",
            images: ["party1.jpg", "party2.jpg"]
        ),
        Event(
            title: "Hiking Trip",
            alarm: true,
            startTime: "2025-02-11 07:00:00",
            endTime: "2025-02-11 12:00:00",
            notes: "Explore the scenic mountain trails.",
            url: URL(string: "https://hikingclub.com/event789"),
            location: "Mountain Base, Trailhead Parking Lot",
            images: ["hiking.jpg"]
        ),
        Event(
            title: "정보처리기사 공부",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "nilworks 회의",
            alarm: true,
            startTime: "2025-02-13 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "알바",
            alarm: true,
            startTime: "2025-02-12 14:00:00",
            endTime: "2025-02-13 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "알바2",
            alarm: true,
            startTime: "2025-03-01 14:00:00",
            endTime: "2025-03-01 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "알바3",
            alarm: true,
            startTime: "2025-03-01 14:00:00",
            endTime: "2025-03-01 15:00:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        )
    ]
}
