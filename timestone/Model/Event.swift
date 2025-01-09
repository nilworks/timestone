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

struct EventInfo {
    let dummyEvents: [Event] = [
        Event(
            title: "Morning Yoga",
            alarm: true,
            startTime: "2025-01-08T06:30",
            endTime: "2025-01-08T07:30",
            notes: "Start your day with some relaxing yoga.",
            url: URL(string: "https://yoga.com/morning-session"),
            location: "Yoga Center, 123 Wellness St.",
            images: ["yoga1.jpg", "yoga2.jpg"]
        ),
        Event(
            title: "Team Meeting",
            alarm: true,
            startTime: "2025-01-08T10:00",
            endTime: "2025-01-08T11:00",
            notes: "Weekly team sync-up to discuss ongoing projects.",
            url: URL(string: "https://zoom.com/meeting123"),
            location: "Office Room 301",
            images: nil
        ),
        Event(
            title: "Lunch with Sarah",
            alarm: false,
            startTime: "2025-01-08T12:30",
            endTime: "2025-01-08T13:30",
            notes: nil,
            url: nil,
            location: "Cafe Aroma, 45 Maple St.",
            images: nil
        ),
        Event(
            title: "Project Deadline",
            alarm: true,
            startTime: "2025-01-08T17:00",
            endTime: "2025-01-08T17:00",
            notes: "Submit all project files to the client.",
            url: nil,
            location: nil,
            images: ["deadline.jpg"]
        ),
        Event(
            title: "Cooking Class",
            alarm: false,
            startTime: "2025-01-08T19:00",
            endTime: "2025-01-08T21:00",
            notes: "Learn to cook Italian cuisine.",
            url: URL(string: "https://cookingclass.com/register"),
            location: "Cooking Academy, 789 Culinary St.",
            images: ["cooking1.jpg", "cooking2.jpg"]
        ),
        Event(
            title: "Dentist Appointment",
            alarm: true,
            startTime: "2025-01-09T08:30",
            endTime: "2025-01-09T09:00",
            notes: "Routine dental check-up.",
            url: nil,
            location: "Smile Dental, 22 Health Ave.",
            images: nil
        ),
        Event(
            title: "Conference Call",
            alarm: true,
            startTime: "2025-01-09T14:00",
            endTime: "2025-01-09T15:00",
            notes: "Discuss partnership opportunities.",
            url: URL(string: "https://conference.com/call456"),
            location: nil,
            images: nil
        ),
        Event(
            title: "Movie Night",
            alarm: false,
            startTime: "2025-01-09T20:00",
            endTime: "2025-01-09T22:30",
            notes: "Watch the latest blockbuster movie.",
            url: nil,
            location: "Cinema Hall, 15 Entertainment Plaza",
            images: ["movie.jpg"]
        ),
        Event(
            title: "Birthday Party",
            alarm: false,
            startTime: "2025-01-10T18:00",
            endTime: "2025-01-10T21:00",
            notes: "Celebrate John's 30th birthday.",
            url: nil,
            location: "John's House, 67 Celebration Dr.",
            images: ["party1.jpg", "party2.jpg"]
        ),
        Event(
            title: "Hiking Trip",
            alarm: true,
            startTime: "2025-01-11T07:00",
            endTime: "2025-01-11T12:00",
            notes: "Explore the scenic mountain trails.",
            url: URL(string: "https://hikingclub.com/event789"),
            location: "Mountain Base, Trailhead Parking Lot",
            images: ["hiking.jpg"]
        )
    ]
}
