//
//  EventError.swift
//  sonder
//
//  Created by Bryan Sample on 12/15/25.
//

enum EventError: Error {
    case invalidTitle
    case invalidDescription
    case invalidStartTime
    case invalidEndTime
    case cannotAddTimeToDate
}
